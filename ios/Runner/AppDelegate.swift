import UIKit
import Flutter
import CoreTelephony

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let networkInfoChannel = FlutterMethodChannel(name: "network_info",
                                                  binaryMessenger: controller.binaryMessenger)
    
    networkInfoChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      if (call.method == "getNetworkType") {
        result(self.getNetworkType())
      } else {
        result(FlutterMethodNotImplemented)
      }
    })

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func getNetworkType() -> String {
    let networkInfo = CTTelephonyNetworkInfo()
    if let currentRadioTech = networkInfo.currentRadioAccessTechnology {
        switch currentRadioTech {
        case CTRadioAccessTechnologyNR:
            return "5G"
        case CTRadioAccessTechnologyNRNSA:
            return "5G"
        case CTRadioAccessTechnologyLTE:
            return "4G"
        case CTRadioAccessTechnologyeHRPD:
            return "3G"
        case CTRadioAccessTechnologyCDMAEVDORevB:
            return "3G"
        case CTRadioAccessTechnologyCDMAEVDORevA:
            return "3G"
        case CTRadioAccessTechnologyCDMAEVDORev0:
            return "3G"
        case CTRadioAccessTechnologyWCDMA:
            return "3G"
        case CTRadioAccessTechnologyHSDPA:
            return "3G"
        case CTRadioAccessTechnologyHSUPA:
            return "3G"
        case CTRadioAccessTechnologyGPRS:
            return "2G"
        case CTRadioAccessTechnologyEdge:
            return "2G"
        case CTRadioAccessTechnologyCDMA1x:
            return "2G"
        default:
            return "Unknown"
        }
    }
    return "Unknown"
  }
}
