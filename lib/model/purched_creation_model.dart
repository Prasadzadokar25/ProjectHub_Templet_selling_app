import 'dart:convert';

import 'creation_model.dart';

class PurchedCreationModel {
  final Creation2 creation;
  final int orderId;
  final String orderDate;
  final double purchasePrice;

  PurchedCreationModel({
    required this.creation,
    required this.orderId,
    required this.orderDate,
    required this.purchasePrice,
  });

  // Factory constructor to parse the JSON
  factory PurchedCreationModel.fromJson(Map<String, dynamic> json) {
    return PurchedCreationModel(
      creation:
          Creation2.fromJson(jsonDecode(json['creation_details'])['creation']),
      orderId: jsonDecode(json['creation_details'])['order_id'],
      orderDate: jsonDecode(json['creation_details'])['order_date'],
      purchasePrice: jsonDecode(json['creation_details'])['purchase_price'],
    );
  }
}
