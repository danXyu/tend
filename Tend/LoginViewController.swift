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


// ***************************
// MARK: - LoginViewController
// ***************************

class LoginViewController: UIViewController {
  
  
  // *****************************************
  // MARK: - Variables, Outlets, and Constants
  // *****************************************
  
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
  
  
  // *************************************
  // MARK: - View Controller Configuration
  // *************************************
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    bgImageView.image = UIImage(named: "LoginBackgroundBeta")
    bgImageView.contentMode = .ScaleAspectFill
    
    titleLabel.text = "Tend"
    titleLabel.font = UIFont(name: defaultFont, size: 50)
    titleLabel.textColor = UIColor.whiteColor()
    
    let attributedText = NSMutableAttributedString(string: "Don't have an account? Sign up")
    attributedText.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.StyleSingle.rawValue, range: NSMakeRange(23, 7))
    attributedText.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor(), range: NSMakeRange(0, attributedText.length))
    noAccountButton.setAttributedTitle(attributedText, forState: .Normal)
    noAccountButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    noAccountButton.titleLabel?.font = UIFont(name: defaultFont, size: 12)
    
    forgotPassword.setTitle("Forgot Password?", forState: .Normal)
    forgotPassword.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    forgotPassword.titleLabel?.font = UIFont(name: defaultFont, size: 12)
    
    userContainer.backgroundColor = UIColor.clearColor()
    userLabel.text = "Email"
    userLabel.textColor = UIColor.whiteColor()
    userLabel.font = UIFont(name: defaultFont, size: 18)
    userTextField.text = ""
    userTextField.textColor = UIColor.whiteColor()
    userTextField.font = UIFont(name: defaultFont, size: 18)
    
    passwordContainer.backgroundColor = UIColor.clearColor()
    passwordLabel.text = "Password"
    passwordLabel.textColor = UIColor.whiteColor()
    passwordLabel.font = UIFont(name: defaultFont, size: 18)
    passwordTextField.text = ""
    passwordTextField.textColor = UIColor.whiteColor()
    passwordTextField.font = UIFont(name: defaultFont, size: 18)
    passwordTextField.secureTextEntry = true
    
    signInButton.setTitle("Sign In", forState: .Normal)
    signInButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    signInButton.titleLabel?.font = UIFont(name: defaultFont, size: 22)
    signInButton.layer.borderWidth = 3
    signInButton.layer.borderColor = UIColor.whiteColor().CGColor
    signInButton.layer.cornerRadius = 5
    signInButton.addTarget(self, action: "loginNormal", forControlEvents: .TouchUpInside)
    
    facebookButton.setTitle("Sign in with Facebook", forState: .Normal)
    facebookButton.titleLabel?.font = UIFont(name: defaultFont, size: 16)
    facebookButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    facebookButton.backgroundColor = UIColor(red: 0.21, green: 0.30, blue: 0.55, alpha: 1.0)
    facebookButton.addTarget(self, action: "loginFacebook", forControlEvents: .TouchUpInside)
  }
  
  override func willTransitionToTraitCollection(newCollection: UITraitCollection, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
    titleLabel.hidden = newCollection.verticalSizeClass == UIUserInterfaceSizeClass.Compact
  }
  
  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return .LightContent
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
  
  // ***************************
  // MARK: - Parse Login Methods
  // ***************************
  
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
        self.performSegueWithIdentifier("loginSuccess", sender: self)
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
  
  func createFacebookUser() {
    FBRequestConnection.startWithGraphPath("me", completionHandler: { (connection, user, fbError) -> Void in
      if let userEmail = user.objectForKey("email") as? String {currentUser.email = userEmail}
      var id = user.objectID as String
      var url = NSURL(string: "https://graph.facebook.com/\(id)/picture?width=640&height=640")!
      var data = NSData(contentsOfURL: url)
      var image = UIImage(data: data!)
      var imageS = scaleImage(image!, 60)
      var dataS = UIImageJPEGRepresentation(imageS, 0.9)
      
      currentUser["fbId"] = user.objectID as String!
      currentUser["proPic"] = PFFile(name: "proPic.jpg", data: dataS)
      currentUser["fullName"] = user.name
      currentUser["firstName"] = user.first_name as String!
      currentUser["lastName"] = user.last_name as String!
      currentUser["school"] = "Generic High School"
      currentUser["year"] = "Year Placeholder"
      
      currentUser.saveInBackgroundWithBlock({ (done, error) -> Void in
        if error == nil {
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
