import 'dart:developer';
import 'dart:io';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:projecthub/config/api_config.dart';
import 'package:projecthub/controller/app_permission_controller.dart';
import 'package:projecthub/controller/notification_controller.dart';
import 'package:projecthub/model/creation_model.dart';

class FilesDownloadController {
  final NotificationController _notificationController = NotificationController();
  final AppPermissionController _appPermissionController = AppPermissionController();

  Future<void> downloadZipFile(Creation2 creation) async {
    if (await _appPermissionController.requestStoragePermission()) {
      try {
        var response = await http.Client().send(http.Request(
            'GET', Uri.parse(ApiConfig.getFileUrl(creation.creationFile!))));

        if (response.statusCode == 200) {
          var downloadsDirectory = await getDownloadsDirectory();
          var filePath =
              '${downloadsDirectory!.path}/${(creation.creationTitle)!.replaceAll(" ", "_")}.zip';
          var file = File(filePath);
          var bytes = <int>[];
          var total = response.contentLength ?? 1;
          var received = 0;

          response.stream.listen(
            (chunk) {
              log("1");   
              bytes.addAll(chunk);
              received += chunk.length;
              var progress = ((received / total) * 100).toInt();
              _notificationController.showProgressNotification(progress);
            },
            onDone: () async {
              await file.writeAsBytes(bytes);
              _notificationController.flutterLocalNotificationsPlugin
                  .cancel(0); // Cancel the notification once done
              print('File downloaded to $filePath');
            },
            onError: (e) {
              print('Error: $e');
              _notificationController.flutterLocalNotificationsPlugin.cancel(0);
            },
            cancelOnError: true,
          );
        } else {
          print('Failed to download file. Status code: ${response.statusCode}');
        }
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  Future<Directory?> getDownloadsDirectory() async {
    if (Platform.isAndroid) {
      return Directory('/storage/emulated/0/Download');
    } else if (Platform.isIOS) {
      Get.snackbar("Not working for IOS", "contact developer");
    }
    return null;
  }
}
