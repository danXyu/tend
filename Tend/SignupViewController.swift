//
//  File: SignupViewController.swift
//
//  Application: Tend
//
//  Created by Donna Yu on 8/6/15.
//  Copyright (c) 2015 Donna Yu. All rights reserved.
//


import Foundation
import UIKit
import MBProgressHUD
import ParseFacebookUtilsV4
import FacebookSDK


// ***************************
// MARK: - LoginViewController
// ***************************

class SignupViewController: UIViewController, UITextFieldDelegate {
  
  
  // *****************************************
  // MARK: - Variables, Outlets, and Constants
  // *****************************************
  
  @IBOutlet var bgImageView : UIImageView!
  @IBOutlet var titleLabel : UILabel!
  
  @IBOutlet var fullNameContainer : UIView!
  @IBOutlet var fullNameLabel : UILabel!
  @IBOutlet var fullNameTextField : UITextField!
  @IBOutlet var fullNameUnderline : UIView!
  
  @IBOutlet var userContainer : UIView!
  @IBOutlet var userLabel : UILabel!
  @IBOutlet var userTextField : UITextField!
  @IBOutlet var userUnderline : UIView!
  
  @IBOutlet var passwordContainer : UIView!
  @IBOutlet var passwordLabel : UILabel!
  @IBOutlet var passwordTextField : UITextField!
  @IBOutlet var passwordUnderline : UIView!
  
  @IBOutlet var passwordConfirmContainer : UIView!
  @IBOutlet var passwordConfirmLabel : UILabel!
  @IBOutlet var passwordConfirmTextField : UITextField!
  @IBOutlet var passwordConfirmUnderline : UIView!
  
  @IBOutlet var hasAccountButton : UIButton!
  @IBOutlet var signUpButton : UIButton!
  @IBOutlet var facebookButton : UIButton!
  
  var alertError: NSString!
  
  
  // *************************************
  // MARK: - View Controller Configuration
  // *************************************
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.fullNameTextField.delegate = self
    self.userTextField.delegate = self
    self.passwordConfirmTextField.delegate = self
    self.passwordTextField.delegate = self

    bgImageView.image = UIImage(named: "LoginBackgroundBeta")
    bgImageView.contentMode = .ScaleAspectFill
    
    titleLabel.font = UIFont(name: defaultFont, size: 50)
    titleLabel.textColor = UIColor.whiteColor()
    
    if (phoneHeight >= 667) {
      titleLabel.text = "Registration"
    } else {
      titleLabel.text = ""
    }
    
