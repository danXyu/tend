//
//  File: GroupsViewController.swift
//  
//  Application: Tend
//
//  Created by Donna Yu on 8/6/15.
//  Copyright (c) 2015 Donna Yu. All rights reserved.
//


import Foundation
import UIKit
//import MBProgressHUD
import Parse
import ParseFacebookUtilsV4


// ****************************
// MARK: - GroupsViewController
// ****************************

class GroupsViewController: UITableViewController {
  
  
  // *****************************************
  // MARK: - Variables, Outlets, and Constants
  // *****************************************
  
  var data: [PFObject]!
  var filtered: [PFObject]!
  
  
  // *************************************
  // MARK: - View Controller Configuration
  // *************************************
  
  override func viewDidLoad() {
    super.viewDidLoad()
    loadGroups()
  }


  // **************************
  // MARK: - Parse Data Methods
  // **************************
  
  func loadGroups(){
    let query = PFQuery(className: "Groups")

    query.findObjectsInBackgroundWithBlock { (results, error) -> Void in
      self.data = results as? [PFObject]
      self.tableView.reloadData()
    }
  }
  
  
  // ******************************
  // MARK: - Table View Data Source
  // ******************************

  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 80
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if (self.data != nil) {
      return self.data.count
    } else {
      return 1
    }
  }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    if self.data != nil {
      if self.data.count == 0 {
        let cell = tableView.dequeueReusableCellWithIdentifier("NoGroupsCell", forIndexPath: indexPath) as! UITableViewCell
        return cell
      } else {
        let cell = tableView.dequeueReusableCellWithIdentifier("GroupCell", forIndexPath: indexPath) as! GroupViewCell
        let group = self.data[indexPath.row]
  //      if let admins = group["admins"] as? NSArray {
  //        if admins.containsObject(currentUser) {
  //          cell.
  //        }
  //      }
        cell.groupName!.text = group["name"] as? String
        cell.numMembers!.text = "10"
        return cell
      }
    } else {
      let cell = tableView.dequeueReusableCellWithIdentifier("NoGroupsCell", forIndexPath: indexPath) as! UITableViewCell
      return cell
    }
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
