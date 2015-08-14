//
//  File: AppDelegate.swift
//  
//  Application: Tend
//
//  Created by Dan Xiaoyu Yu on 8/6/15.
//  Copyright (c) 2015 Corner Innovations. All rights reserved.
//


import UIKit
import Parse
import FacebookSDK
import ParseFacebookUtilsV4


/* Application Start: AppDelegate
 * ------------------------------
 * Provide the necessary configuration for Parse and Facebook Integration and redirect user to login/signup
 * screen if user is not currently active. Register push notifications and then configure FB-SDK to accept
 * incoming and outgoing REST api calls.
 */
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

//    UINavigationBar.appearance().barTintColor = navbarColor
    UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: navbarTextColor]
    UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: UIFont(name: "Avenir-Light", size: 22)!]
//    UITabBar.appearance().barTintColor = tabbarColor
//    UITabBar.appearance().tintColor = tabbarTextColor
//    UIApplication.sharedApplication().applicationIconBadgeNumber = 0
    
    Parse.setApplicationId(parseAppId, clientKey: parseAppSecret)
    PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions)
    PFUser.enableRevocableSessionInBackground()
    
    if PFUser.currentUser() == nil || !PFUser.currentUser()!.isAuthenticated() {
      var redirectLogin = mainBoard.instantiateViewControllerWithIdentifier("LoginVC") as! LoginViewController
      window!.rootViewController = redirectLogin
    }
    
    if UIApplication.sharedApplication().respondsToSelector("registerUserNotificationSettings:") {
      let notificationTypes = UIUserNotificationType.Alert | UIUserNotificationType.Badge | UIUserNotificationType.Sound
      let notificationSettings = UIUserNotificationSettings(forTypes: notificationTypes, categories: nil)
      UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
    }
    
    return true
  }

  func application(application: UIApplication,
    openURL url: NSURL,
    sourceApplication: String?,
    annotation: AnyObject?) -> Bool {
      return FBSDKApplicationDelegate.sharedInstance().application(application,
        openURL: url,
        sourceApplication: sourceApplication,
        annotation: annotation)
  }
  
  func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
    UIApplication.sharedApplication().registerForRemoteNotifications()
  }
  
  func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
    println(error.localizedDescription)
  }
  
  func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
    let currentInstallation = PFInstallation.currentInstallation()
    currentInstallation.setDeviceTokenFromData(deviceToken)
    currentInstallation.saveInBackgroundWithBlock(nil)
  }
  
  func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
    NSNotificationCenter.defaultCenter().postNotificationName("displayMessage", object: userInfo)
    NSNotificationCenter.defaultCenter().postNotificationName("reloadMessages", object: nil)
  }

  func applicationWillResignActive(application: UIApplication) {}

  func applicationDidEnterBackground(application: UIApplication) {}

  func applicationWillEnterForeground(application: UIApplication) {}

  func applicationDidBecomeActive(application: UIApplication) {FBSDKAppEvents.activateApp()}
  
  func applicationWillTerminate(application: UIApplication) {}
}

