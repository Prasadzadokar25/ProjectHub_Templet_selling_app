// providers/creation_provider.dart
import 'package:flutter/material.dart';
import 'package:projecthub/controller/creation_controller.dart';
import 'package:projecthub/model/creation_info_model.dart';

class CreationProvider with ChangeNotifier {
  List<ListedCreation> _creations = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<ListedCreation> get creations => _creations;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // Fetch creations data and update state
  Future<void> fetchCreations(int userId) async {
    _isLoading = true;
    await Future.delayed(const Duration(microseconds: 10));

    notifyListeners();
    try {
      _creations = await CreationController().fetchUserListedCreations(userId);
      _errorMessage = ''; // Clear any previous error
    } catch (e) {
      _errorMessage = 'Failed to fetch creations: $e';
    }
    _isLoading = false;
    notifyListeners();
  }
}
