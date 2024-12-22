import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:privy_ios_tes/privy_native_wrapper.dart';

class PrivyUI extends StatefulWidget {
  const PrivyUI({
    super.key,
  });

  @override
  State<PrivyUI> createState() => _PrivyUIState();
}

class _PrivyUIState extends State<PrivyUI> {
  TextEditingController emailController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  bool isOtpSent = false;
  bool isInitialised = false;

  //init
  @override
  void initState() {
    super.initState();
    PrivyNativeWrapper.sharedInstance.initializePrivy().then((value) {
      setState(() {
        isInitialised = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Privy UI"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text(
              isInitialised
                  ? "Privy SDK is initialised"
                  : "Privy SDK is not initialised",
            ),
            if (!isInitialised)
              ElevatedButton(
                onPressed: () async {
                  await PrivyNativeWrapper.sharedInstance.initializePrivy();
                  setState(() {
                    isInitialised = true;
                  });
                },
                child: const Text("Initialise Privy"),
              ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "Email",
              ),
            ),
            const SizedBox(height: 8),
            if (isOtpSent)
              TextField(
                controller: otpController,
                decoration: const InputDecoration(
                  labelText: "OTP",
                ),
              ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () async {
                HapticFeedback.heavyImpact();
                bool isSuccess =
                    await PrivyNativeWrapper.sharedInstance.sendOtp(
                  emailId: emailController.text,
                );
                Fluttertoast.showToast(
                  msg: isSuccess ? "OTP sent" : "Error in sending OTP",
                );
                setState(() {
                  isOtpSent = isSuccess;
                });
                print("privy isSuccess: $isSuccess");
              },
              child: const Text("send otp"),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              child: const Text(" otp verify"),
              onPressed: () async {
                HapticFeedback.heavyImpact();

                bool isSuccess =
                    await PrivyNativeWrapper.sharedInstance.authenticateWithOtp(
                  emailId: emailController.text,
                  otp: otpController.text,
                );
                Fluttertoast.showToast(
                  msg: isSuccess ? "OTP verified" : "Error in verifying OTP",
                );
                print("privy isSuccess: $isSuccess");
              },
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              child: const Text("Get Wallets"),
              onPressed: () {
                HapticFeedback.heavyImpact();
                PrivyNativeWrapper.sharedInstance.getWallets();
              },
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              child: const Text(
                "Generate Solana Wallets",
              ),
              onPressed: () async {
                HapticFeedback.heavyImpact();
                bool isSuccess = await PrivyNativeWrapper.sharedInstance
                    .generateSolanaWallet();
                Fluttertoast.showToast(
                  msg: isSuccess
                      ? "Solana Wallet generated"
                      : "Error in generating Solana wallet",
                );
              },
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              child: const Text(
                "Generate EVM Wallets",
              ),
              onPressed: () async {
                HapticFeedback.heavyImpact();
                bool isSuccess =
                    await PrivyNativeWrapper.sharedInstance.generateWallet();
                Fluttertoast.showToast(
                  msg: isSuccess
                      ? "Wallet generated"
                      : "Error in generating wallet",
                );
              },
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              child: const Text(
                "Log Out",
              ),
              onPressed: () async {
                bool isSuccess =
                    await PrivyNativeWrapper.sharedInstance.logout();
                Fluttertoast.showToast(
                  msg: isSuccess ? "Logged out" : "Error in logging out",
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
