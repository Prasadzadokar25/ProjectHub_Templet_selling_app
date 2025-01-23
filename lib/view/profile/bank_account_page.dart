import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projecthub/app_providers/bank_account_provider.dart';
import 'package:projecthub/app_providers/user_provider.dart';
import 'package:projecthub/constant/app_icons.dart';
import 'package:projecthub/constant/app_padding.dart';
import 'package:projecthub/constant/app_textfield_border.dart';
import 'package:projecthub/model/bank_account_model.dart';
import 'package:projecthub/widgets/app_primary_button.dart';
import 'package:provider/provider.dart';

class BankAccountPage extends StatefulWidget {
  const BankAccountPage({super.key});

  @override
  State createState() => _BankAccountPageState();
}

class _BankAccountPageState extends State<BankAccountPage> {
  bool _isError = false;
  String _errorMessage = '';
  @override
  void initState() {
    super.initState();
    getData();
  }

  final List _gradientColors = [
    [const Color(0xFF6D0EB5), const Color(0xFF4059F1)], // Purple
    [const Color(0xFF0072FF), const Color(0xFF00C6FF)], // Blue
    [const Color(0xFFFF4E50), const Color(0xFFF9D423)], // Orange
    [const Color(0xFF11998E), const Color(0xFF38EF7D)], // Green-Teal
  ];

  getData() async {
    try {
      final provider = Provider.of<BankAccountProvider>(context, listen: false);
      await provider.fetchUserBankAccounts(
          Provider.of<UserInfoProvider>(context, listen: false).user!.userId);
      _isError = false;
      _errorMessage = '';
    } catch (e) {
      log(e.toString());
      setState(() {
        _isError = true;
        _errorMessage = e.toString();
        Get.snackbar("Error occurs", e.toString());
      });
    }
  }

  Widget _buildBankAccountCard(BankAccount bankAccount, int index) {
    final gradient = _gradientColors[index % _gradientColors.length];

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                bankAccount.bankName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              _getInfoSection(
                  "Account Holder",
                  (bankAccount.accountHolderName != null)
                      ? bankAccount.accountHolderName!
                      : "Not provided"),
              _getInfoSection("Account Number",
                  "${bankAccount.accountNumber.substring(0, 2)}*****${bankAccount.accountNumber.substring(bankAccount.accountNumber.length - 4, bankAccount.accountNumber.length)}"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Set as primary",
                    style: TextStyle(color: Colors.white),
                  ),
                  Radio(
                    value: bankAccount,
                    groupValue: _getPrimaryAccount(bankAccount),
                    onChanged: (v) {
                      _setPrimaryAccount(bankAccount);
                    },
                    activeColor: Colors.white,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  _getPrimaryAccount(BankAccount bankAccount) {
    // Returns the account number of the primary account
    return (bankAccount.isPrimary) ? bankAccount : null;
  }

  _setPrimaryAccount(BankAccount bankAccount) async {
    try {
      final provider = Provider.of<BankAccountProvider>(context, listen: false);
      await provider.setPrimaryBankAccount(
          Provider.of<UserInfoProvider>(context, listen: false).user!.userId,
          bankAccount.accountId);
    } catch (e) {
      Get.snackbar("Not updated", "Failed to set primary account");
    }
  }

  _getInfoSection(String key, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: Get.width * 0.3,
          child: Text(key, style: const TextStyle(color: Colors.white70)),
        ),
        const Text(" :   ", style: TextStyle(color: Colors.white70)),
        SizedBox(
            width: Get.width * 0.4,
            child: Text(value, style: const TextStyle(color: Colors.white70)))
      ],
    );
  }

  void _showAddAccountDialog() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 16,
          left: 16,
          right: 16,
        ),
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Add New Bank Account",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  labelText: "Account Holder Name",
                  border: AppTextfieldBorder.enabledBorder,
                  focusedBorder: AppTextfieldBorder.focusedBorder,
                  enabledBorder: AppTextfieldBorder.enabledBorder,
                  focusedErrorBorder: AppTextfieldBorder.focusedErrorBorder,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  labelText: "Bank Name",
                  border: AppTextfieldBorder.enabledBorder,
                  focusedBorder: AppTextfieldBorder.focusedBorder,
                  enabledBorder: AppTextfieldBorder.enabledBorder,
                  focusedErrorBorder: AppTextfieldBorder.focusedErrorBorder,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  labelText: "Account Number",
                  border: AppTextfieldBorder.enabledBorder,
                  focusedBorder: AppTextfieldBorder.focusedBorder,
                  enabledBorder: AppTextfieldBorder.enabledBorder,
                  focusedErrorBorder: AppTextfieldBorder.focusedErrorBorder,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  labelText: "IFSC Code",
                  border: AppTextfieldBorder.enabledBorder,
                  focusedBorder: AppTextfieldBorder.focusedBorder,
                  enabledBorder: AppTextfieldBorder.enabledBorder,
                  focusedErrorBorder: AppTextfieldBorder.focusedErrorBorder,
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: EdgeInsets.all(AppPadding.itermInsidePadding),
                child: AppPrimaryElevetedButton(
                  title: "Submit",
                  onPressed: () {},
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: AppIcon.backIcon),
        title: const Text("Bank Accounts"),
      ),
      body: Consumer<BankAccountProvider>(builder: (context, value, child) {
        if (value.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (_isError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(_errorMessage),
                ElevatedButton(onPressed: getData, child: const Text("Refresh"))
              ],
            ),
          );
        }
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: value.accounts!.length,
                itemBuilder: (context, index) {
                  return _buildBankAccountCard(value.accounts![index], index);
                },
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(16.0),
                child: AppPrimaryElevetedButton(
                  onPressed: _showAddAccountDialog,
                  title: "Add New Bank Account",
                  icon: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                )),
          ],
        );
      }),
    );
  }
}
