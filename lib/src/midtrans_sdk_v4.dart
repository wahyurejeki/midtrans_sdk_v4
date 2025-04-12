import 'dart:async';

import 'package:flutter/services.dart';
import 'package:midtrans_sdk_v4/midtrans_sdk_v4.dart';

class MidtransSDK {
  static const MethodChannel _channel = const MethodChannel('midtrans_sdk_v4');
  static MidtransSDK _instance = MidtransSDK._();

  TransactionFinishedCallback? _transactionFinishedCallback;

  factory MidtransSDK() {
    return _instance;
  }

  MidtransSDK._() {
    _channel.setMethodCallHandler(_channelHandler);
  }

  Future _channelHandler(MethodCall call) async {
    switch (call.method) {
      case "onTransactionFinished":
        try {
          Map<String, dynamic> map =
              new Map<String, dynamic>.from(call.arguments);
          print(map);
          var result = TransactionResult.fromJson(map);
          _transactionFinishedCallback?.call(result);
        } catch (e) {
          print(e);
        }
        break;
    }
  }

  static Future<MidtransSDK> init({
    required MidtransConfig config,
  }) async {
    await _channel.invokeMethod('init', config.toJson());
    return _instance;
  }

  void setTransactionFinishedCallback(TransactionFinishedCallback callback) {
    _transactionFinishedCallback = callback;
  }

  void removeTransactionFinishedCallback() {
    _transactionFinishedCallback = null;
  }

  Future<void> setUIKitCustomSetting({
    bool? showPaymentStatus,
    bool? saveCardChecked,
    bool? skipCustomerDetailsPages,
    bool? showEmailInCcForm,
    bool? setEnableAutoReadSms,
  }) async {
    return _channel.invokeMethod('setUIKitCustomSetting', {
      "showPaymentStatus": showPaymentStatus,
      "saveCardChecked": saveCardChecked,
      "skipCustomerDetailsPages": skipCustomerDetailsPages,
      "showEmailInCcForm": showEmailInCcForm,
      "setEnableAutoReadSms": setEnableAutoReadSms,
    });
  }

  Future<void> startPaymentUiFlow({String? token}) async {
    return _channel.invokeMethod('startPaymentUiFlow', {
      "token": token,
    });
  }
}
