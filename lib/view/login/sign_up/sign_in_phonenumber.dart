// ignore_for_file: deprecated_member_use, non_constant_identifier_names

import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:projecthub/constant/app_text.dart';
import 'package:projecthub/constant/app_textfield_border.dart';
import 'package:projecthub/controller/app_phone_number_controller.dart';
import 'package:projecthub/utils/screen_size.dart';
import 'package:projecthub/view/login/login_screen.dart';
import '../sign_up/verification_screen.dart';

class SignInPhonenumber extends StatefulWidget {
  const SignInPhonenumber({
    super.key,
  });

  @override
  State<SignInPhonenumber> createState() => _SignInPhonenumberState();
}

class _SignInPhonenumberState extends State<SignInPhonenumber> {
  final phoneNumberkey = GlobalKey<FormState>();
  final TextEditingController phoneNumberCheakController =
      TextEditingController();
  final AppPhoneNumberController _appPhoneNumberController =
      AppPhoneNumberController();

  bool _showCircularIndicater = false;
  PhoneNumber? phoneNumber;
  int otpLength = 6;

  String phoneNumberErrorMassege = "";

  sendOTP(String number) async {
    try {
      log("Attempting to send OTP to $number");
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: number,
        verificationCompleted: (PhoneAuthCredential credential) async {
          log("Phone number auto-verified");
          await FirebaseAuth.instance.signInWithCredential(credential);
          Get.snackbar(
            "Verification Complete",
            "Phone number verified successfully!",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: const Color.fromARGB(255, 233, 243, 252),
          );
        },
        verificationFailed: (FirebaseAuthException e) {
          setState(() {
            _showCircularIndicater = false;
          });

          log("Verification failed: ${e.message}");
          if (e.code == 'invalid-phone-number') {
            Get.snackbar(
              "Error",
              "The provided phone number is not valid.",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: const Color.fromARGB(255, 233, 243, 252),
            );
          } else {
            Get.snackbar(
              "Error",
              e.message ?? "Phone verification failed.",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: const Color.fromARGB(255, 233, 243, 252),
            );
          }
        },
        codeSent: (String verificationId, int? resendToken) {
          log("Code sent. Verification ID: $verificationId");
          setState(() {
            _showCircularIndicater = false;
          });

          Get.to(Verification(
            number: number,
            verificationId: verificationId,
          ));
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          log("Auto retrieval timeout for verification ID: $verificationId");
        },
      );
    } catch (e) {
      log("Error in sending OTP: $e");
    }
  }

  onSubmit() async {
    setState(() {
      FocusScope.of(context).unfocus();
      phoneNumberErrorMassege = "";
    });
    if (phoneNumberkey.currentState!.validate() &&
        phoneNumber != null &&
        phoneNumber!.number.toString().length == 10) {
      setState(() {
        _showCircularIndicater = true;
      });
      if (!await _appPhoneNumberController.checkPhoneNumberAlreadyExit(
          phoneNumber!.completeNumber.toString())) {
        sendOTP(phoneNumber!.completeNumber.toString());
      } else {
        setState(() {
          _showCircularIndicater = false;
        });
        setState(() {
          phoneNumberErrorMassege = "Mobile number already exit";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    initializeScreenSize(context);
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(left: 20.w, right: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.h),
                backbutton(),
                SizedBox(height: 20.h),
                Expanded(
                    child: ListView(
                  children: [
                    Center(
                      child: Text(
                        "Enter your phone number",
                        style: TextStyle(
                            fontSize: 24.sp,
                            fontFamily: 'Gilroy',
                            color: const Color(0XFF000000),
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Padding(
                      padding: EdgeInsets.only(left: 55.w, right: 55.w),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "You will receive $otpLength digits OTP to verified number",
                          style: TextStyle(
                              color: const Color(0XFF000000),
                              fontSize: 15.sp,
                              fontFamily: 'Gilroy'),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    SizedBox(height: 22.h),
                    phoneNumberField(),
                    SizedBox(height: 30.h),
                    continuebutton(),
                    SizedBox(height: 45.h),
                    or_sign_in_with_text(),
                    SizedBox(height: 30.h),
                    otherSignUp(
                      title: "Login with Google",
                      onTap: () {},
                      image: "assets/images/google.png",
                    ),
                    SizedBox(height: 20.h),
                    otherSignUp(
                      title: "Login with Facebook",
                      onTap: () {},
                      image: "assets/images/facebook.png",
                    ),
                    SizedBox(height: 100.h),
                    if (_showCircularIndicater)
                      const Center(child: CircularProgressIndicator()),
                  ],
                )),
                Padding(
                  padding: EdgeInsets.only(bottom: 30.h),
                  child: alreadyLoginButton(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget backbutton() {
    return IconButton(
        onPressed: () {
          Get.back();
        },
        icon: const Icon(
          Icons.arrow_back_ios,
          size: 20,
        ));
  }

  Widget phoneNumberField() {
    return Form(
      key: phoneNumberkey,
      child: IntlPhoneField(
        dropdownIconPosition: IconPosition.trailing,
        dropdownIcon: const Icon(
          Icons.keyboard_arrow_down_outlined,
          color: Color(0XFF000000),
        ),
        flagsButtonPadding: EdgeInsets.only(left: 16.h),
        controller: phoneNumberCheakController,
        decoration: InputDecoration(
          errorText: (phoneNumberErrorMassege.isNotEmpty)
              ? phoneNumberErrorMassege
              : null,
          labelText: 'Phone Number',
          labelStyle: TextStyle(
              fontFamily: 'Gilroy',
              fontWeight: FontWeight.w700,
              fontSize: 15.sp,
              color: const Color(0XFF9B9B9B)),
          hintStyle: AppText.textFieldHintTextStyle,
          focusedErrorBorder: AppTextfieldBorder.focusedErrorBorder,
          errorBorder: AppTextfieldBorder.errorBorder,
          focusedBorder: AppTextfieldBorder.focusedBorder,
          enabledBorder: AppTextfieldBorder.enabledBorder,
        ),
        initialCountryCode: 'IN',
        onChanged: (phone) {
          phoneNumber = phone;
        },
        validator: (val) {
          if (val!.toString().isEmpty || val.toString().length != 10) {
            return 'Please enter the mobile number';
          }
          return null;
        },
      ),
    );
  }

  Widget continuebutton() {
    return Center(
      child: GestureDetector(
        onTap: onSubmit,
        child: Container(
          height: 56.h,
          width: 374.w,
          //color: Color(0XFF23408F),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color(0XFF23408F),
          ),
          child: Center(
            child: Text(
              "Continue",
              style: TextStyle(
                color: const Color(0XFFFFFFFF),
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                fontFamily: 'Gilroy',
              ),
            ),
          ),
        ),
      ),
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
        Text("Or Sign up with",
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

  Widget otherSignUp(
      {required String title, required onTap, required String image}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56.h,
        width: 374.w,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey.withOpacity(0.1)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(image: AssetImage(image)),
            SizedBox(width: 10.w),
            Text(
              title,
              style: const TextStyle(
                color: Color.fromARGB(255, 31, 31, 31),
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget alreadyLoginButton() {
    return Align(
      alignment: Alignment.center,
      child: RichText(
        text: TextSpan(
          text: 'Already have an account? ',
          style: TextStyle(
              color: Colors.black, fontSize: 15.sp, fontFamily: 'Gilroy'),
          children: [
            TextSpan(
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Get.off(const LoginScreen());
                },
              text: 'Login',
              style: TextStyle(
                  color: const Color(0XFF000000),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Gilroy'),
            )
          ],
        ),
      ),
    );
  }
}
