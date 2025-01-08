import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:projecthub/config/api_config.dart';
import 'package:projecthub/model/user_info_model.dart';

class CreationController {
  Future<int> listCreation(NewUserInfo newUserInfo) async {
    log(newUserInfo.userName);
    final url = ApiConfig.listCreation;
    final uri = Uri.parse(url);
    int statusCode = -1;
    //log('$basUrl/');

    Map<String, String> header = {
      'Content-Type': 'application/json',
    };

    final body = newUserInfo.toJson();
    try {
      final response = await http.post(
        uri,
        headers: header,
        body: jsonEncode(body),
      );
      statusCode = response.statusCode;
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Request was successful
        log('Response: ${response.body}');
      } else {
        // Handle the error
        log('Failed to send data: ${response.statusCode}');
      }
    } catch (e) {
      log("error $e");
    }
    return statusCode;
  }
}
