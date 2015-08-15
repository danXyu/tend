//
//  File: ForgotViewController.swift
//  
//  Application: Tend
//
//  Created by Donna Yu on 8/6/15.
//  Copyright (c) 2015 Donna Yu. All rights reserved.
//


import Foundation
import UIKit
import Parse
import MBProgressHUD


// ****************************
// MARK: - ForgotViewController
// ****************************

class ForgotViewController: UIViewController {
  
  
  // *****************************************
  // MARK: - Variables, Outlets, and Constants
  // *****************************************
  
  @IBOutlet var titleLabel : UILabel!
  @IBOutlet var bgImageView : UIImageView!
  
  @IBOutlet var userContainer : UIView!
  @IBOutlet var userLabel : UILabel!
  @IBOutlet var userTextField : UITextField!
  @IBOutlet var userUnderline : UIView!
  
  @IBOutlet var resetPasswordButton : UIButton!
  @IBOutlet var hasAccountButton : UIButton!
  
  
  // *************************************
  // MARK: - View Controller Configuration
  // *************************************
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    bgImageView.image = UIImage(named: "LoginBackgroundBeta")
    bgImageView.contentMode = .ScaleAspectFill
    
    titleLabel.text = "Reset Password"
    titleLabel.textColor = UIColor.whiteColor()
    
    if (phoneHeight >= 667) {
      titleLabel.font = UIFont(name: defaultFont, size: 50)
    }
    
    let attributedText = NSMutableAttributedString(string: "Already have an account? Sign In")
    attributedText.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.StyleSingle.rawValue, range: NSMakeRange(25, 7))
    attributedText.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor(), range: NSMakeRange(0, attributedText.length))
    hasAccountButton.setAttributedTitle(attributedText, forState: .Normal)
    hasAccountButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    hasAccountButton.titleLabel?.font = UIFont(name: defaultFont, size: 12)
    
    userContainer.backgroundColor = UIColor.clearColor()
    userLabel.text = "Email"
    userLabel.textColor = UIColor.whiteColor()
    userLabel.font = UIFont(name: defaultFont, size: 18)
    userTextField.text = ""
    userTextField.textColor = UIColor.whiteColor()
    userTextField.font = UIFont(name: defaultFont, size: 18)
    
    resetPasswordButton.setTitle("Reset Password", forState: .Normal)
    resetPasswordButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    resetPasswordButton.titleLabel?.font = UIFont(name: defaultFont, size: 22)
    resetPasswordButton.layer.borderWidth = 3
    resetPasswordButton.layer.borderColor = UIColor.whiteColor().CGColor
    resetPasswordButton.layer.cornerRadius = 5
    resetPasswordButton.addTarget(self, action: "resetPassword", forControlEvents: .TouchUpInside)
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
  
  
  // ***********************************
  // MARK: - Parse Reset Password Method
  // ***********************************
  
  func resetPassword() {
    MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    var emailAddress = userTextField.text
    
    if (emailAddress == "") {
      var alert = UIAlertView(title: "Form Field Error", message: "You must provide an email address", delegate: self, cancelButtonTitle: "Try Again")
      MBProgressHUD.hideHUDForView(self.view, animated: true)
      alert.show()
    } else {
      PFUser.requestPasswordResetForEmailInBackground(emailAddress) { (succeeded, error) -> Void in
        if let error = error {
          var alert = UIAlertView(title: "Account Error", message: error.localizedDescription, delegate: self, cancelButtonTitle: "Try Again")
          MBProgressHUD.hideHUDForView(self.view, animated: true)
          alert.show()
        } else {
          var alert = UIAlertView(title: "Password Reset Successful", message: "please check your email", delegate: self, cancelButtonTitle: "Continue")
          MBProgressHUD.hideHUDForView(self.view, animated: true)
          alert.show()
          self.performSegueWithIdentifier("forgotSuccess", sender: self)
        }
      }
    }
  }
}
