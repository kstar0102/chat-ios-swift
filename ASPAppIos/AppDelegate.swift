//
//  AppDelegate.swift
//  ASPAppIos
//
//  Created by ADV on 2020/03/07.
//  Copyright © 2020 ADV. All rights reserved.
//

import UIKit
import SVProgressHUD
import COREASP
import UserNotifications
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    static func instance() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate;
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        // Only allow portrait (standard behaviour)
        SVProgressHUD.setDefaultStyle(.custom)
        SVProgressHUD.setBackgroundColor(Config.BASE)
        SVProgressHUD.setForegroundColor(UIColor.white)
        SVProgressHUD.setDefaultMaskType(.black)
        return .portrait;
    }
    
    private func topViewControllerWithRootViewController(rootViewController: UIViewController!) -> UIViewController? {
        if (rootViewController == nil) { return nil }
        if (rootViewController.isKind(of: UITabBarController.self)) {
            return topViewControllerWithRootViewController(rootViewController: (rootViewController as! UITabBarController).selectedViewController)
        } else if (rootViewController.isKind(of: UINavigationController.self)) {
            return topViewControllerWithRootViewController(rootViewController: (rootViewController as! UINavigationController).visibleViewController)
        } else if (rootViewController.presentedViewController != nil) {
            return topViewControllerWithRootViewController(rootViewController: rootViewController.presentedViewController)
        }
        return rootViewController
    }

        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
            FirebaseApp.configure()
//*********************************************************************************************
            // CorePushManagerクラスの初期化
            //*********************************************************************************************
            CoreAspManager.shared.debugEnabled = true                // デバッグログを有効
            CorePushManager.shared.configKey = Config.CONFIG_KEY          // コンフィグキーの設定
            CorePushManager.shared.delegate = self                    // CorePushManagerDelegateの設定
//            CorePushManager.shared.registerForRemoteNotifications()   // 通知の登録
            
            // iOS10以上の場合の通知のデリゲート設定
            if #available(iOS 10.0, *) {
                UNUserNotificationCenter.current().delegate = self
                    let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
                    UNUserNotificationCenter.current().requestAuthorization(
                        options: authOptions) { (granted, error) in
                            if let err = error {
                                return
                            }
                            if granted {
                                self.checkBackgroundRefresh()
                            }
                            else{
                            }
                    }
                } else {
                    let settings: UIUserNotificationSettings =
                        UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
                    application.registerUserNotificationSettings(settings)
                }
                
                application.registerForRemoteNotifications()

            //*********************************************************************************************
            // アプリのプロセスが起動していない状態で通知からアプリを起動した時の処理を定義する。
            // launchOptionsに通知のUserInfoが存在する場合は、CorePushManagerDelegate#handleLaunchingNotificationを
            // 呼び出し、存在しない場合は何も行わない。
            //*********************************************************************************************
            CorePushManager.shared.handleLaunchingNotification(withOption: launchOptions)
            
            //*********************************************************************************************
            // アイコンバッジ数をリセットする
            //*********************************************************************************************
            CorePushManager.resetApplicationIconBadgeNumber()
            
            // //アプリ内のユーザーIDの設定
            // CorePushManager.shared.appUserId = "username"

            return true
        }

    func checkBackgroundRefresh() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
                DispatchQueue.main.async{
                    if UIApplication.shared.backgroundRefreshStatus == .denied {
                        print("Refresh denied")
//                        DGSLogv("Backgruond fetch denied.", getVaList([]))
                        
                        let defaults = UserDefaults.standard
                        if !defaults.bool(forKey: "NeverAskBackgroundFetch") {
                            DispatchQueue.main.asyncAfter(deadline: .now()+3.0, execute: {
                                if let vc = self.window?.rootViewController {
                                    let alert = UIAlertController(title: "現在、バックグラウンドでのプッシュ通知が禁止されています。", message: "設定アプリの一般＞Appのバックグラウンド更新で、このアプリをオンにしてください。", preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "このメッセージを今後表示しない", style: .default, handler: { (action) in
                                        defaults.set(true, forKey: "NeverAskBackgroundFetch")
                                        action.isEnabled = false
                                    }))
                                    alert.addAction(UIAlertAction(title: "閉じる", style: .default, handler: { (action) in
                                        alert.dismiss(animated: true)
                                    }))
                                    vc.present(alert, animated: true, completion: nil)
                                }
                            })
                        }
                    }
                }
            }
        }
    }

        // 通知サービスの登録成功時に呼ばれる。
        func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
            NSLog("---- application:didRegisterForRemoteNotificationsWithDeviceToken ----")
            
            //*********************************************************************************************
            // APNSの通知登録の成功時に呼び出される。デバイストークンをcore-aspサーバに登録する。
            //*********************************************************************************************
            let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
            CorePushManager.shared.registerDeviceTokenString(deviceTokenString)
            Common.deviceToken = deviceTokenString
            print(deviceTokenString)
