import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:projecthub/config/api_config.dart';

class OrderController {
  Future<void> placeOrder(int userId, paymentDetails, List products) async {
    final header = {'Content-Type': 'application/json'};
    final body = {
      'user_id': userId,
      'payment_details': paymentDetails,
      'product': products,
    };
    log(body.toString());

    final url = Uri.parse(ApiConfig.placeOrder);

    http.Response response = await http.post(
      url,
      headers: header,
      body: jsonEncode(body),
    );
  }
}
