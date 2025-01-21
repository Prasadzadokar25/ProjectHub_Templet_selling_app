// ignore_for_file: non_constant_identifier_names, deprecated_member_use

import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:projecthub/app_providers/user_provider.dart';
import 'package:projecthub/constant/app_color.dart';
import 'package:projecthub/controller/login_controller.dart';
import 'package:projecthub/utils/app_shared_preferences.dart';
import 'package:projecthub/view/app_navigation_bar/app_navigation_bar.dart';
import 'package:projecthub/widgets/app_primary_button.dart';
import 'package:provider/provider.dart';
import '../../app_providers/creation_provider.dart';
import '../../constant/app_text.dart';
import '../../constant/app_textfield_border.dart';
import '../loading_screen.dart/loading_screen.dart';
import '../login/forgot_password.dart';
import 'sign_up/sign_in_phonenumber.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formkey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final LoginController _loginController = LoginController();

  bool _showCircularIndicater = false;
  bool ispassHiden = false;
  bool _isSubmitPressedOnce = false;
  fetchData(int uid) async {
    await Provider.of<UserInfoProvider>(context, listen: false)
        .fetchUserDetails(uid);
    await Provider.of<GeneralCreationProvider>(context, listen: false)
        .fetchGeneralCreations(uid, 1, 10);
    await Provider.of<RecentCreationProvider>(context, listen: false)
        .fetchRecentCreations(uid, 1, 10);
    await Provider.of<TreandingCreationProvider>(context, listen: false)
        .fetchTrendingCreations(uid, 1, 10);
  }

  checkLogindetails() async {
    setState(() {
      _isSubmitPressedOnce = true;
    });
    FocusScope.of(context).unfocus();
    if (formkey.currentState!.validate()) {
      setState(() {
        _showCircularIndicater = true;
      });
      final res = await _loginController.checkLogindetails(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
      setState(() {
        _showCircularIndicater = false;
      });
      if (res['status'] == 'True') {
        log(res['data'][0].toString());
        // ignore: use_build_context_synchronously

        PrefData.setLogin(res['data'][0]['user_id']);
        PrefData.setIntro(true);

        // PrefData.setVarification(true);
        //Get.offAll(const AppNavigationScreen());
        // Navigate to the loading screen
        Get.offAll(() => LoadingScreen());

// Fetch data asynchronously
        await Future.delayed(Duration(microseconds: 100));
        await fetchData(res['data'][0]['user_id']);

// Once data is fetched, navigate to the next screen
        print("Navigating to AppNavigationScreen");
        Get.offAll(() => const AppNavigationScreen());
      } else {
        String numberTitle = "Mobile number/Email or Password is wrong";
        String emailTitle = "Email or Password is wrong";
        Get.snackbar(
            emailController.text.contains('@') ? emailTitle : numberTitle,
            "Please enter correct details");
      }
    }
  }

  toggle() {
    setState(() {
      ispassHiden = !ispassHiden;
    });
  }

  @override
  void dispose() {
    passwordController.dispose();
    emailController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: WillPopScope(
          onWillPop: () {
            return Future.value(false);
          },
          child: Padding(
            padding: EdgeInsets.only(left: 20.w, right: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.h),
                Expanded(
                  flex: 1,
                  child: ListView(
                    primary: true,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      SizedBox(height: 20.h),
                      Center(
                        child: Text(
                          "Login",
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 24.sp,
                              fontFamily: 'Gilroy',
                              color: const Color(0XFF000000)),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Center(
                          child: Text(
                        "Glad to meet you again!",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: const Color(0XFF000000),
                            fontSize: 15.sp,
                            fontFamily: 'Gilroy',
                            fontStyle: FontStyle.normal),
                        textAlign: TextAlign.center,
                      )),
                      SizedBox(height: 10.h),
                      email_password_form(),
                      SizedBox(height: 21.h),
                      forgotpassword(),
                      SizedBox(height: 40.h),
                      AppPrimaryElevetedButton(
                        onPressed: checkLogindetails,
                        title: "Log in",
                      ),
                      SizedBox(height: 40.h),
                      or_sign_in_with_text(),
                      SizedBox(height: 41.h),
                      login_google(),
                      SizedBox(height: 20.h),
                      login_facebook(),
                      SizedBox(height: 30.h),
                      if (_showCircularIndicater)
                        Center(
                          child: CircularProgressIndicator(
                            color: AppColor.primaryColor,
                          ),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 30.h),
                  child: sign_up(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget forgotpassword() {
    return GestureDetector(
      onTap: () {
        Get.to(const ForgotPassword());
      },
      child: Align(
        alignment: Alignment.topRight,
        child: Text(
          "Forgot password ?",
          style: TextStyle(
            fontFamily: 'Gilroy',
            fontWeight: FontWeight.w700,
            fontSize: 15.sp,
            color: const Color(0XFF23408F),
          ),
        ),
      ),
    );
  }

  Widget login_google() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 56.h,
        width: 374.w,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey.withOpacity(0.1)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(image: AssetImage("assets/images/google.png")),
            SizedBox(width: 10.w),
            Text(
              "Login with Google",
              style: TextStyle(
                color: const Color(0XFF000000),
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget login_facebook() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 56.h,
        width: 374.w,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey.withOpacity(0.1)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(image: AssetImage("assets/images/facebook.png")),
            SizedBox(width: 10.w),
            Text(
              "Login with Facebook",
              style: TextStyle(
                  color: const Color(0XFF000000),
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget sign_up() {
    return Center(
      child: RichText(
          text: TextSpan(
              text: 'Already have an account?',
              style: TextStyle(
                  color: Colors.black, fontSize: 15.sp, fontFamily: 'Gilroy'),
              children: [
            TextSpan(
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Get.to(const SignInPhonenumber());
                },
              text: '  Sign up',
              style: TextStyle(
                color: const Color(0XFF000000),
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
                fontFamily: 'Gilroy',
              ),
            )
          ])),
    );
  }

  Widget or_sign_in_with_text() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Divider(
            height: 0.h,
            thickness: 2,
            // indent: 20,
            endIndent: 020,
            color: const Color(0XFFDEDEDE),
          ),
        ),
        Text("Or Sign in with",
            style: TextStyle(
                color: const Color(0XFF000000),
                fontSize: 15.sp,
                fontWeight: FontWeight.w400,
                fontFamily: 'Gilroy',
                fontStyle: FontStyle.normal)),
        Expanded(
          child: Divider(
            height: 0.h,
            thickness: 2,
            indent: 20,
            endIndent: 0,
            color: const Color(0XFFDEDEDE),
          ),
        )
      ],
    );
  }

  Widget email_password_form() {
    return Form(
      key: formkey,
      child: Column(
        children: [
          TextFormField(
            onChanged: (value) {
              if (_isSubmitPressedOnce) {
                formkey.currentState!.validate();
              }
            },
            controller: emailController,
            decoration: InputDecoration(
              hintText: 'Mobile number / Email',
              hintStyle: AppText.textFieldHintTextStyle,
              focusedErrorBorder: AppTextfieldBorder.focusedErrorBorder,
              errorBorder: AppTextfieldBorder.errorBorder,
              focusedBorder: AppTextfieldBorder.focusedBorder,
              enabledBorder: AppTextfieldBorder.enabledBorder,
              filled: true,
              fillColor: const Color(0xFFF5F5F5),
              contentPadding:
                  EdgeInsets.only(left: 20.w, top: 20.h, bottom: 20.h),
            ),
            validator: (val) {
              if (val!.isEmpty) {
                return 'Enter Mobile number or email';
              } else {
                // if (!RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
                //     .hasMatch(val)) {
                //   return 'Please enter valid email address';
                // }
              }
              return null;
            },
          ),
          SizedBox(height: 15.h),
          TextFormField(
            onChanged: (value) {
              formkey.currentState!.validate();
            },
            controller: passwordController,
            obscureText: ispassHiden,
            decoration: InputDecoration(
                hintText: 'Password',
                hintStyle: AppText.textFieldHintTextStyle,
                focusedErrorBorder: AppTextfieldBorder.focusedErrorBorder,
                errorBorder: AppTextfieldBorder.errorBorder,
                focusedBorder: AppTextfieldBorder.focusedBorder,
                enabledBorder: AppTextfieldBorder.enabledBorder,
                filled: true,
                fillColor: const Color(0xFFF5F5F5),
                contentPadding:
                    EdgeInsets.only(left: 20.w, top: 20.h, bottom: 20.h),
                suffixIcon: ispassHiden
                    ? GestureDetector(
                        onTap: () => toggle(),
                        child: const Icon(
                          Icons.visibility,
                          color: Color.fromARGB(255, 171, 170, 170),
                        ))
                    : GestureDetector(
                        onTap: () => toggle(),
                        child: const Icon(
                          Icons.visibility_off,
                          color: Color.fromARGB(255, 171, 170, 170),
                        ))),
            validator: (val) {
              if (val!.isEmpty) {
                return 'Enter the  password';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
