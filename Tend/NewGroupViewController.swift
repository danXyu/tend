//
//  File: NewGroupViewController.swift
//  
//  Application: Tend
//
//  Created by Dan Xiaoyu Yu on 8/9/15.
//  Copyright (c) 2015 Corner Innovations. All rights reserved.
//


import Foundation
import UIKit
import Parse
import MBProgressHUD


// ******************************
// MARK: - NewGroupViewController
// ******************************

class NewGroupViewController: UITableViewController, UITextFieldDelegate, UINavigationControllerDelegate {
  
  
  // *****************************************
  // MARK: - Variables, Outlets, and Constants
  // *****************************************
  
  @IBOutlet var groupnameLabel: UILabel!
  @IBOutlet var groupnameTextField: UITextField!
  @IBOutlet var schoolLabel: UILabel!
  @IBOutlet var schoolTextField: UITextField!
  @IBOutlet var passwordLabel: UILabel!
  @IBOutlet var passwordTextField: UITextField!
  @IBOutlet var describeLabel: UILabel!
  @IBOutlet var describeFieldLabel: UITextView!
  
  
  // ************************************
  // MARK: - Necessary View Configuration
  // ************************************
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.separatorColor = UIColor(white: 0.75, alpha: 1.0)
  }
  
  
  // ****************************************
  // MARK: - Parse Group Saving Configuration
  // ****************************************
  
  @IBAction func cancelTapped(sender: AnyObject) {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  @IBAction func saveTapped(sender: AnyObject) {
    MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    if (groupnameTextField.text.isEmpty || schoolTextField.text.isEmpty || passwordTextField.text.isEmpty || describeFieldLabel.text == nil) {
      MBProgressHUD.hideHUDForView(self.view, animated: true)
      var alert = UIAlertView(title: "Form Field Error", message: "Group name, school name, password, or description cannot be Empty", delegate: self, cancelButtonTitle: "Try Again")
      alert.show()
    } else {
      let group = PFObject(className: "Groups")
      group["name"] = groupnameTextField.text
      group["school"] = schoolTextField.text
      group["password"] = passwordTextField.text
      group["admins"] = [currentUser]
      group["members"] = [currentUser]
      group["description"] = describeFieldLabel.text!
      
      group.saveInBackgroundWithBlock() { (success, error) -> Void in
        if error == nil {
          MBProgressHUD.hideHUDForView(self.view, animated: true)
          var alert = UIAlertView(title: "Success", message: "Group successfully created! Click to manage your group.", delegate: self, cancelButtonTitle: "Continue")
          alert.show()
          self.dismissViewControllerAnimated(true, completion: nil)
        } else {
          MBProgressHUD.hideHUDForView(self.view, animated: true)
        }
      }
    }
  }
  
  
  // ********************************
  // MARK: - Table View Configuration
  // ********************************
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 4
  }
  
  override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    if indexPath.row == 3 {
      return 190
    } else {
      return 50
    }
  }
  
  override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    if indexPath.row == 3 {
      cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, CGRectGetWidth(self.tableView.bounds));
    } else {
      cell.separatorInset = UIEdgeInsetsZero
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
  
  func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
    var textlength = (textView.text as NSString).length + (text as NSString).length - range.length
    if text == "\n" {
      textView.resignFirstResponder()
    }
    return (textlength > 150) ? false : true
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
