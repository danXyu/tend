//
//  File: ProfileViewController.swift
//
//  Application: Tend
//
//  Created by Donna Yu on 8/6/15.
//  Copyright (c) 2015 Donna Yu. All rights reserved.
//


import Foundation
import UIKit
import Parse


// *****************************
// MARK: - ProfileViewController
// *****************************

class ProfileViewController : UITableViewController {
  
  @IBOutlet var profileContainer : UIView!
  @IBOutlet var profileImageView : UIImageView!
  @IBOutlet var bgImageView : UIImageView!

  @IBOutlet var nameLabel : UILabel!
  @IBOutlet var nameFieldLabel : UILabel!
  @IBOutlet var emailLabel : UILabel!
  @IBOutlet var emailFieldLabel : UILabel!
  @IBOutlet var schoolLabel : UILabel!
  @IBOutlet var schoolFieldLabel : UILabel!
  @IBOutlet var yearLabel : UILabel!
  @IBOutlet var yearFieldLabel : UILabel!
  @IBOutlet var logoutButton : UIButton!
  
  
  // ************************************
  // MARK: - Necessary View Configuration
  // ************************************
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.separatorColor = UIColor(white: 0.85, alpha: 1.0)
    bgImageView.image = UIImage(named: "ProfileBackground")
    profileImageView.image = UIImage(named: "ProfilePicPlaceholder")
    profileImageView.layer.cornerRadius = 35
    profileImageView.clipsToBounds = true
    
    themeButtonWithText(logoutButton, text: "LOGOUT")
    logoutButton.tintColor = UIColor(red: 0.19, green: 0.38, blue: 0.73, alpha: 1.0)
    logoutButton.addTarget(self, action: "logoutUser", forControlEvents: .TouchUpInside)
  }
  
  override func viewDidAppear(animated: Bool) {
    if let pic = currentUser.objectForKey("proPic") as? PFFile {
      getImage("proPic", profileImageView)
    }
    nameFieldLabel.text = currentUser.objectForKey("fullName") as? String
    emailFieldLabel.text = currentUser.email
    schoolFieldLabel.text = currentUser.objectForKey("school") as? String
    yearFieldLabel.text = currentUser.objectForKey("year") as? String
  }
  
  
  func themeButtonWithText(button: UIButton, text: String){
    let background = UIImage(named: "BorderButton")?.resizableImageWithCapInsets(UIEdgeInsetsMake(10, 10, 10, 10))
    let backgroundTemplate = background!.imageWithRenderingMode(.AlwaysTemplate)
    button.setBackgroundImage(backgroundTemplate, forState: .Normal)
    button.setTitle(text, forState: .Normal)
    button.tintColor = UIColor.whiteColor()
  }
  
  
  // ***************************************
  // MARK: - Parse Logging Out Configuration
  // ***************************************
  
  func logoutUser() {
    PFUser.logOut()
    self.performSegueWithIdentifier("logoutSuccess", sender: self)
  }
  
  
  // ********************************
  // MARK: - Table View Configuration
  // ********************************
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 6
  }
  
  override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    if indexPath.row == 0 {
      return 150
    } else {
      return 62
    }
  }
  
  override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    if indexPath.row == 5 {
      cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, CGRectGetWidth(self.tableView.bounds));
    } else {
      
    }
    cell.layoutMargins = UIEdgeInsetsZero
    cell.selectionStyle = .None
  }
  
  override func viewDidLayoutSubviews() {
    tableView.separatorInset = UIEdgeInsetsZero
    tableView.layoutMargins = UIEdgeInsetsZero
  }
  
  
  // ***************************************************
  // MARK: - General View and Notification Configuration
  // ***************************************************
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    self.registerForKeyboardNotifications()
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    self.deregisterFromKeyboardNotifications()
  }
  
  func registerForKeyboardNotifications () -> Void   {
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardDidShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillBeHidden:", name: UIKeyboardWillHideNotification, object: nil)
  }
  
  func deregisterFromKeyboardNotifications () -> Void {
    let center:  NSNotificationCenter = NSNotificationCenter.defaultCenter()
    center.removeObserver(self, name: UIKeyboardDidHideNotification, object: nil)
    center.removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
  }
  
  func keyboardWasShown(notification: NSNotification) {
    let info : NSDictionary = notification.userInfo!
    let keyboardSize = info.objectForKey(UIKeyboardFrameBeginUserInfoKey)?.CGRectValue().size
    let insets: UIEdgeInsets = UIEdgeInsetsMake(self.tableView.contentInset.top, 0, keyboardSize!.height, 0)
    self.tableView.contentInset = insets
    self.tableView.scrollIndicatorInsets = insets
    self.tableView.contentOffset = CGPointMake(self.tableView.contentOffset.x, self.tableView.contentOffset.y + keyboardSize!.height)
  }
  
  func keyboardWillBeHidden (notification: NSNotification) {
    let info : NSDictionary = notification.userInfo!
    let keyboardSize = info.objectForKey(UIKeyboardFrameBeginUserInfoKey)?.CGRectValue().size
    let insets: UIEdgeInsets = UIEdgeInsetsMake(self.tableView.contentInset.top, 0, keyboardSize!.height, 0)
    self.tableView.contentInset = insets
    self.tableView.scrollIndicatorInsets = insets
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true;
  }
  
  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return .LightContent
  }
}
