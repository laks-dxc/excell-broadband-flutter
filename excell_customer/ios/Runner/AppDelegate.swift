//import UIKit
//import Flutter
//
//
//@UIApplicationMain
//@objc class AppDelegate: FlutterAppDelegate {
//  override func application(
//    _ application: UIApplication,
//    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//
//    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
//    let flutterChannel = FlutterMethodChannel(name: "test_activity",
//                                              binaryMessenger: controller.binaryMessenger)
//    flutterChannel.setMethodCallHandler({
//      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
//      // Note: this method is invoked on the UI thread.
//      guard call.method == "startNewActivity" else {
//         result(FlutterMethodNotImplemented)
//         return
//      }
//
//
//        GeneratedPluginRegistrant.register(with: self)
//
//        let flutterViewController: FlutterViewController = window?.rootViewController as! FlutterViewController
//
//         //
//         let navigationController = UINavigationController(rootViewController: flutterViewController)
//         navigationController.isNavigationBarHidden = true
//         window?.rootViewController = navigationController
//         mainCoordinator = AppCoordinator(navigationController: navigationController)
//         window?.makeKeyAndVisible()
//
//
//    })
//
//    GeneratedPluginRegistrant.register(with: self)
//    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
//  }
//}

//import UIKit
//import Flutter
//
//@UIApplicationMain
//@objc class AppDelegate: FlutterAppDelegate {
//  private var mainCoordinator: AppCoordinator?
//  override func application(
//    _ application: UIApplication,
//    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
//  ) -> Bool {
//    GeneratedPluginRegistrant.register(with: self)
//
//    let flutterViewController: FlutterViewController = window?.rootViewController as! FlutterViewController
//    //
//    let tstChannel = FlutterMethodChannel(name: "test_activity",
//                                          binaryMessenger: flutterViewController.binaryMessenger)
//    tstChannel.setMethodCallHandler({
//        (call: FlutterMethodCall, result: FlutterResult) -> Void in
//        guard call.method == "startNewActivity" else {
//            result(FlutterMethodNotImplemented)
//            return
//        }
//        self.mainCoordinator?.start()
//    })
//    //
//    GeneratedPluginRegistrant.register(with: self)
//    //
//    let navigationController = UINavigationController(rootViewController: flutterViewController)
//    navigationController.isNavigationBarHidden = true
//    window?.rootViewController = navigationController
//    mainCoordinator = AppCoordinator(navigationController: navigationController)
//    window?.makeKeyAndVisible()
//
//    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
//  }
//}



//        if let args = call.arguments as? Dictionary<String, Any>,
//            let msg = args["MSG"] as? String
//             {
//            print(msg) // or your syntax
//
//
//
//
//
//
//
//          } else {
//            result(FlutterError.init(code: "bad args", message: nil, details: nil))
//          }



//import UIKit
//import Flutter
//
//@UIApplicationMain
//@objc class AppDelegate: FlutterAppDelegate {
//  private var mainCoordinator: AppCoordinator?
//  override func application(
//    _ application: UIApplication,
//    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
//  ) -> Bool {


//    let flutterViewController: FlutterViewController = window?.rootViewController as! FlutterViewController
//    //
//    let tstChannel = FlutterMethodChannel(name: "test_activity",
//                                          binaryMessenger: flutterViewController.binaryMessenger)
//    tstChannel.setMethodCallHandler({
//        (call: FlutterMethodCall, result: FlutterResult) -> Void in
//        guard call.method == "startNewActivity" else {
//            result(FlutterMethodNotImplemented)
//            return
//        }
//        self.mainCoordinator?.start()
//    })
//
//    GeneratedPluginRegistrant.register(with: self)
//
//    let navigationController = UINavigationController(rootViewController: flutterViewController)
//    navigationController.isNavigationBarHidden = true
//    window?.rootViewController = navigationController
//    mainCoordinator = AppCoordinator(navigationController: navigationController)
//    window?.makeKeyAndVisible()
//
//    let flutterViewController: FlutterViewController = window?.rootViewController as! FlutterViewController
//
//    let flutterChannel = FlutterMethodChannel.init(name: "test_activity", binaryMessenger: flutterViewController.binaryMessenger);
//
//    flutterChannel.setMethodCallHandler { (flutterMethodCall, flutterResult) in
//        if flutterMethodCall.method == "startNewActivity" {
//            UIView.animate(withDuration: 0.5, animations: {
//                self.window?.rootViewController = nil
//
//                let viewToPush = NewsViewController()
//                let navigationController = UINavigationController(rootViewController: flutterViewController)
//
//                self.window = UIWindow(frame: UIScreen.main.bounds)
//                self.window?.makeKeyAndVisible()
//                self.window.rootViewController = navigationController
//                navigationController.isNavigationBarHidden = true
//                navigationController.pushViewController(viewToPush, animated: true)
//            })
//        }
//    }
//    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
//  }
//}

import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    var controller : FlutterViewController?
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
        }
        guard let flutterViewController  = window?.rootViewController as? FlutterViewController else {
            return super.application(application, didFinishLaunchingWithOptions: launchOptions)
        }
        
        GeneratedPluginRegistrant.register(with: self)
        
        let flutterChannel = FlutterMethodChannel.init(name: "test_activity", binaryMessenger: flutterViewController.binaryMessenger);
        flutterChannel.setMethodCallHandler { (flutterMethodCall, flutterResult) in
            if flutterMethodCall.method == "startNewActivity" {
                UIView.animate(withDuration: 0.0, animations: {
                    self.window?.rootViewController = nil
                    
                    let viewToPush = SecondViewController()
                    let navigationController = UINavigationController(rootViewController: flutterViewController)
                    
                    self.window = UIWindow(frame: UIScreen.main.bounds)
                    self.window?.makeKeyAndVisible()
                    self.window.rootViewController = navigationController
                    navigationController.isNavigationBarHidden = false
                    if let args = flutterMethodCall.arguments as? Dictionary<String, Any>,
                       let msg = args["MSG"] as? String
                    {
                        viewToPush.msg = msg
                        navigationController.pushViewController(viewToPush, animated: false)
                    }
                })
            }
        }
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    override func applicationDidBecomeActive(_ application: UIApplication) {
        signal(SIGPIPE, SIG_IGN);
    }
    
    override func applicationWillEnterForeground(_ application: UIApplication) {
        signal(SIGPIPE, SIG_IGN);
    }
    
}