    let attributedText = NSMutableAttributedString(string: "Already have an account? Sign In")
    attributedText.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.StyleSingle.rawValue, range: NSMakeRange(25, 7))
    attributedText.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor(), range: NSMakeRange(0, attributedText.length))
    hasAccountButton.setAttributedTitle(attributedText, forState: .Normal)
    hasAccountButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    hasAccountButton.titleLabel?.font = UIFont(name: defaultFont, size: 12)
    
    fullNameContainer.backgroundColor = UIColor.clearColor()
    fullNameLabel.text = "Full Name"
    fullNameLabel.textColor = UIColor.whiteColor()
    fullNameLabel.font = UIFont(name: defaultFont, size: 18)
    fullNameTextField.text = ""
    fullNameTextField.textColor = UIColor.whiteColor()
    fullNameTextField.font = UIFont(name: defaultFont, size: 18)
    
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
    
    passwordConfirmContainer.backgroundColor = UIColor.clearColor()
    passwordConfirmLabel.text = "Confirm Password"
    passwordConfirmLabel.textColor = UIColor.whiteColor()
    passwordConfirmLabel.font = UIFont(name: defaultFont, size: 18)
    passwordConfirmTextField.text = ""
    passwordConfirmTextField.textColor = UIColor.whiteColor()
    passwordConfirmTextField.font = UIFont(name: defaultFont, size: 18)
    passwordConfirmTextField.secureTextEntry = true
    
    signUpButton.setTitle("Sign Up", forState: .Normal)
    signUpButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    signUpButton.titleLabel?.font = UIFont(name: defaultFont, size: 22)
    signUpButton.layer.borderWidth = 3
    signUpButton.layer.borderColor = UIColor.whiteColor().CGColor
    signUpButton.layer.cornerRadius = 5
    signUpButton.addTarget(self, action: "registerNormal", forControlEvents: .TouchUpInside)
    
    facebookButton.setTitle("Sign Up with Facebook", forState: .Normal)
    facebookButton.titleLabel?.font = UIFont(name: defaultFont, size: 16)
    facebookButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    facebookButton.backgroundColor = UIColor(red: 0.21, green: 0.30, blue: 0.55, alpha: 1.0)
    facebookButton.addTarget(self, action: "registerFacebook", forControlEvents: .TouchUpInside)
  }
  
  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return .LightContent
  }
  
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return true
    }
    
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
  
  // ****************************
  // MARK: - Parse Signup Methods
  // ****************************
  
  func registerNormal() {
    MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    if self.checkNormalSignup() == true {
      self.createNormalUser()
    } else {
      var alert = UIAlertView(title: "Form Field Error", message: alertError as String, delegate: self, cancelButtonTitle: "Try Again")
      MBProgressHUD.hideHUDForView(self.view, animated: true)
      alert.show()
    }
  }
  
  func checkNormalSignup()-> Bool {
    var name = fullNameTextField.text.componentsSeparatedByString(" ")
    if fullNameTextField.text.isEmpty || userTextField.text.isEmpty || passwordTextField.text.isEmpty || passwordConfirmTextField.text.isEmpty {
      MBProgressHUD.hideHUDForView(self.view, animated: true)
      alertError = "All form fields must be filled"
      return false
    } else if name.count < 2 {
      alertError = "Please provide your first AND last name"
      MBProgressHUD.hideHUDForView(self.view, animated: true)
      return false
    } else if passwordTextField.text != passwordConfirmTextField.text {
      alertError = "Passwords did not match"
      MBProgressHUD.hideHUDForView(self.view, animated: true)
      return false
    } else if count(userTextField.text) < 5 {
      MBProgressHUD.hideHUDForView(self.view, animated: true)
      alertError = "Username must be at least 5 characters long"
      return false
    } else if count(passwordTextField.text) <= 6 {
      MBProgressHUD.hideHUDForView(self.view, animated: true)
      alertError = "Password must be more than 6 characters long"
      return false
    }
    return true
  }
  
  func createNormalUser() {
    var name = fullNameTextField.text.componentsSeparatedByString(" ")
    userPF.username = userTextField.text
    userPF.email = userTextField.text
    userPF.password = passwordTextField.text
    
    userPF["fullName"] = fullNameTextField.text
    userPF["firstName"] = name[0] as String
    userPF["lastName"] = name[1] as String
    userPF["school"] = "Generic High School"
    userPF["year"] = "Year Placeholder"
    
    userPF.signUpInBackgroundWithBlock {(succeeded, error) -> Void in
      if error == nil {
        hasSignedUp = true
        currentUser = userPF
        if UIDevice.currentDevice().model != "iPhone Simulator" {
          let currentInstallation = PFInstallation.currentInstallation()
          currentInstallation["user"] = currentUser
          currentInstallation.saveInBackground()
        }
        self.performSegueWithIdentifier("signupSuccess", sender: self)
        var alert = UIAlertView(title: "Sign Up Success", message: "Sign up successful. Please confirm your email.", delegate: self, cancelButtonTitle: "Continue")
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        alert.show()
      } else {
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        if let errorString = error!.userInfo?["error"] as? NSString {
          var alert = UIAlertView(title: "Sign Up Error", message: errorString as String, delegate: self, cancelButtonTitle: "Try Again")
          alert.show()
        }
        
      }
    }
  }
  
  func registerFacebook() {
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
    FBRequestConnection.startWithGraphPath("me", completionHandler: { (connection, fbUser, fbError) -> Void in
      if let userEmail = fbUser.objectForKey("email") as? String {currentUser.email = userEmail}
      var id = fbUser.objectID as String
      var url = NSURL(string: "https://graph.facebook.com/\(id)/picture?width=640&height=640")!
      var data = NSData(contentsOfURL: url)
      var image = UIImage(data: data!)
      var imageS = scaleImage(image!, 60)
      var dataS = UIImageJPEGRepresentation(imageS, 0.9)
      
      currentUser["fbId"] = fbUser.objectID as String!
      currentUser["proPic"] = PFFile(name: "proPic.jpg", data: dataS)
      currentUser["fullName"] = fbUser.name
      currentUser["firstName"] = fbUser.first_name as String!
      currentUser["lastName"] = fbUser.last_name as String!
      currentUser["school"] = "Generic High School"
      currentUser["year"] = "Year Placeholder"
      
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
