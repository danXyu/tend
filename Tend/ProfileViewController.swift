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
class ProfileViewController : UITableViewController, UICollectionViewDataSource, UICollectionViewDelegate {
  
  @IBOutlet var bgImageView : UIImageView!
  @IBOutlet var profileImageView : UIImageView!
  
  @IBOutlet var profileContainer : UIView!
  @IBOutlet var doneButton : UIButton!
  
  @IBOutlet var nameLabel : UILabel!
  @IBOutlet var locationLabel : UILabel!
  @IBOutlet var locationImageView : UIImageView!
  
  @IBOutlet var followersLabel : UILabel!
  @IBOutlet var followersCount : UILabel!
  @IBOutlet var followingLabel : UILabel!
  @IBOutlet var followingCount : UILabel!
  @IBOutlet var photosLabel : UILabel!
  @IBOutlet var photosCount : UILabel!
  
  @IBOutlet var checkinsLabel : UILabel!
  @IBOutlet var friendsLabel : UILabel!
  
  @IBOutlet var photosContainer : UIView!
  @IBOutlet var photosCollectionLabel : UILabel!
  @IBOutlet var photosCollectionView : UICollectionView!
  @IBOutlet var photosLayout : UICollectionViewFlowLayout!
  
  var photos : [String]!
  
  @IBOutlet var friendsCollectionLabel : UILabel!
  @IBOutlet var friendsCollectionView : UICollectionView!
  @IBOutlet var friendsLayout : UICollectionViewFlowLayout!
  
  var friends : [String]!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    bgImageView.image = UIImage(named: "profile-bg")
    profileImageView.image = UIImage(named: "profile-pic-1")
    profileImageView.layer.cornerRadius = 30
    profileImageView.clipsToBounds = true
    
    nameLabel.textColor = UIColor.whiteColor()
    nameLabel.text = "John Hoylett"
    
    locationLabel.textColor = UIColor.whiteColor()
    locationLabel.text = "London, UK"
    
    locationImageView.image = UIImage(named: "location")
    
    let statsCountFontSize : CGFloat = 16
    let statsLabelFontSize : CGFloat = 12
    let statsCountColor = UIColor.whiteColor()
    let statsLabelColor = UIColor(white: 0.7, alpha: 1.0)
    
    followingCount.textColor = statsCountColor
    followingCount.text = "35"
    
    followingLabel.textColor = statsLabelColor
    followingLabel.text = "FOLLOWING"
    
    followersCount.textColor = statsCountColor
    followersCount.text = "2200"
    
    followersLabel.textColor = statsLabelColor
    followersLabel.text = "FOLLOWERS"
    
    photosCount.textColor = statsCountColor
    photosCount.text = "45"
    
    photosLabel.textColor = statsLabelColor
    photosLabel.text = "PHOTOS"
    
    checkinsLabel.textColor = UIColor.blackColor()
    checkinsLabel.text = "22 Check-ins"
    
    friendsLabel.textColor = UIColor.blackColor()
    friendsLabel.text = "18 Common Friends"
    
    addBlurView()
    
    photosCollectionLabel.textColor = UIColor.blackColor()
    photosCollectionLabel.text = "PHOTOS (31)"
    
    photosContainer.backgroundColor = UIColor(white: 0.92, alpha: 1.0)
    
    photosCollectionView.delegate = self
    photosCollectionView.dataSource = self
    photosCollectionView.backgroundColor = UIColor.clearColor()
    
    photosLayout.itemSize = CGSizeMake(90, 90)
    photosLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
    photosLayout.minimumInteritemSpacing = 5
    photosLayout.minimumLineSpacing = 10
    photosLayout.scrollDirection = .Horizontal
    
    photos = ["photos-1", "photos-2", "photos-3", "photos-4", "photos-5", "photos-6", "photos-7", "photos-8", "photos-9"]
    
    friendsCollectionLabel.textColor = UIColor.blackColor()
    friendsCollectionLabel.text = "FRIENDS (22)"
    
    friendsCollectionView.delegate = self
    friendsCollectionView.dataSource = self
    friendsCollectionView.backgroundColor = UIColor.clearColor()
    
    friendsLayout.itemSize = CGSizeMake(45, 45)
    friendsLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
    friendsLayout.minimumInteritemSpacing = 5
    friendsLayout.minimumLineSpacing = 10
    friendsLayout.scrollDirection = .Horizontal
    
    friends = ["friends-1", "friends-2", "friends-3", "friends-4", "friends-5", "friends-6"]
    
    let doneImage = UIImage(named: "menu")?.imageWithRenderingMode(.AlwaysTemplate)
    doneButton.setImage(doneImage, forState: .Normal)
    doneButton.tintColor = UIColor.whiteColor()
    
  }
  
  override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    
    if indexPath.row == 0{
      return 250
    }else if indexPath.row == 3 {
      return 400
    }else if indexPath.row == 4 {
      return 100
    }else{
      return 44
    }
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    
    if collectionView == photosCollectionView {
      let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! UICollectionViewCell
      
      let imageView = cell.viewWithTag(1) as! UIImageView
      let photo = photos[indexPath.row]
      imageView.image = UIImage(named: photo)
      return cell
    }else{
      
      let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! UICollectionViewCell
      
      let imageView = cell.viewWithTag(1) as! UIImageView
      let friend = friends[indexPath.row]
      imageView.image = UIImage(named: friend)
      imageView.layer.cornerRadius = 20
      return cell
    }
  }
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if collectionView == photosCollectionView {
      return photos.count
    }else{
      return friends.count
    }
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
  
  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return .LightContent
  }
  
  @IBAction func doneTapped(sender: AnyObject?){
    dismissViewControllerAnimated(true, completion: nil)
  }
}