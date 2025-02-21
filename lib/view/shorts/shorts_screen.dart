import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ShortsScreen extends StatefulWidget {
  @override
  _ShortsScreenState createState() => _ShortsScreenState();
}

class _ShortsScreenState extends State<ShortsScreen> {
  final List<String> videoUrls = [
    'https://youtube.com/shorts/6cymxn3Jo-o?si=VAhM0do_gCHPu9yq',
    "https://youtube.com/shorts/WsZ6YG51gbM?si=-DgAasmdJcZThXsP",
    "https://youtube.com/shorts/e5X4MTsHSxA?si=zjSR3jWisXbQX3oq",
    "https://youtube.com/shorts/WsZ6YG51gbM?si=-DgAasmdJcZThXsP",
    "https://youtube.com/shorts/e5X4MTsHSxA?si=zjSR3jWisXbQX3oq",
    "https://youtube.com/shorts/WsZ6YG51gbM?si=-DgAasmdJcZThXsP",
    "https://youtube.com/shorts/e5X4MTsHSxA?si=zjSR3jWisXbQX3oq",
  ];

  late PageController _pageController;
  late List<YoutubePlayerController?> _controllers;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _controllers = List.generate(videoUrls.length, (index) => null);

    // Initialize the first controller
    _initializeController(0);
    _controllers[0]?.play(); // Auto-play first video
  }

  void _initializeController(int index) {
    if (_controllers[index] == null) {
      _controllers[index] = YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(videoUrls[index])!,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
          loop: false,
        ),
      );
    }
  }

  void _onPageChanged(int index) {
    log("Page changed to: $index");

    // Pause the previous video
    if (_currentIndex >= 0 && _currentIndex < _controllers.length) {
      _controllers[_currentIndex]?.pause();
    }

    // Initialize and play the current video
    _initializeController(index);
    _controllers[index]?.play();

    setState(() => _currentIndex = index);

    // Preload next and previous videos
    _preloadVideos(index);
  }

  void _preloadVideos(int currentIndex) {
    // Preload next 3 videos
    for (int i = currentIndex + 1;
        i <= currentIndex + 3 && i < videoUrls.length;
        i++) {
      _initializeController(i);
    }

    // Preload previous 3 videos
    for (int i = currentIndex - 1; i >= currentIndex - 3 && i >= 0; i--) {
      _initializeController(i);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: PageView.builder(
          controller: _pageController,
          scrollDirection: Axis.vertical,
          itemCount: videoUrls.length,
          onPageChanged: _onPageChanged,
          itemBuilder: (context, index) {
            return Stack(
              children: [
                if (_controllers[index] != null)
                  YoutubePlayer(
                    aspectRatio: Get.width / Get.height,
                    controller: _controllers[index]!,
                    showVideoProgressIndicator: true,
                    progressIndicatorColor: Colors.red,
                  ),
                Positioned(
                  bottom: 20,
                  left: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("@username",
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                      Text("Video demo caption",
                          style: TextStyle(color: Colors.white, fontSize: 14)),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 50,
                  right: 10,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                          icon: Icon(Icons.favorite, color: Colors.white),
                          onPressed: () {}),
                      IconButton(
                          icon: Icon(Icons.comment, color: Colors.white),
                          onPressed: () {}),
                      IconButton(
                          icon: Icon(Icons.share, color: Colors.white),
                          onPressed: () {}),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
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