//            UIAlertView(title: "Device Token", message: deviceTokenString,
//                        delegate: nil,
//                        cancelButtonTitle:
//                nil,
//                        otherButtonTitles: "OK").show()

        }
        
        // 通知サービスの登録失敗時に呼ばれる。
        func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
//            NSLog("---- application:didFailToRegisterForRemoteNotificationsWithError ----")
            CorePushManager.shared.registerDeviceTokenString("D5EC82108F366BB82E34E93DAE5A33F00BE17FBB120472C8EB2BBEA4771B7351")
            Common.deviceToken = "D5EC82108F366BB82E34E93DAE5A33F00BE17FBB120472C8EB2BBEA4771B7351"

            //*********************************************************************************************
            // APNSの通知登録の失敗時に呼び出される。
            // 通知サービスの登録に失敗する場合は、iPhoneシミュレータでアプリを実行しているかプッシュ通知が有効化されていない
            // プロビジョニングでビルドしたアプリを実行している可能性があります。
            //*********************************************************************************************
//            NSLog("error: \(error)")
        }
        
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        NSLog("---- application:didReceiveRemoteNotification:fetchCompletionHandler: ----")
        
        //*********************************************************************************************
        // アプリがフォアグランド・バックグランド状態で動作中に通知を受信した時の動作を定義する。
        // バックラウンド状態で通知を受信後に通知からアプリを起動した場合、
        // CorePushManagerDelegate#handleBackgroundNotificationが呼び出されます。
        // フォアグランド状態で通知を受信した場合、CorePushManagerDelegate#handleForegroundNotificationが呼び出されます。
        //*********************************************************************************************
        CorePushManager.shared.handleRemoteNotification(userInfo)
        
        //*********************************************************************************************
        // アイコンバッジ数をリセットする
        //*********************************************************************************************
        CorePushManager.resetApplicationIconBadgeNumber()
        
        completionHandler(.noData)
    }

        func applicationWillResignActive(_ application: UIApplication) {
            // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
            // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        }

        func applicationDidEnterBackground(_ application: UIApplication) {
            // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
            // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        }

        func applicationWillEnterForeground(_ application: UIApplication) {
            //*********************************************************************************************
            // フォアグランド復帰時にcore-aspサーバにデバイストークンを登録する。
            //*********************************************************************************************
            //   if let deviceToken = CorePushManager.shared.deviceToken, deviceToken != "" {
            //       CorePushManager.shared.registerDeviceTokenString(deviceToken)
            //   }
            
            DispatchQueue.main.async {
                self.checkBackgroundRefresh()
            }

        }

        func applicationDidBecomeActive(_ application: UIApplication) {
            //*********************************************************************************************
            // アイコンバッジ数をリセットする
            //*********************************************************************************************
            CorePushManager.resetApplicationIconBadgeNumber()
        }

        func applicationWillTerminate(_ application: UIApplication) {
            // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        }
}

// MARK: - CorePushManagerDelegate

extension AppDelegate: CorePushManagerDelegate {
    
    func handleBackgroundNotification(_ userInfo: [AnyHashable: Any]) {
         NSLog("---- handleBackgroundNotification ----- \(userInfo)")
        
        //*********************************************************************************************
        //    // アプリがバックグランドで動作中に通知からアプリを起動した時の動作を定義
        //    if let url = userInfo["url"] as? String, url != "" {
        //        NSLog("url: \(url)")
        //    }
        //*********************************************************************************************
        
        //*********************************************************************************************
        //    // 通知からの起動を把握するためのアクセス解析用のパラメータを送信
            if let pushId = userInfo["push_id"] as? String {
                CorePushAnalyticsManager.shared.requestAppLaunchAnalytics(pushId, latitude: "0", longitude: "0")
            }
        //*********************************************************************************************
    }
    
    func handleForegroundNotifcation(_ userInfo: [AnyHashable: Any]) {
        NSLog("---- handleForegroundNotifcation ----- \(userInfo)")
        
        //*********************************************************************************************
        //    //アプリがフォアグランドで動作中に通知を受信した時の動作を定義
        //    if let url = userInfo["url"] as? String, url != "" {
        //        NSLog("url: \(url)")
        //    }
        //
        //    // リッチ通知ではない場合 userInfoオブジェクトから通知メッセージを取得
        //    if let aps = userInfo["aps"] as? [String: Any], let message = aps["alert"] as? String  {
        //       NSLog("message: \(message)")
        //    }
        //*********************************************************************************************
        
        //*********************************************************************************************
        //    // 通知からの起動を把握するためのアクセス解析用のパラメータを送信
            if let pushId = userInfo["push_id"] as? String {
                CorePushAnalyticsManager.shared.requestAppLaunchAnalytics(pushId, latitude: "0", longitude: "0")
            }
        //*********************************************************************************************
    }
    
    func handleLaunchingNotification(_ userInfo: [AnyHashable: Any]) {
        NSLog("---- handleLaunchingNotification ----- \(userInfo)")
        
        //*********************************************************************************************
        //    //アプリが起動中でない状態で通知からアプリを起動した時の動作を定義
        //
        //    if let url = userInfo["url"] as? String, url != "" {
        //        NSLog("url: \(url)")
        //    }
        //
        //    //userInfoオブジェクトから通知メッセージを取得
        //    if let aps = userInfo["aps"] as? [String: Any], let message = aps["alert"] as? String  {
        //       NSLog("message: \(message)")
        //    }
        //********************************************************************************************
        
        //*********************************************************************************************
        //    //通知からの起動を把握するためのアクセス解析用のパラメータを送信
            if let pushId = userInfo["push_id"] as? String {
                CorePushAnalyticsManager.shared.requestAppLaunchAnalytics(pushId, latitude: "0", longitude: "0")
            }
        //*********************************************************************************************
    }
}

// MARK: - UNUserNotificationCenterDelegate (iOS10以上の場合)

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {

        if response.notification.request.trigger is UNPushNotificationTrigger {
            let userInfo = response.notification.request.content.userInfo
            NSLog("---- userNotificationCenter:didReceive:withCompletionHandler ----- \(userInfo)")
            CorePushManager.shared.handleRemoteNotification(userInfo)
        }
        
        completionHandler()
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        NSLog("---- userNotificationCenter:willPresent:withCompletionHandler ----- \(userInfo)")

        if notification.request.trigger is UNPushNotificationTrigger {
            CorePushManager.shared.handleRemoteNotification(userInfo)
//            completionHandler([])
            
            //*********************************************************************************************
            //    // フォアグランド時に通知センターに通知を表示する場合の設定 (こちらの設定を使用する場合は、上記の２行のコードを削除する)
                completionHandler([.badge, .sound, .alert])
            //*********************************************************************************************
        }
    }
}
