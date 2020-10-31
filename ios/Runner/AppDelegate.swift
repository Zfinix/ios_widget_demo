import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let emojiChannel = FlutterMethodChannel(name: "emoji.widget",
                                                binaryMessenger: controller.binaryMessenger)
        emojiChannel.setMethodCallHandler({
           (call: FlutterMethodCall, result: FlutterResult) -> Void in
            // Note: this method is invoked on the UI thread.
            guard call.method == "setItem" else {
                result(FlutterMethodNotImplemented)
                return
            }
            
            if let args = call.arguments as? Dictionary<String, Any>,
               let key = args["key"] as? String,
               let value = args["value"] as? String {
                let sharedDefaults = UserDefaults.init(suiteName: "group.iosWidgetDemo")
                
                sharedDefaults?.removeObject(forKey: key)
                sharedDefaults?.set(value, forKey: key)
                result(true) // or your syntax
            } else {
                result(FlutterError.init(code: "bad args", message: nil, details: nil))
            }
            
            
        })
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
