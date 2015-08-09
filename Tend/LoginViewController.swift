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
import ParseFacebookUtilsV4
import FacebookSDK


/* View Controller: LoginViewController 
 * -------------------------------------
 *
 */
class LoginViewController: UIViewController {
  
  
  @IBOutlet var titleLabel : UILabel!
  @IBOutlet var bgImageView : UIImageView!
  
  @IBOutlet var userContainer : UIView!
  @IBOutlet var userLabel : UILabel!
  @IBOutlet var userTextField : UITextField!
  @IBOutlet var userUnderline : UIView!
  
  @IBOutlet var passwordContainer : UIView!
  @IBOutlet var passwordLabel : UILabel!
  @IBOutlet var passwordTextField : UITextField!
  @IBOutlet var passwordUnderline : UIView!
  
  @IBOutlet var forgotPassword : UIButton!
  @IBOutlet var noAccountButton : UIButton!
  @IBOutlet var signInButton : UIButton!
  @IBOutlet var facebookButton : UIButton!
  
  
  /* Function: viewDidLoad()
   * -----------------------
   *
   */
  override func viewDidLoad() {
    super.viewDidLoad()
    
    bgImageView.image = UIImage(named: "nav-bg-2")
    bgImageView.contentMode = .ScaleAspectFill
    
    titleLabel.text = "Sign In"
    titleLabel.textColor = UIColor.whiteColor()
    
    let attributedText = NSMutableAttributedString(string: "Don't have an account? Sign up")
    attributedText.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.StyleSingle.rawValue, range: NSMakeRange(23, 7))
    attributedText.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor(), range: NSMakeRange(0, attributedText.length))
    noAccountButton.setAttributedTitle(attributedText, forState: .Normal)
    noAccountButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    
    forgotPassword.setTitle("Forgot Password?", forState: .Normal)
    forgotPassword.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    
    userContainer.backgroundColor = UIColor.clearColor()
    userLabel.text = "Email"
    userLabel.textColor = UIColor.whiteColor()
    userTextField.text = ""
    userTextField.textColor = UIColor.whiteColor()
    
    passwordContainer.backgroundColor = UIColor.clearColor()
    passwordLabel.text = "Password"
    passwordLabel.textColor = UIColor.whiteColor()
    passwordTextField.text = ""
    passwordTextField.textColor = UIColor.whiteColor()
    passwordTextField.secureTextEntry = true
    
    signInButton.setTitle("Sign In", forState: .Normal)
    signInButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    signInButton.layer.borderWidth = 3
    signInButton.layer.borderColor = UIColor.whiteColor().CGColor
    signInButton.layer.cornerRadius = 5
    signInButton.addTarget(self, action: "loginNormal", forControlEvents: .TouchUpInside)
    
    facebookButton.setTitle("Sign in with Facebook", forState: .Normal)
    facebookButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    facebookButton.backgroundColor = UIColor(red: 0.21, green: 0.30, blue: 0.55, alpha: 1.0)
    facebookButton.addTarget(self, action: "loginFacebook", forControlEvents: .TouchUpInside)
  }
  
  override func willTransitionToTraitCollection(newCollection: UITraitCollection, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
    
    titleLabel.hidden = newCollection.verticalSizeClass == UIUserInterfaceSizeClass.Compact    }
  
  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return .LightContent
  }
  
  
  /* Function: loginNormal()
   * -----------------------
   *
   */
  func loginNormal() {
    MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    var newUsername = userTextField.text
    var newPassword = passwordTextField.text

    PFUser.logInWithUsernameInBackground(newUsername, password: newPassword, block: { (newUser: PFUser?, newError: NSError?) -> Void in
      if newUser != nil {
        currentUser = newUser!
        if UIDevice.currentDevice().model != "iPhone Simulator" {
          let currentInstallation = PFInstallation.currentInstallation()
          currentInstallation["user"] = currentUser
          currentInstallation.saveInBackground()
        }
        self.performSegueWithIdentifier("logintotab", sender: self)
        MBProgressHUD.hideHUDForView(self.view, animated: true)
      } else {
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        
        if let errorString = newError!.userInfo?["error"] as? NSString {
          var alert = UIAlertView(title: "Error", message: errorString as String, delegate: self, cancelButtonTitle: "okay")
          alert.show()
        }
      }
      
    })
  }
  
  
  /* Function: loginFacebook()
   * -------------------------------
   *
   */
  func loginFacebook() {
    MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    var permissions = ["public_profile", "email", "user_friends"]
    PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions, block: { (fbUser: PFUser?, fbError: NSError?) -> Void in
      
      if fbUser == nil {
        NSLog("Something went wrong. User cancelled facebook Login")
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        
      } else if fbUser!.isNew {
        NSLog("User signed up and logged in through Facebook!")
        hasSignedUp = true
        currentUser = fbUser!
        self.createFacebookUser()
        
      } else if fbUser != nil {
        NSLog("User logged in through Facebook!")
        currentUser = fbUser!
        if UIDevice.currentDevice().model != "iPhone Simulator" {
          let currentInstallation = PFInstallation.currentInstallation()
          currentInstallation["user"] = currentUser
          currentInstallation.saveInBackground()
        }
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        self.performSegueWithIdentifier("logintotab", sender: self)
        
      } else {
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        if let errorString = fbError!.userInfo?["error"] as? NSString {
          var alert = UIAlertView(title: "Error", message: errorString as String, delegate: self, cancelButtonTitle: "okay")
          alert.show()
        }
      }
    })
  }
  
  
  /* Function: createFacebookUser()
   * ------------------------------
   *
   */
  func createFacebookUser() {
    
    FBRequestConnection.startWithGraphPath("me", completionHandler: { (connection, fbUser, fbError) -> Void in
      
      if let userEmail = fbUser.objectForKey("email") as? String {
        currentUser.email = userEmail
      }
      
      if let gender = fbUser.objectForKey("gender") as? String {
        currentUser["gender"] = gender
      }
      
      var id = fbUser.objectID as String
      var url = NSURL(string: "https://graph.facebook.com/\(id)/picture?width=640&height=640")!
      var data = NSData(contentsOfURL: url)
      var image = UIImage(data: data!)
      var imageL = scaleImage(image!, 320)
      var imageS = scaleImage(image!, 60)
      var dataL = UIImageJPEGRepresentation(imageL, 0.9)
      var dataS = UIImageJPEGRepresentation(imageS, 0.9)
      
      currentUser["dpLarge"] = PFFile(name: "dpLarge.jpg", data: dataL)
      currentUser["dpSmall"] = PFFile(name: "dpSmall.jpg", data: dataS)
      currentUser["fullname"] = fbUser.name
      currentUser["name"] = fbUser.first_name as String!
      currentUser["fbId"] = fbUser.objectID as String!
      currentUser["age"] = 18
      
      currentUser.saveInBackgroundWithBlock({ (done, error) -> Void in
        if !(error != nil) {
          if UIDevice.currentDevice().model != "iPhone Simulator" {
            let currentInstallation = PFInstallation.currentInstallation()
            currentInstallation["user"] = currentUser
            currentInstallation.saveInBackground()
          }
          MBProgressHUD.hideHUDForView(self.view, animated: true)
          self.performSegueWithIdentifier("logintotab", sender: self)
        } else {
          println(error)
          MBProgressHUD.hideHUDForView(self.view, animated: true)
          
        }
      })
    })
  }
  
  func dismiss(){
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  /* Function: createFacebookUser()
   * ------------------------------
   *
   */
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}
