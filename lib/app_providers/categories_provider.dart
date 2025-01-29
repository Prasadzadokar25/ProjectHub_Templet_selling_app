import 'package:flutter/material.dart';

import '../model/categories_info_model.dart';

class CategoriesProvider extends ChangeNotifier {
  bool _isLoading = false;
  List<CategoryModel>? _categories;

  bool get isLoading => _isLoading;
  List<CategoryModel>? get categories => _categories;

  Future<void> fetchCategories() async {
    _isLoading = true;
    await Future.delayed(const Duration(milliseconds: 5));
    notifyListeners();

    try {} catch (e) {}
  }
}
