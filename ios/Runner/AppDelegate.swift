import UIKit
import Flutter
import flutter_localnotifications

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  let flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin()

  override func application(
     application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    if #available(iOS 10.0, *) {
        UNUserNotificationCenter.current().delegate = self
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}