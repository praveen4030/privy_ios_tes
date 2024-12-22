import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
      let portalChannel = FlutterMethodChannel(
          name: "com.ppl.zeroxppl/portal",
          binaryMessenger: controller.binaryMessenger
      );
    generatePortalWallet(portalChannel: portalChannel)
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

    private func generatePortalWallet(
        portalChannel: FlutterMethodChannel
    ) {
        portalChannel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
            Task {
                switch call.method {
                case "initializePrivy":
                    if let args = call.arguments as? [String: Any],
                       let clientId = args["clientId"] as? String,
                       let appId = args["appId"] as? String {
                        PrivyHelper.initializePrivy(appId, clientId, result: result)
                    } else {
                        result(FlutterError(code: "INVALID_ARGUMENT", message: "Expected arguments for initializePortal", details: nil))
                    }
                case "sendOtp":
                    if let args = call.arguments as? [String: Any],
                       let emailId = args["emailId"] as? String {
                        PrivyHelper.sendOTP(emailId, result: result)
                    } else {
                        result(FlutterError(code: "INVALID_ARGUMENT", message: "Expected arguments for initializePortal", details: nil))
                    }
                case "authenticateWithOtp":
                    if let args = call.arguments as? [String: Any],
                       let emailId = args["emailId"] as? String,
                       let otp = args["otp"] as? String {
                        PrivyHelper.authenticateWithOtp(emailId,otp, result: result)
                    } else {
                        result(FlutterError(code: "INVALID_ARGUMENT", message: "Expected arguments for initializePortal", details: nil))
                    }
                case "generatePrivyWallet":
                    await PrivyHelper.generateEvmWallet(result: result)
                case "getWallets":
                    await PrivyHelper.getWallets(result: result)
                case "sendEthTransaction":
                    if let args = call.arguments as? [String: Any],
                       let method = args["method"] as? String,
                       let txString = args["txString"] as? String {
                        PrivyHelper.sendEthTransaction(method,txString, result: result)
                    } else {
                        result(FlutterError(code: "INVALID_ARGUMENT", message: "Expected arguments for initializePortal", details: nil))
                    }
                case "generatePrivySolanaWallet":
                    await PrivyHelper.generateSolanaWallet(result: result)
                case "logoutPrivy":
                    await PrivyHelper.logout(result: result)
                default:
                    result(FlutterMethodNotImplemented)
                }
            }
        }
    }
}
