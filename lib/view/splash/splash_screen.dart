import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:projecthub/app_providers/user_provider.dart';
import 'package:projecthub/controller/user_controller.dart';
import 'package:projecthub/model/user_info_model.dart';
import 'package:projecthub/utils/screen_size.dart';
import 'package:projecthub/utils/app_shared_preferences.dart';
import 'package:projecthub/view/app_navigation_bar.dart/app_navigation_bar.dart';
import 'package:projecthub/view/slider_screen/slider_screen.dart';
import 'package:provider/provider.dart';
import '../login/login_screen.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  final UserController _userController = UserController();
  @override
  void initState() {
    super.initState();
    getIntro();
  }

  getIntro() async {
    bool isIntro = await PrefData.getIntro();
    int isLoginId = await PrefData.getLogin();

    if (isIntro == false) {
      Timer(const Duration(seconds: 3), () => Get.to(const SlidePage()));
    } else if (-1 == -1) {
      Get.to(const LoginScreen());
    } else {
      await Provider.of<UserInfoProvider>(context, listen: false)
          .fetchUserDetails(isLoginId);
      // if (userDetails['status']) {
      //   // ignore: use_build_context_synchronously
      //   Provider.of<UserInfoProvider>(context, listen: false).setUserInfo =
      //       UserModel.fromJson(userDetails['responce']['data']);

      Get.to(const AppNavigationScreen());
      // } else {
      //   Get.snackbar("App server error", "Please clear app cache");
      // }
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
              child: SizedBox(
                  height: 95.h,
                  width: 95.h,
                  child: Image.asset(
                    "assets/images/education_image.png",
                    fit: BoxFit.cover,
                  ))),
          Text(
            "PROJECT HUB",
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
