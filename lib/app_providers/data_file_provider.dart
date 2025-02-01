import 'package:flutter/foundation.dart';
import 'package:projecthub/model/categories_info_model.dart';
import 'package:projecthub/model/creation_info_model.dart';

class DataFileProvider extends ChangeNotifier {
  // ignore: prefer_final_fields

  // ignore: prefer_final_fields
  List<Creation> _adeverticmentIterm = [
    Creation.fromJson({
      'title': 'Modern Template',
      'subtitle': 'A stunning modern template for websites.',
      'imagePath': 'assets/images/c1.jpg',
      'price': 29.99,
      'rating': 4.5,
      'seller': {
        'id': 1,
        'name': 'John Doe',
        'image': 'assets/images/user_image.png',
      }
    }),
    Creation.fromJson({
      'title': 'Modern Template',
      'subtitle': 'A stunning modern template for websites.',
      'imagePath': 'assets/images/c1.jpg',
      'price': 29.99,
      'rating': 4.5,
      'seller': {
        'id': 1,
        'name': 'John Doe',
        'image': 'assets/images/user_image.png',
      }
    }),
    Creation.fromJson({
      'title': 'Modern Template',
      'subtitle': 'A stunning modern template for websites.',
      'imagePath': 'assets/images/c1.jpg',
      'price': 29.99,
      'rating': 4.5,
      'seller': {
        'id': 1,
        'name': 'John Doe',
        'image': 'assets/images/user_image.png',
      }
    }),
  ];

  // ignore: prefer_final_fields

  List<Creation> get adeverticmentIterm => _adeverticmentIterm;
}
