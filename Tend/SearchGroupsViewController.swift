//
//  File: SearchGroupsViewController.swift
//  
//  Application: Tend
//
//  Created by Dan Xiaoyu Yu on 8/9/15.
//  Copyright (c) 2015 Corner Innovations. All rights reserved.
//


import Foundation
import UIKit
import Parse


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
    if(searchText != nil){
      query.whereKey("name", containsString: searchText)
    }
    query.findObjectsInBackgroundWithBlock { (results, error) -> Void in
      self.data = results as? [PFObject]
      self.tableView.reloadData()
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
    return 150
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if (self.data != nil) {
      return self.data.count
    } else {
      return 0
    }
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("GroupFoundCell", forIndexPath: indexPath) as! GroupViewCell
    let group = self.data[indexPath.row]
    cell.groupName!.text = group["name"] as? String
    cell.groupDescription!.text = group["description"] as? String
    var numMembers = group["countMembers"] as? String
    cell.groupMembers!.text = "\(numMembers) Members"
    return cell
  }

}
