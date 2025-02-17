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
    'https://youtube.com/shorts/6cymxn3Jo-o?si=VAhM0do_gCHPu9yq', // Replace with actual YouTube Shorts URLs
    "https://youtube.com/shorts/WsZ6YG51gbM?si=-DgAasmdJcZThXsP",
    "https://youtube.com/shorts/e5X4MTsHSxA?si=zjSR3jWisXbQX3oq",
  ];

  late PageController _pageController;
  late YoutubePlayerController _ytController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    _ytController = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(videoUrls[0])!,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        loop: false,
      ),
    );
  }

  void _loadVideo(int index) {
    _ytController.load(YoutubePlayer.convertUrlToId(videoUrls[index])!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        controller: _pageController,
        itemCount: videoUrls.length,
        onPageChanged: (index) => _loadVideo(index),
        itemBuilder: (context, index) {
          return Stack(
            children: [
              YoutubePlayer(
                aspectRatio: Get.width / Get.height,
                controller: _ytController,
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
                    Text("video demo captation",
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
                    SizedBox(
                      height: 30,
                      width: 30,
                      child: Material(
                        shape:
                            const CircleBorder(), // Optional: Make the button round
                        child: IconButton(
                          padding: const EdgeInsets.all(0),
                          splashRadius: 1,
                          onPressed: () {},
                          icon: const Icon(
                            Icons.favorite,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 30,
                      width: 30,
                      child: Material(
                        shape:
                            const CircleBorder(), // Optional: Make the button round
                        child: IconButton(
                          padding: const EdgeInsets.all(0),
                          splashRadius: 1,
                          onPressed: () {},
                          icon: const Icon(
                            Icons.comment,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 30,
                      width: 30,
                      child: Material(
                        shape:
                            const CircleBorder(), // Optional: Make the button round
                        child: IconButton(
                          padding: const EdgeInsets.all(0),
                          splashRadius: 1,
                          onPressed: () {},
                          icon: const Icon(
                            Icons.share,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _ytController.dispose();
    _pageController.dispose();
    super.dispose();
  }
}
