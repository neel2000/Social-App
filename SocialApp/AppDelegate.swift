//
//  AppDelegate.swift
//  SocialApp
//
//  Created by DREAMWORLD on 28/11/24.
//

import UIKit
import FirebaseCore
import FirebaseMessaging
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        IQKeyboardManager.shared.isEnabled = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.resignOnTouchOutside = true

        FirebaseApp.configure()
        Messaging.messaging().delegate = self

        self.registerForPushNotifications()

        //self.loadViewController()
        if FCM_TOKEN.isEmpty {
            FCM_TOKEN = UUID().uuidString
        }
        self.checkAppVerion()

        return true
    }
}

extension AppDelegate {

    func checkAppVerion() {

        let param: [String: Any] = [
            "application_version": "1.0",
            "device_type": "ios",
            "device_token": FCM_TOKEN,
            "user_id": ""
        ]

        APIManager.postMethod(with: API_Constants.CHECK_VERSION, param: param, is_header_allow: false) { resDic in
            self.loadViewController()
        }

    }

    func loadViewController() {

        let rootVC = SignupViewController()

        let nav = UINavigationController(rootViewController: rootVC)
        nav.setNavigationBarHidden(true, animated: true)

        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()
    }
}

extension AppDelegate: MessagingDelegate{

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let token = fcmToken else {
            print("Failed to retrieve FCM token.")
            return
        }
        print("FCM token: \(token)")

//        if token.isEmpty {
//            FCM_TOKEN = UUID().uuidString
//        } else {
//            FCM_TOKEN = token
//        }
//        self.checkAppVerion()
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {

    func registerForPushNotifications() {

        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
                (granted, error) in
                print("Permission granted: \(granted)")

                guard granted else {
                    //self.showPermissionAlert()
                    return
                }
                self.getNotificationSettings()
            }
        }
        else {
            let settings = UIUserNotificationSettings(types: [.alert, .sound, .badge], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
            UIApplication.shared.registerForRemoteNotifications()
        }
    }

    @available(iOS 10.0, *)
    func getNotificationSettings() {

        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }

    func showPermissionAlert() {
        let alertController = UIAlertController(title: "Error", message: "Please enable access to Notifications in the Settings app.", preferredStyle: .alert)

        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (alertAction) in
            self.gotoAppSettings()
            alertController.dismiss(animated: false, completion: nil)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(settingsAction)
        alertController.addAction(cancelAction)
        self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }

    private func gotoAppSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }

        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.openURL(settingsUrl)
        }
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

        // Convert token to string
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})

        print("APNs device token: \(deviceTokenString)")
        print("APNs device token1: \(tokenString(deviceToken))")
        Messaging.messaging().apnsToken = deviceToken

    }

    func tokenString(_ deviceToken:Data) -> String{
        //code to make a token string
        let bytes = [UInt8](deviceToken)
        var token = ""
        for byte in bytes{
            token += String(format: "%02x",byte)
        }
        return token
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register:", error)
    }

    @objc func didReceiveNotification(notificationInfo: NSDictionary) {
        self.application(UIApplication.shared, didReceiveRemoteNotification: notificationInfo as! [AnyHashable : Any]) { (UIBackgroundFetchResult) in

            print("Notification UserInfo = ", notificationInfo)
        }
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

        print("Notification UserInfo = ", userInfo)
        if #available(iOS 10.0, *) {

        }
        else {

        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RELOAD_HOME"), object: nil)
        Messaging.messaging().appDidReceiveMessage(userInfo)
        completionHandler (.newData)

    }


    //MARK:-  UNUserNotificationCenter Delegate // >= iOS 10
    //Called when a notification is delivered to a foreground app.
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        let userInfoContent = notification.request.content.userInfo
        Messaging.messaging().appDidReceiveMessage(userInfoContent)
        completionHandler([ .alert, .sound, .badge])
    }

    //Called to let your app know which action was selected by the user for a given notification.
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {

        let userInfo = response.notification.request.content.userInfo
        Messaging.messaging().appDidReceiveMessage(userInfo)
        completionHandler()
    }
}

