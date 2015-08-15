//
//  File: EditProfileViewController.swift
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


// *********************************
// MARK: - EditProfileViewController
// *********************************

class EditProfileViewController: UITableViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  @IBOutlet var profileContainer: UIView!
  @IBOutlet var profileImageView: UIImageView!
  @IBOutlet var bgImageView: UIImageView!
  
  @IBOutlet var nameLabel: UILabel!
  @IBOutlet var nameTextField: UITextField!
  @IBOutlet var emailLabel: UILabel!
  @IBOutlet var emailFieldLabel: UILabel!
  @IBOutlet var schoolLabel: UILabel!
  @IBOutlet var schoolTextField: UITextField!
  @IBOutlet var yearLabel: UILabel!
  @IBOutlet var yearTextField: UITextField!
  
  var buttonclicked: Int!
  var profileImageChanged: Bool = false
  

  // ************************************
  // MARK: - Necessary View Configuration
  // ************************************
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.separatorColor = UIColor(white: 0.75, alpha: 1.0)
    bgImageView.image = UIImage(named: "ProfileBackground")
    profileImageView.image = UIImage(named: "ProfilePicPlaceholder")
    profileImageView.layer.cornerRadius = 35
    profileImageView.clipsToBounds = true
  }
  
  override func viewDidAppear(animated: Bool) {
    if let pic = currentUser.objectForKey("proPic") as? PFFile {
      getImage("proPic", profileImageView)
    }
    nameTextField.text = currentUser.objectForKey("fullName") as? String
    emailFieldLabel.text = currentUser.email
    schoolTextField.text = currentUser.objectForKey("school") as? String
    yearTextField.text = currentUser.objectForKey("year") as? String
  }
  
  @IBAction func profilePicTapped(sender: AnyObject) {
    var mediapicker = UIImagePickerController()
    mediapicker.allowsEditing = true
    mediapicker.delegate = self
    mediapicker.sourceType = .PhotoLibrary
    self.presentViewController(mediapicker, animated: true, completion: nil)
  }
  
  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
    var pickedImg = info[UIImagePickerControllerEditedImage] as! UIImage
    profileImageChanged = true
    profileImageView.image = pickedImg
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  
  // ********************************
  // MARK: - Parse User Configuration
  // ********************************
  
  @IBAction func cancelTapped(sender: AnyObject) {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  @IBAction func saveTapped(sender: AnyObject) {
    MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    if nameTextField.text.isEmpty || schoolTextField.text.isEmpty || yearTextField.text.isEmpty {
      MBProgressHUD.hideHUDForView(self.view, animated: true)
      var alert = UIAlertView(title: "Form Field Error", message: "Name, email, or school name cannot be Empty", delegate: self, cancelButtonTitle: "Try Again")
      alert.show()
    } else {
      currentUser["fullName"] = nameTextField.text
      currentUser["school"] = schoolTextField.text
      currentUser["year"] = yearTextField.text
      
      if profileImageChanged == true {
        var imageSmall = scaleImage(self.profileImageView.image!, 60)
        var dataS = UIImageJPEGRepresentation(imageSmall, 0.7)
        currentUser["proPic"] = PFFile(name: "image.jpg", data: dataS)
        currentUser.saveInBackground()
      }
      
      currentUser.saveInBackgroundWithBlock() { (done, error) -> Void in
        if error == nil {
          self.dismissViewControllerAnimated(true, completion: nil)
          MBProgressHUD.hideHUDForView(self.view, animated: true)
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
    return 5
  }
  
  override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    if indexPath.row == 0 {
      return 150
    } else {
      return 60
    }
  }
  
  override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    if indexPath.row == 5 {
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