// providers/creation_provider.dart
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:projecthub/controller/creation_controller.dart';
import 'package:projecthub/model/creation_info_model.dart';
import 'package:projecthub/model/new.dart';

import '../model/purched_creation_model.dart';

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
  int currentPage = 1;
  int perPage = 10;
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
      _errorMessage = '';
      currentPage++; // Clear any previous error
    } catch (e) {
      _errorMessage = 'Failed to fetch creations: $e';
      log("errroroooooooooooo");
    }
    //log("${_generalCreations!.length}");
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchMoreGeneralCreations(
    int userId,
  ) async {
    List<Creation2> newFetchedCreation = [];
    await Future.delayed(const Duration(microseconds: 10));
    try {
      newFetchedCreation = await CreationController()
          .fetchGeneralCreations(userId, currentPage, perPage);
      _generalCreations!.addAll(newFetchedCreation);

      _errorMessage = '';
    } catch (e) {
      _errorMessage = 'Failed to fetch creations: $e';
      log("errroroooooooooooo");
    }
    currentPage++; // Clear any previous error
    if (newFetchedCreation.length >= perPage) {}
    notifyListeners();
  }
}

class RecentCreationProvider extends ChangeNotifier {
  List<Creation2>? _recentlyAddedCreations;

  bool _isLoading = false;
  String _errorMessage = '';

  List<Creation2>? get recentlyAddedCreations => _recentlyAddedCreations;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchRecentCreations(int userId, int page, int perPage) async {
    _isLoading = true;
    await Future.delayed(const Duration(microseconds: 10));
    notifyListeners();
    try {
      _recentlyAddedCreations = await CreationController()
          .fetchRecentCreations(userId, page, perPage);
      _errorMessage = ''; // Clear any previous error
    } catch (e) {
      _errorMessage = 'Failed to fetch creations: $e';
      log("errror111111111111111111");
    }
    //log("${_generalCreations!.length}");
    _isLoading = false;
    notifyListeners();
  }
}

class TreandingCreationProvider extends ChangeNotifier {
  List<Creation2>? _treandingCreations;

  bool _isLoading = false;
  String _errorMessage = '';

  List<Creation2>? get threandingCreations => _treandingCreations;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchTrendingCreations(int userId, int page, int perPage) async {
    _isLoading = true;
    await Future.delayed(const Duration(microseconds: 10));
    notifyListeners();
    try {
      _treandingCreations = await CreationController()
          .fetchTrendingCreations(userId, page, perPage);
      _errorMessage = ''; // Clear any previous error
    } catch (e) {
      _errorMessage = 'Failed to fetch creations: $e';
      log("errror11222222222222222222222222221");
    }
    //log("${_generalCreations!.length}");
    _isLoading = false;
    notifyListeners();
  }
}

class PurchedCreationProvider extends ChangeNotifier {
  List<PurchedCreationModel>? _purchedCreations;

  bool _isLoading = false;
  String _errorMessage = '';

  List<PurchedCreationModel>? get purchedCreations => _purchedCreations;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchUserPurchedCreation(
      int userId, int page, int perPage) async {
    log("=======================================");
    _isLoading = true;
    await Future.delayed(const Duration(microseconds: 10));
    notifyListeners();
    try {
      _purchedCreations = await CreationController()
          .fetchPurchedCreations(userId, page, perPage);
      _errorMessage = ''; // Clear any previous error
    } catch (e) {
      _errorMessage = 'Failed to fetch creations: $e';
      log("errror33333333333333333333333333333333");
    }
    log("${_purchedCreations!.length}0000000000000000000000000000000000000000000000000");
    _isLoading = false;
    notifyListeners();
  }
}

class RecomandedCreationProvider extends ChangeNotifier {
  List<Creation2>? _recomandedCreationProvider;
  int page = 1;
  int perPage = 10;

  bool _isLoading = false;
  String _errorMessage = '';

  List<Creation2>? get recomandedCreationProvider =>
      _recomandedCreationProvider;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> feachRecommandedCreation(int userId, Creation2 creation) async {
    log("=======================================");
    _isLoading = true;
    await Future.delayed(const Duration(microseconds: 10));
    notifyListeners();
    try {
      _recomandedCreationProvider = await CreationController()
          .fetchRecomandedCreations(userId, page, perPage, creation);
      _errorMessage = ''; // Clear any previous error
    } catch (e) {
      _errorMessage = 'Failed to fetch creations: $e';
      log("$e");
    }
    _isLoading = false;
    notifyListeners();
  }
}
