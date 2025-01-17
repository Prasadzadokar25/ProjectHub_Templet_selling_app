import 'package:flutter/foundation.dart';
import 'package:projecthub/model/categories_info_model.dart';
import 'package:projecthub/model/creation_info_model.dart';

class DataFileProvider extends ChangeNotifier {
  // ignore: prefer_final_fields
  static List<CategoryModel> _categories = [
    CategoryModel(
      image: 'assets/images/d3.png',
      name: 'Code0',
      //color: '0XFFFFF6E5',
    ),
    CategoryModel(
      image: 'assets/images/d4.png',
      name: 'Code',
      color: '0XFFFEE9EB',
    ),
    CategoryModel(
      image: 'assets/images/user_image.png',
      name: 'Video graphics',
      color: '0XFFECF6FF',
    ),
    CategoryModel(
      image: 'assets/images/d4.png',
      name: 'Code',
      color: '0XFFFEE9EB',
    ),
    CategoryModel(
      image: 'assets/images/user_image.png',
      name: 'Video graphics',
      color: '0XFFECF6FF',
    ),
    CategoryModel(
      image: 'assets/images/d3.png',
      name: 'CategoryModel',
      color: '0XFFFFF6E5',
    ),
    CategoryModel(
      image: 'assets/images/d4.png',
      name: 'Code',
      color: '0XFFFEE9EB',
    ),
    CategoryModel(
      image: 'assets/images/d5.png',
      name: 'Video graphics',
      color: '0XFFECF6FF',
    ),
    CategoryModel(
      image: 'assets/images/d6.png',
      name: 'Photography',
      color: '0XFFFFF6E5',
    ),
  ];
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

  List<CategoryModel> get categories => _categories;
}
