// providers/creation_provider.dart
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:projecthub/controller/creation_controller.dart';
import 'package:projecthub/model/creation_info_model.dart';
import 'package:projecthub/model/new.dart';

import '../model/incard_creation_model.dart';
import '../model/purched_creation_model.dart';

class ListedCreationProvider with ChangeNotifier {
  List<ListedCreation>? _userListedcreations;

  bool _isLoading = false;
  String _errorMessage = '';

  List<ListedCreation>? get userListedcreations => _userListedcreations;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  void reset() {
    _userListedcreations = null; // Clear data
    notifyListeners();
  }

  // Fetch creations data and update state
  Future<void> fetchUserListedCreations(int userId) async {
    if (_userListedcreations == null) {
      _isLoading = true;
      await Future.delayed(const Duration(microseconds: 10));

      notifyListeners();
    }
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
  void reset() {
    _generalCreations = null; // Clear data
    notifyListeners();
  }

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
      throw Exception("failed to feach general creations $e");
    }
    //log("${_generalCreations!.length}");
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchMoreGeneralCreations(
    int userId,
  ) async {
    List<Creation2> newFetchedCreation = [];
    await Future.delayed(const Duration(milliseconds: 10));
    try {
      newFetchedCreation = await CreationController()
          .fetchGeneralCreations(userId, currentPage, perPage);
      _generalCreations!.addAll(newFetchedCreation);

      _errorMessage = '';
    } catch (e) {
      _errorMessage = 'Failed to fetch creations: $e';
      throw Exception("failed to feach more general creations $e");
    }
    currentPage++; // Clear any previous error
    if (newFetchedCreation.length >= perPage) {}
    notifyListeners();
  }
}

class RecentCreationProvider extends ChangeNotifier {
  List<Creation2>? _recentlyAddedCreations;
  int page = 2;
  int perPage = 10;
  bool _isLoading = false;
  String _errorMessage = '';

  List<Creation2>? get recentlyAddedCreations => _recentlyAddedCreations;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  void reset() {
    _recentlyAddedCreations = null; // Clear data
    notifyListeners();
  }

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
      throw Exception("failed to feach Recentaly added creations $e");
    }
    //log("${_generalCreations!.length}");
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchMoreRecentCreations(int userId) async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(microseconds: 100));

    try {
      _recentlyAddedCreations!.addAll(await CreationController()
          .fetchRecentCreations(userId, page, perPage));
      _errorMessage = '';
      page++; // Clear any previous error
    } catch (e) {
      _errorMessage = 'Failed to fetch creations: $e';
      throw Exception("failed to feach more Recentalt added  creations $e");
    }
    //log("${_generalCreations!.length}");
    _isLoading = false;
    notifyListeners();
  }
}

class TreandingCreationProvider extends ChangeNotifier {
  List<Creation2>? _treandingCreations;
  int page = 2;
  int perPage = 10;
  bool _isLoading = false;
  String _errorMessage = '';
  void reset() {
    _treandingCreations = null; // Clear data
    notifyListeners();
  }

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
      _errorMessage = '';
      page++; // Clear any previous error
    } catch (e) {
      _errorMessage = 'Failed to fetch creations: $e';
      throw Exception("failed to feach treanding creations $e");
    }
    //log("${_generalCreations!.length}");
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchMoreTrendingCreations(int userId) async {
    _isLoading = true;
    await Future.delayed(const Duration(microseconds: 10));
    notifyListeners();
    try {
      _treandingCreations!.addAll(await CreationController()
          .fetchTrendingCreations(userId, page, perPage));
      _errorMessage = ''; // Clear any previous error
      page++;
    } catch (e) {
      _errorMessage = 'Failed to fetch creations: $e';
      throw Exception("failed to feach more trending creations $e");
    }
    //log("${_generalCreations!.length}");
    _isLoading = false;
    notifyListeners();
  }
}

