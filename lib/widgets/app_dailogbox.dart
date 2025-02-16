import 'package:flutter/material.dart';
import 'package:get/get.dart';

showUpadteAlertBox() {
  Get.defaultDialog(
      content: Center(
    child: Column(
      children: [CircularProgressIndicator(), Text("Updating please wait")],
    ),
  ));
}
