//
//  File: Configuration.swift
//
//  Application: Tend
//
//  Created by Dan Xiaoyu Yu on 8/6/15.
//  Copyright (c) 2015 Corner Innovations. All rights reserved.
//

import Foundation
import UIKit
import Parse
import FacebookSDK

// Parse Settings
var parseAppId = "BztXTqm8HNGsiwFoy1aF7uPc1DGmBvXm6uB8L14r"
var parseAppSecret = "xezxP5xId6DcUWTHM9twdXgH4XXO6Kect45qBzeb"

// Device Settings
let Device = UIDevice.currentDevice()
let phoneWidth = UIScreen.mainScreen().bounds.width
let phoneHeight = UIScreen.mainScreen().bounds.height
let mainBoard = UIStoryboard(name: "Main", bundle: nil)
var navbarHeight:CGFloat = 64
var tabbarHeight:CGFloat = 49

// Version Settings
let iosVersion = NSString(string: Device.systemVersion).doubleValue
let iOS8 = iosVersion >= 8
let iOS7 = iosVersion >= 7 && iosVersion < 8

// Current User Settings
let userPF = PFUser()
var currentUser: PFUser = PFUser.currentUser()!
var hasSignedUp = false

/* Helper Function: scaleImage(image, newSize) */
func scaleImage(image:UIImage, newSize:CGFloat) -> UIImage {
  UIGraphicsBeginImageContextWithOptions(CGSize(width: newSize, height: newSize), false, 0.0)
  image.drawInRect(CGRectMake(0, 0, newSize, newSize))
  var newImage = UIGraphicsGetImageFromCurrentImageContext()
  return newImage
}

/* Helper Function: getImage(forKey, imgView) */
func getImage(forKey:String, imgView:UIImageView) {
  if let pic = currentUser.objectForKey(forKey) as? PFFile {
    pic.getDataInBackgroundWithBlock({ (data:NSData?, error:NSError?) -> Void in
      if error == nil {
        imgView.image = UIImage(data: data!)
      }
    })
  }
}