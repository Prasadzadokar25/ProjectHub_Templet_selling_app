// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:projecthub/utils/screen_size.dart';
import '../sign_up/verification_screen.dart';

class SignInPhonenumber extends StatefulWidget {
  const SignInPhonenumber({Key? key}) : super(key: key);

  @override
  State<SignInPhonenumber> createState() => _SignInPhonenumberState();
}

class _SignInPhonenumberState extends State<SignInPhonenumber> {
  final phoneNumberkey = GlobalKey<FormState>();
  TextEditingController phoneNumberCheakController = TextEditingController();
  bool submitPressedOnce = false;
  bool _showCircularIndicater = false;
  PhoneNumber? phoneNumber;

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
            number: phoneNumber!.completeNumber.toString(),
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
                      "You will receive 4 digits number to verified number",
                      style: TextStyle(
                          color: const Color(0XFF000000),
                          fontSize: 15.sp,
                          fontFamily: 'Gilroy'),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(height: 22.h),
                phone_number_field(),
                SizedBox(height: 30.h),
                continuebutton(),
                SizedBox(height: 100.h),
                if (_showCircularIndicater)
                  const Center(child: CircularProgressIndicator())
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

  Widget phone_number_field() {
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
            labelText: 'Phone Number',
            labelStyle: TextStyle(
                fontFamily: 'Gilroy',
                fontWeight: FontWeight.w700,
                fontSize: 15.sp,
                color: const Color(0XFF9B9B9B)),
            border: const OutlineInputBorder(
              borderSide: BorderSide(),
            ),
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.red, width: 1.w)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    BorderSide(color: const Color(0XFF23408F), width: 1.w)),
            enabledBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: const Color(0XFFDEDEDE), width: 1.w),
              borderRadius: BorderRadius.circular(12),
            )),
        initialCountryCode: 'IN',
        onChanged: (phone) {
          phoneNumber = phone;
          print(phone.completeNumber);
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
        onTap: () {
          setState(() {
            FocusScope.of(context).unfocus();
            submitPressedOnce = true;
          });
          if (phoneNumberkey.currentState!.validate() &&
              phoneNumber != null &&
              phoneNumber!.number.toString().length == 10) {
            setState(() {
              _showCircularIndicater = true;
            });
            sendOTP(phoneNumber!.completeNumber.toString());
          }
        },
        child: Container(
          height: 56.h,
          width: 374.w,
          //color: Color(0XFF23408F),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color(0XFF23408F),
          ),
          child: Center(
            child: Text("Continue",
                style: TextStyle(
                    color: const Color(0XFFFFFFFF),
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Gilroy')),
          ),
        ),
      ),
    );
  }
}
