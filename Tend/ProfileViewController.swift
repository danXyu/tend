//
//  File: ProfileViewController.swift
//
//  Application: Tend
//
//  Created by Dan Xiaoyu Yu on 8/8/15.
//  Copyright (c) 2015 Corner Innovations. All rights reserved.
//


import Foundation
import UIKit


/* View Controller: ProfileViewController
 * --------------------------------------
 *
 */
class ProfileViewController : UITableViewController, UITextFieldDelegate {
  
  @IBOutlet var profileImageView  : UIImageView!
  @IBOutlet var editBgButton      : UIButton!
  @IBOutlet var editAvatarButton  : UIButton!
  
  @IBOutlet var bgImageView : UIImageView!
  @IBOutlet var profileContainer : UIView!
  @IBOutlet var doneButton : UIButton!
  
  @IBOutlet var nameLabel : UILabel!
  @IBOutlet var nameTextField : UITextField!
  @IBOutlet var locationLabel : UILabel!
  @IBOutlet var locationTextField : UITextField!
  @IBOutlet var emailLabel : UILabel!
  @IBOutlet var emailTextField : UITextField!
  @IBOutlet var passwordLabel : UILabel!
  @IBOutlet var passwordTextField : UITextField!
  
  @IBOutlet var pushLabel : UILabel!
  @IBOutlet var pushSwitch : UISwitch!
  @IBOutlet var facebookLabel : UILabel!
  @IBOutlet var facebookImageView : UIImageView!
  @IBOutlet var facebookButton : UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.separatorColor = UIColor(white: 0.92, alpha: 1.0)
    
    bgImageView.image = UIImage(named: "profile-bg")
    profileImageView.image = UIImage(named: "profile-pic-2")
    profileImageView.layer.cornerRadius = 30
    profileImageView.clipsToBounds = true
    
    themeButtonWithText(editAvatarButton, text: "EDIT AVATAR")
    themeButtonWithText(editBgButton, text: "EDIT BACKGROUND")
    
    themeLabelWithText(nameLabel, text: "NAME")
    themeTextFieldWithText(nameTextField, text: "Rachel Christofsson")
    
    themeLabelWithText(locationLabel, text: "LOCATION")
    themeTextFieldWithText(locationTextField, text: "London, UK")
    
    themeLabelWithText(emailLabel, text: "EMAIL")
    themeTextFieldWithText(emailTextField, text: "rachel@mail.com")
    
    themeLabelWithText(passwordLabel, text: "PASSWORD")
    themeTextFieldWithText(passwordTextField, text: "qowqoqooq")
    passwordTextField.secureTextEntry = true
    
    themeLabelWithText(pushLabel, text: "PUSH NOTIFICATIONS")
    themeLabelWithText(facebookLabel, text: "LOGGED IN WITH FACEBOOK")
    
    themeButtonWithText(facebookButton, text: "LOGOUT")
    facebookButton.tintColor = UIColor(red: 0.19, green: 0.38, blue: 0.73, alpha: 1.0)
    
    facebookImageView.image = UIImage(named: "fb")
    
    let doneImage = UIImage(named: "menu")?.imageWithRenderingMode(.AlwaysTemplate)
    doneButton.setImage(doneImage, forState: .Normal)
    doneButton.tintColor = UIColor.whiteColor()
    
    addBlurView()
  }
  
  override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    
    if indexPath.row == 0{
      return 150
    }else if indexPath.row == 5{
      return 15
    }else{
      return 44
    }
  }
  
  
  func themeButtonWithText(button: UIButton, text:String){
    let background = UIImage(named: "border-button")?.resizableImageWithCapInsets(UIEdgeInsetsMake(10, 10, 10, 10))
    let backgroundTemplate = background!.imageWithRenderingMode(.AlwaysTemplate)
    
    button.setBackgroundImage(backgroundTemplate, forState: .Normal)
    button.setTitle(text, forState: .Normal)
    button.tintColor = UIColor.whiteColor()
  }
  
  func themeTextFieldWithText(textField:UITextField, text: String){
    let largeFontSize : CGFloat = 17
    textField.text = text
    textField.delegate = self
  }
  
  func themeLabelWithText(label: UILabel, text: String){
    let fontSize : CGFloat = 10
    label.text = text
  }
  
  func addBlurView(){
    var blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
    var blurView = UIVisualEffectView(effect: blurEffect)
    blurView.frame = CGRectMake(0, 0, 600, 100)
    
    blurView.setTranslatesAutoresizingMaskIntoConstraints(false)
    profileContainer.insertSubview(blurView, aboveSubview: bgImageView)
    
    let topConstraint = NSLayoutConstraint(item: profileContainer, attribute: .Top, relatedBy: .Equal, toItem: blurView, attribute: .Top, multiplier: 1.0, constant: 0.0)
    
    let bottomConstraint = NSLayoutConstraint(item: profileContainer, attribute: .Bottom, relatedBy: .Equal, toItem: blurView, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
    
    let leftConstraint = NSLayoutConstraint(item: profileContainer, attribute: .Left, relatedBy: .Equal, toItem: blurView, attribute: .Left, multiplier: 1.0, constant: 0.0)
    
    let rightConstraint = NSLayoutConstraint(item: profileContainer, attribute: .Right, relatedBy: .Equal, toItem: blurView, attribute: .Right, multiplier: 1.0, constant: 0.0)
    
    self.profileContainer.addConstraints([topConstraint, rightConstraint, leftConstraint, bottomConstraint])
  }
  
  @IBAction func doneTapped(sender: AnyObject?){
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return .LightContent
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    self.registerForKeyboardNotifications()
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    self.deregisterFromKeyboardNotifications()
  }
  
  func registerForKeyboardNotifications ()-> Void   {
    
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
  
  override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    
    cell.separatorInset = UIEdgeInsetsZero
    cell.layoutMargins = UIEdgeInsetsZero
    cell.selectionStyle = .None
  }
  
  override func viewDidLayoutSubviews() {
    tableView.separatorInset = UIEdgeInsetsZero
    tableView.layoutMargins = UIEdgeInsetsZero
  }
}
