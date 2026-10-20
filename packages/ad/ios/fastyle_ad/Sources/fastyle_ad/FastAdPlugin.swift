import Flutter
import UIKit
import google_mobile_ads

public class FastAdPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "fastyle_ad", binaryMessenger: registrar.messenger())
    let instance = FastAdPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel) 
  }

   public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "initialize":
        let factory = MediumBannerNativeAdFactory()
        let appDelegate = UIApplication.shared.delegate as! FlutterAppDelegate

        FLTGoogleMobileAdsPlugin.registerNativeAdFactory(
            appDelegate, 
            factoryId: "mediumBanner", 
            nativeAdFactory: factory
        )
        result(true)
    default:
        result(FlutterMethodNotImplemented)
    }
  }
}