class PurchedCreationProvider extends ChangeNotifier {
  List<PurchedCreationModel>? _purchedCreations;
  int page = 1;
  int perPage = 10;
  bool _isLoading = false;
  String _errorMessage = '';
  List<PurchedCreationModel>? get purchedCreations => _purchedCreations;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  void reset() {
    _purchedCreations = null; // Clear data
    notifyListeners();
  }

  Future<void> fetchUserPurchedCreation(int userId) async {
    List<PurchedCreationModel>? newFetchedCreations;

    if (_purchedCreations != null) {
      await fetchMoreUserPurchedCreation(userId);
      return;
    }
    _isLoading = true;
    await Future.delayed(const Duration(microseconds: 5));

    notifyListeners();
    try {
      newFetchedCreations = await CreationController()
          .fetchPurchedCreations(userId, page, perPage);
      _purchedCreations = newFetchedCreations;
      _errorMessage = '';
    } catch (e) {
      _errorMessage = 'Failed to fetch creations: $e';
      throw Exception("failed to feach purched creations $e");
    } finally {
      _isLoading = false;
      if (newFetchedCreations != null && newFetchedCreations.length == 10) {
        page++;
      }
      notifyListeners();
    }
  }

  Future<void> fetchMoreUserPurchedCreation(int userId) async {
    List<PurchedCreationModel>? newFetchedCreations;

    if (_purchedCreations == null) {
      _isLoading = true;
      await Future.delayed(const Duration(microseconds: 5));
      notifyListeners();
    }
    try {
      newFetchedCreations = await CreationController()
          .fetchPurchedCreations(userId, page, perPage);
      _purchedCreations = newFetchedCreations;
      _errorMessage = '';
    } catch (e) {
      _errorMessage = 'Failed to fetch creations: $e';
      throw Exception("failed to feach purched creations $e");
    }
    _isLoading = false;
    if (newFetchedCreations.length == (perPage + 1)) {
      page++;
    }
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
  void reset() {
    _recomandedCreationProvider = null; // Clear data
    notifyListeners();
  }

  Future<void> feachRecommandedCreation(int userId, Creation2 creation) async {
    _isLoading = true;
    await Future.delayed(const Duration(microseconds: 10));
    notifyListeners();
    try {
      _recomandedCreationProvider = await CreationController()
          .fetchRecomandedCreations(userId, page, perPage, creation);
      _errorMessage = ''; // Clear any previous error
    } catch (e) {
      _errorMessage = 'Failed to fetch creations: $e';
      throw Exception("failed to feach recommanded creations $e");
    }
    _isLoading = false;
    notifyListeners();
  }
}

class InCardCreationProvider extends ChangeNotifier {
  List<InCardCreationInfo>? _creations;
  int page = 1;
  int perPage = 10;
  bool _isLoading = false;
  String _errorMessage = '';
  List<InCardCreationInfo>? get creations => _creations;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  void reset() {
    _creations = null; // Clear data
    notifyListeners();
  }

  Future<void> fetchInCardCreations(int userId) async {
    log("=======================================");
    _isLoading = true;
    await Future.delayed(const Duration(microseconds: 10));
    notifyListeners();
    try {
      _creations = await CreationController().fetchUserInCardCreations(userId);
      _errorMessage = ''; // Clear any previous error
    } catch (e) {
      _errorMessage = 'Failed to fetch creations: $e';
      throw Exception("failed to feach in crad creations $e");
    }
    _isLoading = false;
    notifyListeners();
  }

  // Method to remove an item from the card
  Future<void> removeItemFromCard(int userId, int cardItemId) async {
    try {
      // Call the controller method to remove the item
      await CreationController().removeItemFromCard(userId, cardItemId);

      // Optionally, update the local state by removing the item
      _creations!.removeWhere((item) => item.carditemId == cardItemId);

      // Notify listeners about the state change
      notifyListeners();
    } catch (e) {
      // Handle any errors that may occur
      debugPrint("Error removing item from card: $e");
      rethrow; // Optionally rethrow to handle the error higher up
    }
  }
}
