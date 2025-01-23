import 'package:flutter/material.dart';
import 'package:projecthub/controller/bank_account_controller.dart';

import '../model/bank_account_model.dart';

class BankAccountProvider extends ChangeNotifier {
  bool _isLoading = false;
  String _errorMessage = '';
  List<BankAccount>? _accounts;
  String get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  List<BankAccount>? get accounts => _accounts;

  Future<void> fetchUserBankAccounts(int userId) async {
    await Future.delayed(const Duration(microseconds: 10));
    if (_accounts == null) {
      _isLoading = true;
      notifyListeners();
    }
    try {
      _accounts = await BankAccountController().fetchUserBankAccounts(userId);
      _errorMessage = ''; // Clear any previous error
    } catch (e) {
      _errorMessage = 'Failed to fetch bank accounts: $e';
      throw Exception(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addUserBankAccounts(Map json) async {
    _isLoading = true;
    await Future.delayed(const Duration(microseconds: 10));
    notifyListeners();

    try {
      await BankAccountController().addUserBankAccounts(json);
      _errorMessage = ''; // Clear any previous error
    } catch (e) {
      _errorMessage = 'Failed to add bank account: $e';
      throw Exception(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> setPrimaryBankAccount(int userId, int accountId) async {
    _isLoading = true;
    await Future.delayed(const Duration(microseconds: 10));

    //notifyListeners();
    try {
      await BankAccountController().setPrimaryBankAccount(userId, accountId);
      _errorMessage = ''; // Clear any previous error
      _accounts = _accounts?.map((account) {
        if (account.accountId == accountId) {
          return account.copyWith(isPrimary: true);
        } else {
          return account.copyWith(isPrimary: false);
        }
      }).toList();
    } catch (e) {
      _errorMessage = 'Failed to fetch creations: $e';
      throw Exception(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
