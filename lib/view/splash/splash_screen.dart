import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:projecthub/view/app_navigation_bar.dart/app_navigation_bar.dart';
import 'package:provider/provider.dart';
import 'package:projecthub/app_providers/creation_provider.dart';
import 'package:projecthub/app_providers/user_provider.dart';
import 'package:projecthub/utils/screen_size.dart';
import 'package:projecthub/utils/app_shared_preferences.dart';
import 'package:projecthub/view/slider_screen/slider_screen.dart';
import 'package:projecthub/view/loading_screen.dart/loading_screen.dart';
import '../login/login_screen.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  bool _isLoading = true;
  bool? isIntro;
  int? isLoginId;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      isIntro = await PrefData.getIntro();
      isLoginId = await PrefData.getLogin();
      _navigateAfterSplash();

      if (isLoginId != null && isLoginId! > 0 && isIntro == true) {
        await Provider.of<UserInfoProvider>(context, listen: false)
            .fetchUserDetails(isLoginId!);
        await Provider.of<GeneralCreationProvider>(context, listen: false)
            .fetchGeneralCreations(isLoginId!, 1, 10);
        await Provider.of<RecentCreationProvider>(context, listen: false)
            .fetchRecentCreations(isLoginId!, 1, 10);
        await Provider.of<TreandingCreationProvider>(context, listen: false)
            .fetchTrendingCreations(isLoginId!, 1, 10);
      }

      setState(() {
        _isLoading = false;
      });
      _navigateAfterSplash();
      // Get.to(() => const AppNavigationScreen());
    } catch (e) {
      log("$e");
      Get.snackbar("Error with app server url", "Please notify developer team");
    }
  }

  void _navigateAfterSplash() {
    if (isIntro == false) {
      Timer(
        const Duration(seconds: 3),
        () => Get.to(() => const SlidePage()),
      );
    } else if (isLoginId == null || isLoginId == -1) {
      Get.offAll(() => const LoginScreen());
    } else if (!_isLoading) {
      Get.offAll(() => const AppNavigationScreen());
    } else {
      Timer(
        const Duration(seconds: 3),
        () {
          if (_isLoading) Get.offAll(() => LoadingScreen());
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    initializeScreenSize(context);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: SizedBox(
              height: 95.h,
              width: 95.h,
              child: Image.asset(
                "assets/images/education_image.png",
                fit: BoxFit.cover,
              ),
            ),
          ),
          Text(
            "PROJECT HUB",
            style: TextStyle(
              fontSize: 28.sp,
              color: const Color(0XFF23408F),
              fontFamily: 'AvenirLTPro',
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
