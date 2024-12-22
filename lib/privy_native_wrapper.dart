import 'package:flutter/services.dart';

class PrivyNativeWrapper {
  //make it singleton

  static PrivyNativeWrapper? _shared;

  PrivyNativeWrapper._internal();

  factory PrivyNativeWrapper() {
    return _shared ??= PrivyNativeWrapper._internal();
  }

  static PrivyNativeWrapper get sharedInstance {
    return _shared ??= PrivyNativeWrapper._internal();
  }

  MethodChannel platformChannel =
      const MethodChannel('com.ppl.zeroxppl/portal');

  bool isInitialised = false;

  Future<void> initializePrivy() async {
    try {
      await platformChannel.invokeMethod(
        'initializePrivy',
        {
          'clientId': "client-WY2kGjAV9PduKgHvw16ZbZqqk8HPSPCBaeNU98XctY1da",
          'appId': "clv6fw8s306zb9ubei8siuud9",
        },
      );
      print("Privy SDk intiialised");
      isInitialised = true;
    } catch (e) {
      isInitialised = false;
      print("Privy SDk error $e");
      rethrow;
    }
  }

  Future<bool> sendOtp({
    required String emailId,
  }) async {
    try {
      final response = await platformChannel.invokeMethod(
        'sendOtp',
        {
          'emailId': emailId,
        },
      ) as Map;
      print("Privy SDk ${response.toString()}");
      if (response['success'] == true) {
        return true;
      }
      throw response['error'] ?? "Error in sending OTP";
    } catch (e) {
      isInitialised = false;
      print("Privy SDk error $e");
      rethrow;
    }
  }

  Future<bool> authenticateWithOtp({
    required String emailId,
    required String otp,
  }) async {
    try {
      final response = await platformChannel.invokeMethod(
        'authenticateWithOtp',
        {
          'emailId': emailId,
          "otp": otp,
        },
      ) as Map;
      print("Privy SDk ${response.toString()}");
      if (response['success'] == true) {
        return true;
      }
      throw response['error'];
    } catch (e) {
      isInitialised = false;
      print("Privy SDk error $e");
      rethrow;
    }
  }

  Future<bool> generateWallet() async {
    try {
      final response = await platformChannel.invokeMethod(
        'generatePrivyWallet',
      ) as Map;
      print("Privy SDk generate wallet ${response.toString()}");
      if (response['success'] == true) {
        return true;
      }
      throw response['error'];
    } catch (e) {
      isInitialised = false;
      print("Privy SDk error $e");
      rethrow;
    }
  }

  Future<bool> generateSolanaWallet() async {
    try {
      final response = await platformChannel.invokeMethod(
        'generatePrivySolanaWallet',
      ) as Map;
      print("Privy SDk ${response.toString()}");
      if (response['success'] == true) {
        return true;
      }
      throw response['error'];
    } catch (e) {
      isInitialised = false;
      print("Privy SDk error $e");
      rethrow;
    }
  }

  Future<Map<dynamic, dynamic>> sendEthTransaction({
    required String txData,
    required String method,
  }) async {
    try {
      final response = await platformChannel.invokeMethod(
        'sendEthTransaction',
        {
          "txString": txData,
          "method": method,
        },
      ) as Map;
      if (response['success'] == true) {
        return response;
      }
      throw response['error'];
    } catch (e) {
      isInitialised = false;
      print("Privy SDk error $e");
      rethrow;
    }
  }

  Future<bool> getWallets() async {
    try {
      final response = await platformChannel.invokeMethod(
        'getWallets',
      ) as Map;
      print("Privy SDk get wallets ${response.toString()}");
      if (response['success'] == true) {
        return true;
      }
      throw response['error'];
    } catch (e) {
      isInitialised = false;
      print("Privy SDk error $e");
      rethrow;
    }
  }

  Future<bool> logout() async {
    try {
      final response = await platformChannel.invokeMethod(
        'logoutPrivy',
      ) as Map;
      print("Privy SDk ${response.toString()}");
      if (response['success'] == true) {
        //show snackbar
        return true;
      }
      throw response['error'];
    } catch (e) {
      isInitialised = false;
      print("Privy SDk error $e");
      rethrow;
    }
  }
}
