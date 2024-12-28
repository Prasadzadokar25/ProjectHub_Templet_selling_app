import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:projecthub/utils/screen_size.dart';
import 'package:projecthub/utils/app_shared_preferences.dart';
import 'package:projecthub/view/app_navigation_bar.dart/app_navigation_bar.dart';
import 'package:projecthub/view/slider_screen/slider_screen.dart';
import '../login/login_screen.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({Key? key}) : super(key: key);

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    getIntro();
  }

  getIntro() async {
    bool isIntro = await PrefData.getIntro();
    bool isLogin = await PrefData.getLogin();

    if (isIntro == false) {
      Timer(const Duration(seconds: 3), () => Get.to(const SlidePage()));
    } else if (isLogin == false) {
      Get.to(const LoginScreen());
    } else {
      Get.to(const AppNavigationScreen());
    }
  }

  // PrefData.setVarification(true);

  @override
  Widget build(BuildContext context) {
    initializeScreenSize(context);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
              child: Container(
                  height: 95.h,
                  width: 95.h,
                  child: Image(
                    image:
                        const AssetImage("assets/images/education_image.png"),
                    fit: BoxFit.cover,
                  ))),
          Text(
            "Learn Management",
            style: TextStyle(
                fontSize: 28.sp,
                color: const Color(0XFF23408F),
                fontFamily: 'AvenirLTPro',
                fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
