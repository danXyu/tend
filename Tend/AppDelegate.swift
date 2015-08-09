//
//  AppDelegate.swift
//  Tend
//
//  Created by Dan Xiaoyu Yu on 8/6/15.
//  Copyright (c) 2015 Corner Innovations. All rights reserved.
//

import UIKit
import Parse
import FacebookSDK
import ParseFacebookUtilsV4

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?


  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    
    Parse.setApplicationId(parseAppId, clientKey: parseAppSecret)
    PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions)
    
    if PFUser.currentUser() == nil || !(PFUser.currentUser()!).isAuthenticated() {
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

  func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
    UIApplication.sharedApplication().registerForRemoteNotifications()
  }
  
  func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
    println(error.localizedDescription)
  }
  
//  func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
//    let currentInstallation = PFInstallation.currentInstallation()
//    currentInstallation.setDeviceTokenFromData(deviceToken)
//    currentInstallation.saveInBackgroundWithBlock(nil)
//  }
  
  func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
    //AudioServicesPlayAlertSound(1110)
    
    NSNotificationCenter.defaultCenter().postNotificationName("displayMessage", object: userInfo)
    NSNotificationCenter.defaultCenter().postNotificationName("reloadMessages", object: nil)
  }
  
  //    var gameScore = PFObject(className: "GameScore")
  //    gameScore["score"] = 1337
  //    gameScore["playerName"] = "John"
  //    gameScore.saveInBackground()

  func applicationWillResignActive(application: UIApplication) {}

  func applicationDidEnterBackground(application: UIApplication) {}

  func applicationWillEnterForeground(application: UIApplication) {}

  func applicationDidBecomeActive(application: UIApplication) {}

  func applicationWillTerminate(application: UIApplication) {}

}

