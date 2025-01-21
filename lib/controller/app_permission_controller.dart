import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class AppPermissionController {
  Future<bool> requestNotificationPermission() async {
    // Request permission for notifications
    PermissionStatus status = await Permission.notification.request();

    // If the permission is granted, show a notification
    if (status.isGranted) {
      print("Notification Permission Granted");
      // You can show notifications now
    } else if (status.isDenied) {
      print("Notification Permission Denied");
      // Handle denied permission (you might show an explanation or guide to settings)
    } else if (status.isPermanentlyDenied) {
      print("Notification Permission Permanently Denied");
      // Guide user to open app settings
      _showPermissionDialog();
    }
    if (await Permission.notification.status.isGranted) {
      return true;
    }
    return false;
  }

  Future<bool> requestStoragePermission() async {
    // Request permission for MANAGE_EXTERNAL_STORAGE on Android 11 and above
    PermissionStatus status = await Permission.manageExternalStorage.request();

    // If the permission is granted, show a notification
    if (status.isGranted) {
      print("manageExternalStorage Permission Granted");
      // You can show notifications now
    } else if (status.isDenied) {
      print("manageExternalStorage Permission Denied");
      await Permission.manageExternalStorage.request();
      // Handle denied permission (you might show an explanation or guide to settings)
    } else if (status.isPermanentlyDenied) {
      print("manageExternalStorage Permission Permanently Denied");
      // Guide user to open app settings
      _showPermissionDialog();
    }
    if (await Permission.notification.status.isGranted) {
      return true;
    }
    return false;
  }

  void _showPermissionDialog() {
    // Show a dialog asking the user to allow the permission from settings
    Get.defaultDialog(
      title: "Please allow permission from setting",
      confirm: Text("Open Setting"),
      onConfirm: () {
        // Open app settings to enable notification permission
        openAppSettings();
      },
    );
  }
}
