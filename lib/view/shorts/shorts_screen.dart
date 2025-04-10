import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:projecthub/app_providers/reels_providel.dart';
import 'package:projecthub/app_providers/user_provider.dart';
import 'package:projecthub/model/reel_model.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ReelsScreen extends StatefulWidget {
  const ReelsScreen({super.key});

  @override
  State<ReelsScreen> createState() => _ReelsScreenState();
}

class _ReelsScreenState extends State<ReelsScreen> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final PageController _pageController = PageController();
  List<String> videoIds = [];
  List<ReelModel> reels = [];
  int _currentPage = 0;
  bool _isLoading = true;

  // Sample YouTube video IDs

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchVideos(true);
    });
  }

  String extractVideoId(String urlOrId) {
    final uri = Uri.tryParse(urlOrId);
    if (uri == null || !uri.isAbsolute) return urlOrId;

    if (uri.host.contains("youtube.com")) {
      if (uri.pathSegments.contains("watch")) {
        return uri.queryParameters["v"] ?? urlOrId;
      } else if (uri.pathSegments.contains("shorts") ||
          uri.pathSegments.contains("embed") ||
          uri.pathSegments.contains("v")) {
        return uri.pathSegments.last;
      }
    } else if (uri.host.contains("youtu.be")) {
      return uri.pathSegments.first;
    }

    return urlOrId;
  }

  Future<void> _fetchVideos([bool isFirstCall = false]) async {
    setState(() => _isLoading = true);
    final userProvider = Provider.of<UserInfoProvider>(context, listen: false);
    final reelProvider = Provider.of<ReelsProvider>(context, listen: false);
    if (isFirstCall) {
      reelProvider.reset();
    }
    await reelProvider.fetchReels(userProvider.user!.userId);
    setState(() {
      _isLoading = false;
    });
  }

  void _onRefresh() async {
    await _fetchVideos();
    _refreshController.refreshCompleted();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Consumer<ReelsProvider>(builder: (context, provider, child) {
      if (_isLoading || provider.isLoading) {
        return _buildShimmerLoader();
      }
      if (provider.errorMassage != null) {
        return Center(
          child: Text(provider.errorMassage!),
        );
      }
      return SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        onRefresh: _onRefresh,
        child: PageView.builder(
          physics: const BouncingScrollPhysics(),
          controller: _pageController,
          scrollDirection: Axis.vertical,
          itemCount: provider.reels!.length,
          onPageChanged: (index) {
            setState(() => _currentPage = index);
            if (index + 1 < provider.reels!.length) {
              // Preload next video
              final nextId =
                  extractVideoId(provider.reels![index + 1].youtubeLink!);
              YoutubePlayerController tempController = YoutubePlayerController(
                initialVideoId: nextId,
                flags: const YoutubePlayerFlags(autoPlay: false),
              );
              tempController.load(nextId);
              Future.delayed(
                  const Duration(seconds: 1), () => tempController.dispose());
            }
            if (index == provider.reels!.length - 2) {
              _fetchVideos();
            }
          },
          itemBuilder: (context, index) {
            return VideoItem(
              isCurrent: index == _currentPage,
              reel: provider.reels![index],
            );
          },
        ),
      );
    }
            //  _isLoading
            //     ? _buildShimmerLoader()
            //     : SmartRefresher(
            //         controller: _refreshController,
            //         enablePullDown: true,
            //         onRefresh: _onRefresh,
            //         child: PageView.builder(
            //           controller: _pageController,
            //           scrollDirection: Axis.vertical,
            //           itemCount: videoIds.length,
            //           onPageChanged: (index) {
            //             setState(() => _currentPage = index);
            //           },
            //           itemBuilder: (context, index) {
            //             return VideoItem(
            //               videoId: extractVideoId(videoIds[index]),
            //               isCurrent: index == _currentPage,
            //             );
            //           },
            //         ),
            //       ),
            ));
  }

  Widget _buildShimmerLoader() {
    return Stack(
      children: [
        // Full background placeholder
        Container(
          width: double.infinity,
          height: double.infinity,
          color: Color.fromARGB(255, 33, 33, 33),
        ),
        // Bottom-left: Title and Description
        Positioned(
          left: 16,
          bottom: 80,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey[800]!,
                highlightColor: Colors.grey[700]!,
                child: Container(
                  width: 200,
                  height: 16,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Shimmer.fromColors(
                baseColor: Colors.grey[800]!,
                highlightColor: Colors.grey[700]!,
                child: Container(
                  width: 150,
                  height: 14,
                  color: const Color.fromARGB(255, 98, 97, 97),
                ),
              ),
            ],
          ),
        ),
        // Bottom-right: Like, Comment, Share buttons
        Positioned(
          right: 16,
          bottom: 180,
          child: Column(
            children: [
              _shimmerIconBox(), // Like
              const SizedBox(height: 16),
              _shimmerIconBox(), // Comment
              const SizedBox(height: 16),
              _shimmerIconBox(), // Share
              const SizedBox(height: 16),
              _shimmerIconBox(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _shimmerIconBox() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[800]!,
      highlightColor: const Color.fromARGB(255, 89, 89, 89)!,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 65, 64, 64),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class VideoItem extends StatefulWidget {
  ReelModel reel;
  final bool isCurrent;

  VideoItem({
    required this.isCurrent,
    required this.reel,
    Key? key,
  }) : super(key: key);

  @override
  State<VideoItem> createState() => _VideoItemState();
}

class _VideoItemState extends State<VideoItem> {
  late YoutubePlayerController _controller;
  bool _isPlayerReady = false;
  bool _showControls = false;
  bool _showHeart = false;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: extractVideoId(widget.reel.youtubeLink!),
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        hideControls: true,
        enableCaption: false,
        disableDragSeek: true,
        loop: true,
      ),
    )..addListener(_listener);
  }

  void _listener() {
    if (_isPlayerReady && !_controller.value.isFullScreen) {
      if (_controller.value.playerState == PlayerState.ended) {
        _controller.seekTo(Duration.zero);
      }
    }
  }

  @override
  void didUpdateWidget(covariant VideoItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.reel != widget.reel) {
      _controller.load(extractVideoId(widget.reel.youtubeLink!));
    }
    if (widget.isCurrent && !_controller.value.isPlaying) {
      _controller.play();
    } else if (!widget.isCurrent && _controller.value.isPlaying) {
      _controller.pause();
    }
  }

  String extractVideoId(String urlOrId) {
    final uri = Uri.tryParse(urlOrId);
    if (uri == null || !uri.isAbsolute) return urlOrId;

    if (uri.host.contains("youtube.com")) {
      if (uri.pathSegments.contains("watch")) {
        return uri.queryParameters["v"] ?? urlOrId;
      } else if (uri.pathSegments.contains("shorts") ||
          uri.pathSegments.contains("embed") ||
          uri.pathSegments.contains("v")) {
        return uri.pathSegments.last;
      }
    } else if (uri.host.contains("youtu.be")) {
      return uri.pathSegments.first;
    }

    return urlOrId;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() => _showControls = !_showControls);
      },
      onDoubleTap: () {
        Provider.of<ReelsProvider>(context, listen: F).toggleLike(
            widget.reel,
            Provider.of<UserInfoProvider>(context, listen: false).user!.userId,
            true);
        setState(() {
          _showHeart = true;
        });
        Future.delayed(const Duration(milliseconds: 600), () {
          setState(() => _showHeart = false);
        });
      },
      child: Stack(
        children: [
          // YouTube Player
          Positioned.fill(
            child: YoutubePlayer(
              controller: _controller,
              onReady: () {
                setState(() => _isPlayerReady = true);
                if (widget.isCurrent) {
                  _controller.play();
                }
              },
              onEnded: (metaData) {
                _controller.pause();

                if (widget.isCurrent) {
                  final parentState =
                      context.findAncestorStateOfType<_ReelsScreenState>();
                  if (parentState != null &&
                      parentState._currentPage <
                          parentState.videoIds.length - 1) {
                    // Delay the nextPage to avoid modifying listeners during dispose
                    Future.delayed(const Duration(milliseconds: 500), () {
                      parentState._pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                      );
                    });
                  }
                }
              },
            ),
          ),
          // Thumbnail overlay (shown before player is ready)
          if (!_isPlayerReady)
            CachedNetworkImage(
              imageUrl:
                  'https://img.youtube.com/vi/${extractVideoId(widget.reel.youtubeLink!)}/0.jpg',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              placeholder: (context, url) => Container(color: Colors.black),
              errorWidget: (context, url, error) =>
                  Container(color: Colors.black),
            ),

          // Loading indicator
          if (!_isPlayerReady)
            const Center(
              child: CircularProgressIndicator(color: Colors.red),
            ),

          // Video info overlay
          Positioned(
            bottom: 60,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  formatProper(
                      widget.reel.creationTitle), // Replace with actual title
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  formatProper(widget.reel
                      .creationDescription), // Replace with actual description
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          // Side action buttons
          Positioned(
            bottom: 100,
            right: 16,
            child: Column(
              children: [
                _buildActionButton(
                    (widget.reel.isLikedByUser)
                        ? Icons.favorite
                        : Icons.favorite_border_outlined,
                    (widget.reel.isLikedByUser) ? Colors.red : Colors.white,
                    widget.reel.likeCount.toString(), () {
                  Provider.of<ReelsProvider>(context, listen: F).toggleLike(
                      widget.reel,
                      Provider.of<UserInfoProvider>(context, listen: false)
                          .user!
                          .userId);
                }),
                const SizedBox(height: 20),
                _buildActionButton(
                    Icons.comment, Colors.white, 'Comment', () {}),
                const SizedBox(height: 20),
                _buildActionButton(Icons.share, Colors.white, 'Share', () {}),
                const SizedBox(height: 20),
                _buildActionButton(
                    Icons.more_vert, Colors.white, 'More', () {}),
              ],
            ),
          ),

          // Controls overlay
          if (_showControls && _isPlayerReady)
            Positioned.fill(
              child: Container(
                color: Colors.black54,
                child: Center(
                  child: IconButton(
                    icon: Icon(
                      _controller.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                      size: 50,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      if (_controller.value.isPlaying) {
                        _controller.pause();
                      } else {
                        _controller.play();
                      }
                    },
                  ),
                ),
              ),
            ),
          if (_showHeart)
            Center(
              child: AnimatedOpacity(
                opacity: _showHeart ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: const Icon(Icons.favorite,
                    size: 100, color: Colors.redAccent),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
      IconData icon, Color color, String label, onPressed) {
    return Column(
      children: [
        GestureDetector(
            onTap: onPressed, child: Icon(icon, size: 30, color: color)),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ],
    );
  }

  String formatProper(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1).toLowerCase();
  }
}
