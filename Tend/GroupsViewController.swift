//
//  File: GroupsViewController.swift
//  
//  Application: Tend
//
//  Created by Dan Xiaoyu Yu on 8/8/15.
//  Copyright (c) 2015 Corner Innovations. All rights reserved.
//


import Foundation
import UIKit
import MBProgressHUD
import Parse
import ParseFacebookUtilsV4


// ****************************
// MARK: - GroupsViewController
// ****************************

class GroupsViewController: UITableViewController {
  
  
  // *****************************************
  // MARK: - Variables, Outlets, and Constants
  // *****************************************
  
  var groups = [PFObject]()
  
  
  // *************************************
  // MARK: - View Controller Configuration
  // *************************************
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  override func viewWillDisappear(animated: Bool) {
//    loadGroups()
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "displayPushMessage:", name: "displayMessage", object: nil)
  }
  
  override func viewDidDisappear(animated: Bool) {
    super.viewDidDisappear(animated)
    NSNotificationCenter.defaultCenter().removeObserver(self, name: "displayMessage", object: nil)
  }


  // **************************
  // MARK: - Parse Data Methods
  // **************************
//  
//  func loadGroups(){
//    MBProgressHUD.showHUDAddedTo(self.tableView, animated: true)
//    groups = [PFObject]()
//    
//    self.tableView.reloadData()
//    
//    let pred = NSPredicate(format: "byUser = %@ OR toUser = %@", currentUser, currentUser)
//    
//    var query = PFQuery(className: "Matches", predicate: pred)
//    query.orderByDescending("updatedAt")
//    query.whereKey("liked", equalTo: true)
//    query.whereKey("likedback", equalTo: true)
//    
//    query.findObjectsInBackgroundWithBlock { (results:[AnyObject]!, error:NSError!) -> Void in
//      if error == nil {
//        self.groups = results as! [PFObject]
//        
//        self.navigationItem.title = "\(results.count) Match"
//        for room in self.groups {
//          let user1 = room.objectForKey("byUser") as! PFUser
//          let user2 = room.objectForKey("toUser") as! PFUser
//          
//          if user1.objectId != currentuser.objectId {
//            self.users.append(user1)
//          }
//          
//          if user2.objectId != currentuser.objectId {
//            self.users.append(user2)
//          }
//        }
//        
//        self.tableView.reloadData()
//        
//        MBProgressHUD.hideHUDForView(self.tableView, animated: true)
//      } else {
//        MBProgressHUD.hideHUDForView(self.tableView, animated: true)
//      }
//    }
//  }
//  
//  
//  // ******************************
//  // MARK: - Table View Data Source
//  // ******************************

  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if groups.count > 0 {
      return groups.count
    } else {
      return 1
    }
  }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("NoGroupsCell", forIndexPath: indexPath) as! UITableViewCell
    return cell
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
