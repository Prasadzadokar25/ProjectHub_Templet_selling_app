import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppAuthentication {
  static sendOTP(String number) async {
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

          Get.snackbar(
              "OTP sended succefully", "OTP has been sended on $number");
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          log("Auto retrieval timeout for verification ID: $verificationId");
        },
      );
    } catch (e) {
      log("Error in sending OTP: $e");
    }
  }
}
