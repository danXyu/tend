//
//  ForgotViewController.swift
//  Tend
//
//  Created by Dan Xiaoyu Yu on 8/6/15.
//  Copyright (c) 2015 Corner Innovations. All rights reserved.
//

import UIKit

class ForgotViewController: UIViewController {
  
  @IBOutlet var titleLabel : UILabel!
  @IBOutlet var bgImageView : UIImageView!
  
  @IBOutlet var userContainer : UIView!
  @IBOutlet var userLabel : UILabel!
  @IBOutlet var userTextField : UITextField!
  @IBOutlet var userUnderline : UIView!
  
  @IBOutlet var resetPasswordButton : UIButton!
  @IBOutlet var hasAccountButton : UIButton!
  
  
  /* Function: viewDidLoad()
   * -----------------------
   *
   */
  override func viewDidLoad() {
    super.viewDidLoad()
    
    bgImageView.image = UIImage(named: "nav-bg-2")
    bgImageView.contentMode = .ScaleAspectFill
    
    titleLabel.text = "Forgot Password"
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
    
    resetPasswordButton.setTitle("Reset Password", forState: .Normal)
    resetPasswordButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    resetPasswordButton.layer.borderWidth = 3
    resetPasswordButton.layer.borderColor = UIColor.whiteColor().CGColor
    resetPasswordButton.layer.cornerRadius = 5
    resetPasswordButton.addTarget(self, action: "dismiss", forControlEvents: .TouchUpInside)
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
  
  func redirectToSignup() {
    
  }
}
