//
//  File: GroupViewCell.swift
//  
//  Application: Tend
//
//  Created by Donna Yu on 8/6/15.
//  Copyright (c) 2015 Donna Yu. All rights reserved.
//


import Foundation
import UIKit
import Parse


// *********************
// MARK: - GroupViewCell
// *********************

class GroupViewCell: UITableViewCell {

  
  // *****************************************
  // MARK: - Variables, Outlets, and Constants
  // *****************************************
  
  @IBOutlet weak var groupName: UILabel!
  @IBOutlet weak var numMembers: UILabel!
  @IBOutlet weak var manageButton: UIButton!
  @IBOutlet weak var checkinButton: UIButton!
  
  
  // *****************************************
  // MARK: - Standard Table Cell Configuration
  // *****************************************
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
}
