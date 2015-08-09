//
//  File: SignupViewController.swift
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


/* View Controller: SignupViewController
 * -------------------------------------
 *
 */
class SignupViewController: UIViewController {
  
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
  
  @IBOutlet var hasAccountButton : UIButton!
  @IBOutlet var signUpButton : UIButton!
  @IBOutlet var facebookButton : UIButton!
  
  
  /* Function: viewDidLoad()
   * -----------------------
   *
   */
  override func viewDidLoad() {
    super.viewDidLoad()
    
    bgImageView.image = UIImage(named: "nav-bg-2")
    bgImageView.contentMode = .ScaleAspectFill
    
    titleLabel.text = "Sign Up"
    titleLabel.textColor = UIColor.whiteColor()
    
    let attributedText = NSMutableAttributedString(string: "Already have an account? Sign In")
    attributedText.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.StyleSingle.rawValue, range: NSMakeRange(23, 7))
    attributedText.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor(), range: NSMakeRange(0, attributedText.length))
    hasAccountButton.setAttributedTitle(attributedText, forState: .Normal)
    hasAccountButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    
    userContainer.backgroundColor = UIColor.clearColor()
    userLabel.text = "Email Address"
    userLabel.textColor = UIColor.whiteColor()
    userTextField.text = ""
    userTextField.textColor = UIColor.whiteColor()
    
    passwordContainer.backgroundColor = UIColor.clearColor()
    passwordLabel.text = "Password"
    passwordLabel.textColor = UIColor.whiteColor()
    passwordTextField.text = ""
    passwordTextField.textColor = UIColor.whiteColor()
    passwordTextField.secureTextEntry = true
    
    signUpButton.setTitle("Sign In", forState: .Normal)
    signUpButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    signUpButton.layer.borderWidth = 3
    signUpButton.layer.borderColor = UIColor.whiteColor().CGColor
    signUpButton.layer.cornerRadius = 5
    signUpButton.addTarget(self, action: "registerNormal", forControlEvents: .TouchUpInside)
    
    facebookButton.setTitle("Sign in with Facebook", forState: .Normal)
    facebookButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    facebookButton.backgroundColor = UIColor(red: 0.21, green: 0.30, blue: 0.55, alpha: 1.0)
    facebookButton.addTarget(self, action: "registerFacebook", forControlEvents: .TouchUpInside)
  }
  
  override func willTransitionToTraitCollection(newCollection: UITraitCollection, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
    
    titleLabel.hidden = newCollection.verticalSizeClass == UIUserInterfaceSizeClass.Compact    }
  
  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return .LightContent
  }
  
  func dismiss(){
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
  func registerNormal() {
    
  }
  
  func registerFacebook() {
    
  }
  
  /* Function: createNormalUser()
  * ----------------------------
  *
  */
  func createNormalUser() {
    PFUser().signUpInBackgroundWithBlock { (succeeded, error) -> Void in
      if error == nil {
        self.performSegueWithIdentifier("signedup", sender: self)
      } else {
        if let errorString = error!.userInfo?["error"] as? NSString {
          var alert = UIAlertView(title: "Error", message: errorString as String, delegate: self, cancelButtonTitle: "okay")
          alert.show()
        }
        
      }
    }
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
  
}
