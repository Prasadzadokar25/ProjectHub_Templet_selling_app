import 'dart:developer';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymetController {
  Razorpay _razorpay = Razorpay();

  void makePayment() {
    var options = {
      'key': 'rzp_test_RGXMJ7AaFuSh0Q',
      'amount': 100,
      'name': 'PRASAD PATIL.',
      'description': 'CREATION',
      'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'}
    };
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    try {
      _razorpay.open(options);
    } catch (e) {
      rethrow;
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
    Fluttertoast.showToast(msg: "Paymet successful");
    log("paymet successful");
    _razorpay.clear(); // Removes all listeners
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    Fluttertoast.showToast(msg: "Paymet failed");
    log("paymet failed");
    _razorpay.clear(); // Removes all listeners
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
  }
}
