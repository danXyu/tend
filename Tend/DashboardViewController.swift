//
//  File: DashboardViewController.swift
//  
//  Application: Tend
//
//  Created by Dan Xiaoyu Yu on 8/8/15.
//  Copyright (c) 2015 Corner Innovations. All rights reserved.
//


import Foundation
import UIKit
import FSCalendar
import Parse


// *******************************
// MARK: - DashboardViewController
// *******************************

class DashboardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  
  // *****************************************
  // MARK: - Variables, Outlets, and Constants
  // *****************************************
  
  private weak var calendar: FSCalendar!
  var groups = [PFObject]()
  
  
  // **********************************
  // MARK: - General View Configuration
  // **********************************
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
  }
  
//  override func viewWillDisappear(animated: Bool) {
//    loadData()
//  }
//  
  
  // ***************************************
  // MARK: - Parse Attendance Data Retrieval
  // ***************************************
//  
//  func loadData(){
//    MBProgressHUD.showHUDAddedTo(self.tableView, animated: true)
//    rooms = [PFObject]()
//    users = [PFUser]()
//    self.tableView.reloadData()
//    
//    let pred = NSPredicate(format: "byUser = %@ OR toUser = %@", currentuser, currentuser)
//    var query = PFQuery(className: "Matches", predicate: pred)
//    query.orderByDescending("updatedAt")
//    query.whereKey("liked", equalTo: true)
//    query.whereKey("likedback", equalTo: true)
//    
//    query.findObjectsInBackgroundWithBlock { (results:[AnyObject]!, error:NSError!) -> Void in
//      if error == nil {
//        self.rooms = results as! [PFObject]
//        
//        self.navigationItem.title = "\(results.count) Match"
//        for room in self.rooms {
//          let user1 = room.objectForKey("byUser") as! PFUser
//          let user2 = room.objectForKey("toUser") as! PFUser
//          if user1.objectId != currentuser.objectId {
//            self.users.append(user1)
//          }
//          if user2.objectId != currentuser.objectId {
//            self.users.append(user2)
//          }
//        }
//        self.tableView.reloadData()
//        MBProgressHUD.hideHUDForView(self.tableView, animated: true)
//      } else {
//        MBProgressHUD.hideHUDForView(self.tableView, animated: true)
//      }
//    }
//  }
  
  
  // ********************************
  // MARK: - Table View Configuration
  // ********************************
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if groups.count > 0 {
      return groups.count
    } else {
      return 1
    }
  }
//  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCellWithIdentifier("NoDateCell", forIndexPath: indexPath) as! UITableViewCell
      return cell
//    } else {
//      let cell = tableView.dequeueReusableCellWithIdentifier("DateCell", forIndexPath: indexPath) as! DateViewCell
//      let targetObject = groups[indexPath.row] as PFObject
//      
//      var userget = PFUser.query()
//      userget.whereKey("objectId", equalTo: targetUser.objectId)
//      userget.findObjectsInBackgroundWithBlock { (objects:[AnyObject]!, error:NSError!) -> Void in
//        if error == nil {
//          if let fUser = objects.last as? PFUser {
//            cell.nameUser.text = fUser.objectForKey("name") as? String
//            if let pica = fUser.objectForKey("dpLarge") as? PFFile {
//              pica.getDataInBackgroundWithBlock({ (data:NSData!, error:NSError!) -> Void in
//                if error == nil {
//                  cell.userdp.image = UIImage(data: data)
//                  cell.userdp.layer.borderColor = colorText.CGColor
//                }
//              })
//            }
//            
//          }
//        }
//      }
//      
//      var getlastmsg = PFQuery(className: "Messages")
//      getlastmsg.whereKey("match", equalTo: targetObject)
//      getlastmsg.orderByDescending("createdAt")
//      getlastmsg.limit = 1
//      getlastmsg.findObjectsInBackgroundWithBlock { (objects:[AnyObject]!, error:NSError!) -> Void in
//        if error == nil {
//          if let msg = objects.last as? PFObject {
//            cell.lastMessage.text = msg.objectForKey("content") as? String
//          }
//          if objects.count == 0 {
//            cell.lastMessage.text = ""
//          }
//        }
//      }
//      return cell
//    }
  }
}
