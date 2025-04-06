import 'dart:convert';
import 'dart:nativewrappers/_internal/vm/lib/developer.dart';

import 'package:projecthub/config/api_config.dart';
import 'package:projecthub/model/reel_model.dart';
import 'package:http/http.dart' as http;

class ReelsController {
  Future<List<ReelModel>> fetchReels(int userId, int limit, int offset) async {
    try {
      final url = Uri.parse(
          'http://your-server-ip:5000/reels?limit=$limit&offset=$offset&user_id=$userId');

      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body)['data'];

        log(response.body);
        return data.map((json) => ReelModel.fromJson(json)).toList();
      } else if (response.statusCode == 204) {
        log("No reels found");
        throw Exception('Failed to load reels');
      } else {
        throw Exception('Failed to load reels');
      }
    } catch (e) {
      throw Exception('Failed to load reels: $e');
    }
  }
}
