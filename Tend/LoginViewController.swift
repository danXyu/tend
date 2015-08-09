//
//  File: LoginViewController.swift
//
//  Application: Tend
//
//  Created by Dan Xiaoyu Yu on 8/6/15.
//  Copyright (c) 2015 Corner Innovations. All rights reserved.
//


import Foundation
import UIKit
import MBProgressHUD
import Parse
import ParseFacebookUtilsV4
import FacebookSDK


/* View Controller: LoginViewController 
 * -------------------------------------
 *
 */
class LoginViewController: UIViewController {
  
  
  @IBOutlet var titleLabel : UILabel!
  @IBOutlet var bgImageView : UIImageView!
  @IBOutlet var facebookButton : UIButton!
  
  
  /* Function: viewDidLoad()
   * -----------------------
   *
   */
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if PFUser.currentUser() != nil {
      self.performSegueWithIdentifier("loginSuccess", sender: self)
    }
    
//    bgImageView.image = UIImage(named: "RegistrationBackground")
    bgImageView.contentMode = .ScaleAspectFill
    
    titleLabel.text = "Sign In View"
    titleLabel.textColor = UIColor.whiteColor()
    
    facebookButton.setTitle("Sign in with Facebook", forState: .Normal)
    facebookButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    facebookButton.backgroundColor = UIColor(red: 0.21, green: 0.30, blue: 0.55, alpha: 1.0)
    facebookButton.addTarget(self, action: "loginFacebook", forControlEvents: .TouchUpInside)
  }
  
  
  /* Function: willTransitionToTraitCollection:withTransitionCoordinator()
   * ---------------------------------------------------------------------
   *
   */
  override func willTransitionToTraitCollection(newCollection: UITraitCollection, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
    titleLabel.hidden = newCollection.verticalSizeClass == UIUserInterfaceSizeClass.Compact
  }
  
  
  /* Function: preferredStatusBarStyle()
   * -----------------------------------
   *
   */
  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return .LightContent
  }
  
  
  /* Function: textFieldShouldReturn()
   * ---------------------------------
   *
   */
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
  
  /* Function: loginFacebook()
   * -------------------------
   *
   */
  func loginFacebook() {
    MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    
    var permissions = ["public_profile", "email", "user_friends"]
    PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions) { (user: PFUser?, error: NSError?) -> Void in
      if let user = user {
        if user.isNew {
          NSLog("User signed up and logged in through Facebook!")
          hasSignedUp = true
          currentUser = user
          self.createFacebookUser()
          
        } else {
          NSLog("User logged in through Facebook!")
          currentUser = user
          if UIDevice.currentDevice().model != "iPhone Simulator" {
            let currentInstallation = PFInstallation.currentInstallation()
            currentInstallation["user"] = currentUser
            currentInstallation.saveInBackground()
          }
          MBProgressHUD.hideHUDForView(self.view, animated: true)
          self.performSegueWithIdentifier("loginSuccess", sender: self)
          
        }
      } else {
        NSLog("Something went wrong. User cancelled facebook Login")
        MBProgressHUD.hideHUDForView(self.view, animated: true)
      }
    }
  }
  
  
  /* Function: createFacebookUser()
   * ------------------------------
   *
   */
  func createFacebookUser() {
    
    FBRequestConnection.startWithGraphPath("me", completionHandler: { (connection, user, fbError) -> Void in
      
      if let userEmail = user.objectForKey("email") as? String {
        currentUser.email = userEmail
      }
      
      if let gender = user.objectForKey("gender") as? String {
        currentUser["gender"] = gender
      }
      
      var id = user.objectID as String
      var url = NSURL(string: "https://graph.facebook.com/\(id)/picture?width=640&height=640")!
      var data = NSData(contentsOfURL: url)
      var image = UIImage(data: data!)
      var imageL = scaleImage(image!, 320)
      var imageS = scaleImage(image!, 60)
      var dataL = UIImageJPEGRepresentation(imageL, 0.9)
      var dataS = UIImageJPEGRepresentation(imageS, 0.9)
      
      currentUser["dpLarge"] = PFFile(name: "dpLarge.jpg", data: dataL)
      currentUser["dpSmall"] = PFFile(name: "dpSmall.jpg", data: dataS)
      currentUser["fullname"] = user.name
      currentUser["name"] = user.first_name as String!
      currentUser["fbId"] = user.objectID as String!
      currentUser["age"] = 18
      
      currentUser.saveInBackgroundWithBlock({ (done, error) -> Void in
        if !(error != nil) {
          if UIDevice.currentDevice().model != "iPhone Simulator" {
            let currentInstallation = PFInstallation.currentInstallation()
            currentInstallation["user"] = currentUser
            currentInstallation.saveInBackground()
          }
          MBProgressHUD.hideHUDForView(self.view, animated: true)
          self.performSegueWithIdentifier("loginSuccess", sender: self)
        } else {
          println(error)
          MBProgressHUD.hideHUDForView(self.view, animated: true)
          
        }
      })
    })
  }
}
