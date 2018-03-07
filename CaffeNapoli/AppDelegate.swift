//
//  AppDelegate.swift
//  CaffeNapoli
//
//  Created by Kev1 on 9/29/17.
//  Copyright © 2017 Kev1. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications
import Stripe
import FBSDKCoreKit
import GoogleSignIn
import Fabric
import Crashlytics
import TwitterKit
import FirebaseAuthUI


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate{

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //
        FirebaseApp.configure()
        //Google Sign In
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
//        GIDSignIn.sharedInstance().delegate = self
        //Stripe
        STPPaymentConfiguration.shared().publishableKey = "pk_test_10iie7Xp98twCbxCC0njHt8L"
        //Stripe + ApplePay
        STPPaymentConfiguration.shared().appleMerchantIdentifier = "merchant.com.caffeNapoli"
        // facebook
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        // twitter
        Fabric.with([Crashlytics.self])
        TWTRTwitter.sharedInstance().start(withConsumerKey:"PUT6xb0mTa9Y5xQIUcIfH6Ir3",
                                       consumerSecret:"WGs093vDE0BX2WTdwopshTOAOkmTdJj6eUZbbPsPNOzItBZ0b6")
        // UI
        window = UIWindow()
        window?.rootViewController = SplashScreenViewController()
        UITabBar.appearance().barTintColor = UIColor.tabBarBlue()
        UITabBar.appearance().tintColor = UIColor.tabBarButtonColor()
        UINavigationBar.appearance().barTintColor = UIColor.NavBarYellow()
        attemptRegisterForNotifications(application: application)
        UIApplication.shared.statusBarStyle = .lightContent
        return true
    }
    //MARK:- receive alert open profile
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        //
        let userInfo = response.notification.request.content.userInfo
        if let followerId = userInfo["followerId"] as? String {
            print(followerId)
            // we want to push the user profile controller for followerId somehow
            let userProfileController = UserProfileController(collectionViewLayout: UICollectionViewFlowLayout())
            userProfileController.userID = followerId // for the person thats dpoing the following
            
            //how do we access our main UI from our AppDelegate file
            if let mainTabBarController = window?.rootViewController as? MainTabBarController {
                // get all my viewControllers
                mainTabBarController.selectedIndex = 0
                //Dismm iss the photo selector if we are on that controller
                mainTabBarController.presentedViewController?.dismiss(animated: true, completion: nil)
                if let homeNavigationController = mainTabBarController.viewControllers?.first as? UINavigationController {
                    homeNavigationController.pushViewController(userProfileController, animated: true)
                }
                
            }
            
        }
    }
    
  
   
    //Facebook
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        GIDSignIn.sharedInstance().handle(url,
                                          sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                          annotation: [:])
        return true
    }
    
//    func application(_ app: UIApplication, open url: URL,
//                     options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
//        let sourceApplication = options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String?
//        if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false {
//            return true
//        }
//        // other URL handling goes here.
//        return false
//    }

   
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        //
        print("Registered with fcm with token:", fcmToken)
    }
    
    // listen for user notifications -= UNUserNotificationCenterDelegate
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        //
        completionHandler(.alert) // shows notifications when app is un the forground
    }
    
    //MARK:- Notification methods
   
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        //
        print("Registered for notifications", deviceToken)
    }
    
    
    
    
    private func attemptRegisterForNotifications(application : UIApplication) {
        print("Attempting to register for APNS") // APNS : Apple Push Notification Services
        //
        Messaging.messaging().delegate = self // MessagingDelegate
        UNUserNotificationCenter.current().delegate = self
        
        // user notification auth
        //All of this works for iOS 10 and above
        let options : UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { (granted, error) in
            if let err = error {
                print("Failed to request Authorization", err)
                return
            }
            //granted
            if granted {
                print("Auth Granted....")
            } else {
                print("Auth denied.")
                
            }
        }
        
       application.registerForRemoteNotifications() //1
        
    }
    
    //
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
//    //Google Sign in
//    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
//        // ...
//        if let error = error {
//           print("could not sign in with Google", error)
//            return
//        }
//        print("Successfully signed in to Google:", user)
//        guard let authentication = user.authentication else { return }
//        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
//                                                       accessToken: authentication.accessToken)
//        print("Signin credential is:",credential)
//        Auth.auth().signIn(with: credential) { (user, error) in
//            //
//            if let error = error {
//                print("could not sign in to Firebase with Google", error)
//                return
//            }
//            print("Successfully signed in to Firebase with Google:", user?.uid ?? "")
//        }
//    }
//
//    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
//        // Perform any operations when the user disconnects from app here.
//        // ...
//        print("Disconnected by Firebase by Google Sign in")
//    }

}


