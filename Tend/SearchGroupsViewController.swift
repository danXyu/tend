//
//  File: SearchGroupsViewController.swift
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


// **********************************
// MARK: - SearchGroupsViewController
// **********************************

class SearchGroupsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

  @IBOutlet weak var tableView: UITableView!
  var searchActive: Bool = false
  var data: [PFObject]!
  var filtered: [PFObject]!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    search()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  func search(searchText: String? = nil){
    let query = PFQuery(className: "Groups")
    if (searchText != nil) {
      query.whereKey("name", containsString: searchText)
    }
    query.findObjectsInBackgroundWithBlock { (results, error) -> Void in
      self.data = results as? [PFObject]
      self.tableView.reloadData()
    }
  }
  
  func joinGroup(sender: AnyObject) {
    var button: UIButton = sender as! UIButton
    let group = self.data[button.tag]
    group.addUniqueObject(currentUser, forKey: "members")
    
    MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    group.saveInBackgroundWithBlock() { (success, error) -> Void in
      if error == nil {
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        var alert = UIAlertView(title: "Success", message: "You have successfully been added to the group. Please check your groups", delegate: self, cancelButtonTitle: "Continue")
        alert.show()
        self.dismissViewControllerAnimated(true, completion: nil)
      } else {
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        if let errorString = error!.userInfo?["error"] as? NSString {
          var alert = UIAlertView(title: "Error", message: errorString as String, delegate: self, cancelButtonTitle: "okay")
          alert.show()
        }
      }
    }
  }
  
  func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
    searchActive = true;
  }
  
  func searchBarTextDidEndEditing(searchBar: UISearchBar) {
    searchActive = false;
  }
  
  func searchBarCancelButtonClicked(searchBar: UISearchBar) {
    searchActive = false;
  }
  
  func searchBarSearchButtonClicked(searchBar: UISearchBar) {
    searchActive = false;
  }
  
  func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
    search(searchText: searchText)
  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 80
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if (self.data != nil) {
      return self.data.count
    } else {
      return 1
    }
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    if self.data != nil {
      if self.data.count == 0 {
        let cell = tableView.dequeueReusableCellWithIdentifier("NoGroupsFoundCell", forIndexPath: indexPath) as! UITableViewCell
        return cell
      } else {
        let cell = tableView.dequeueReusableCellWithIdentifier("GroupFoundCell", forIndexPath: indexPath) as! GroupFoundCell
        let group = self.data[indexPath.row]
        cell.groupName!.text = group["name"] as? String
        cell.schoolName!.text = group["school"] as? String
        cell.joinButton.tag = indexPath.row
        cell.joinButton.addTarget(self, action: "joinGroup:", forControlEvents: .TouchUpInside)
        return cell
      }
    } else {
      let cell = tableView.dequeueReusableCellWithIdentifier("NoGroupsFoundCell", forIndexPath: indexPath) as! UITableViewCell
      return cell
    }
  }
}
