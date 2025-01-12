// providers/creation_provider.dart
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:projecthub/controller/creation_controller.dart';
import 'package:projecthub/model/creation_info_model.dart';
import 'package:projecthub/model/new.dart';

class ListedCreationProvider with ChangeNotifier {
  List<ListedCreation> _userListedcreations = [];

  bool _isLoading = false;
  String _errorMessage = '';

  List<ListedCreation> get userListedcreations => _userListedcreations;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // Fetch creations data and update state
  Future<void> fetchUserListedCreations(int userId) async {
    _isLoading = true;
    await Future.delayed(const Duration(microseconds: 10));

    notifyListeners();
    try {
      _userListedcreations =
          await CreationController().fetchUserListedCreations(userId);
      _errorMessage = ''; // Clear any previous error
    } catch (e) {
      _errorMessage = 'Failed to fetch creations: $e';
    }
    _isLoading = false;
    notifyListeners();
  }
}

class GeneralCreationProvider with ChangeNotifier {
  List<Creation2>? _generalCreations;

  bool _isLoading = false;
  String _errorMessage = '';

  List<Creation2>? get generalCreations => _generalCreations;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchGeneralCreations(int userId, int page, int perPage) async {
    _isLoading = true;
    await Future.delayed(const Duration(microseconds: 10));
    notifyListeners();
    try {
      _generalCreations = await CreationController()
          .fetchGeneralCreations(userId, page, perPage);
      _errorMessage = ''; // Clear any previous error
    } catch (e) {
      _errorMessage = 'Failed to fetch creations: $e';
      log("errroroooooooooooo");
    }
    //log("${_generalCreations!.length}");
    _isLoading = false;
    notifyListeners();
  }
}
