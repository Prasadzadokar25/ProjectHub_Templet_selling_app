import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../app_providers/reels_providel.dart';
import '../../app_providers/user_provider.dart';

class ShortsScreen extends StatefulWidget {
  @override
  _ShortsScreenState createState() => _ShortsScreenState();
}

class _ShortsScreenState extends State<ShortsScreen> {
  late PageController _pageController;
  late List<YoutubePlayerController?> _controllers;
  int _currentIndex = 0;
  bool _isFetchingMore = false;
  bool _isUserScrolling = false;
  double _scrollThreshold =
      100.0; // Minimum scroll distance to trigger page change

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 1.0);
    _controllers = [];

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadInitialReels();
    });
  }

  Future<void> _loadInitialReels() async {
    final reelsProvider = Provider.of<ReelsProvider>(context, listen: false);
    reelsProvider.reset();
    final userId =
        Provider.of<UserInfoProvider>(context, listen: false).user!.userId;

    await reelsProvider.fetchReels(userId);

    if (reelsProvider.reels != null && reelsProvider.reels!.isNotEmpty) {
      _controllers = List<YoutubePlayerController?>.filled(
          reelsProvider.reels!.length, null);
      _initializeController(0);
      _playCurrentVideo();
      _preloadVideos(0);
    }
  }

  void _initializeController(int index) {
    final reelsProvider = Provider.of<ReelsProvider>(context, listen: false);
    if (index < 0 || index >= reelsProvider.reels!.length) return;

    final url = reelsProvider.reels![index].youtubeLink;
    if (_controllers[index] != null || url == null || url.isEmpty) return;

    final videoId = YoutubePlayer.convertUrlToId(url);
    if (videoId == null) return;

    final controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        disableDragSeek: true,
        enableCaption: false,
      ),
    );

    controller.addListener(() {
      if (index == _currentIndex &&
          controller.value.playerState == PlayerState.ended) {
        _playNextVideo();
      }
    });

    _controllers[index] = controller;
  }

  void _preloadVideos(int index) {
    final reelsProvider = Provider.of<ReelsProvider>(context, listen: false);

    // Preload current, next and previous videos
    for (int i = index - 1; i <= index + 1; i++) {
      if (i >= 0 && i < reelsProvider.reels!.length) {
        _initializeController(i);
      }
    }
  }

  void _playCurrentVideo() {
    if (_currentIndex >= 0 && _currentIndex < _controllers.length) {
      _controllers[_currentIndex]?.play();
    }
  }

  void _pauseCurrentVideo() {
    if (_currentIndex >= 0 && _currentIndex < _controllers.length) {
      _controllers[_currentIndex]?.pause();
    }
  }

  void _onPageChanged(int index) async {
    // Pause previous video
    _pauseCurrentVideo();

    setState(() => _currentIndex = index);
    _isUserScrolling = false;

    // Initialize and play new video
    _initializeController(index);
    _playCurrentVideo();
    _preloadVideos(index);

    // Fetch more reels if we're near the end
    final reelsProvider = Provider.of<ReelsProvider>(context, listen: false);
    if (index >= reelsProvider.reels!.length - 3 && !_isFetchingMore) {
      _isFetchingMore = true;
      final userId =
          Provider.of<UserInfoProvider>(context, listen: false).user!.userId;

      await reelsProvider.fetchReels(userId);

      if (_controllers.length < reelsProvider.reels!.length) {
        _controllers += List<YoutubePlayerController?>.filled(
            reelsProvider.reels!.length - _controllers.length, null);
      }

      _isFetchingMore = false;
    }
  }

  void _playNextVideo() {
    if (_currentIndex + 1 < _controllers.length) {
      _pageController.animateToPage(
        _currentIndex + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _toggleLike(int index) {
    final provider = Provider.of<ReelsProvider>(context, listen: false);
    provider.toggleLike(index);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Consumer<ReelsProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading || provider.reels == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.reels!.isEmpty) {
            return const Center(
              child:
                  Text("No data found", style: TextStyle(color: Colors.white)),
            );
          }

          return GestureDetector(
            onVerticalDragUpdate: (details) {
              // Detect user scroll intent
              if (details.primaryDelta!.abs() > _scrollThreshold) {
                _isUserScrolling = true;
              }
            },
            onVerticalDragEnd: (details) {
              // Reset scroll state after a short delay
              Future.delayed(const Duration(milliseconds: 500), () {
                _isUserScrolling = false;
              });
            },
            child: PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              itemCount: provider.reels!.length,
              onPageChanged: _onPageChanged,
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              itemBuilder: (context, index) {
                final reel = provider.reels![index];
                final controller = _controllers[index];

                return Stack(
                  fit: StackFit.expand,
                  children: [
                    if (controller != null)
                      YoutubePlayer(
                        controller: controller,
                        aspectRatio: 9 / 16,
                        progressIndicatorColor: Colors.blue,
                        progressColors: const ProgressBarColors(
                          playedColor: Colors.red,
                          handleColor: Colors.red,
                        ),
                        onReady: () {
                          if (index == _currentIndex && !_isUserScrolling) {
                            controller.play();
                          }
                        },
                      )
                    else
                      const Center(child: CircularProgressIndicator()),

                    // User info and description
                    Positioned(
                      bottom: 80,
                      left: 16,
                      right: 80,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("@user${reel.userId}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              )),
                          const SizedBox(height: 8),
                          Text(reel.creationTitle,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              )),
                        ],
                      ),
                    ),

                    // Action buttons
                    Positioned(
                      bottom: 80,
                      right: 16,
                      child: Column(
                        children: [
                          IconButton(
                            icon: reel.isLikedByUser
                                ? Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                    size: 32,
                                  )
                                : Icon(
                                    Icons.favorite_border_outlined,
                                    size: 32,
                                    color: Colors.white,
                                    shadows: [
                                      BoxShadow(
                                          color: Colors.black45,
                                          blurRadius: 0.2,
                                          spreadRadius: 0.01)
                                    ],
                                  ),
                            onPressed: () => _toggleLike(index),
                          ),
                          Text("${reel.likeCount}",
                              style: const TextStyle(color: Colors.white)),
                          const SizedBox(height: 16),
                          const Icon(Icons.comment,
                              color: Colors.white, size: 32),
                          const SizedBox(height: 16),
                          const Icon(Icons.share,
                              color: Colors.white, size: 32),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller?.dispose();
    }
    _pageController.dispose();
    super.dispose();
  }
}
