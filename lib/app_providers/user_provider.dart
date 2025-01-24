import 'package:flutter/material.dart';
import 'package:projecthub/controller/user_controller.dart';
import 'package:projecthub/model/creation_info_model.dart';
import 'package:projecthub/model/user_info_model.dart';

class UserInfoProvider extends ChangeNotifier {
  UserModel? _user;

  bool _isLoading = false;
  String _errorMessage = '';

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  void reset() {
    _user = null; // Clear data
    notifyListeners();
  }

  // Fetch creations data and update state
  Future<void> fetchUserDetails(userId) async {
    _isLoading = true;
    await Future.delayed(const Duration(microseconds: 10));

    notifyListeners();
    try {
      _user = await UserController().fetchUserDetailsById(userId);
      _errorMessage = ''; // Clear any previous error
    } catch (e) {
      _errorMessage = 'Failed to fetch creations: $e';
    }
    _isLoading = false;
    notifyListeners();
  }

  UserModel get getUserInfo => _user!;
}
