//
//  File: DateViewCell.swift
//
//  Application: Tend
//
//  Created by Dan Xiaoyu Yu on 8/9/15.
//  Copyright (c) 2015 Corner Innovations. All rights reserved.
//


import Foundation
import UIKit
import Parse


// ********************
// MARK: - DateViewCell
// ********************

class DateViewCell: UITableViewCell {
  
  
  // *****************************************
  // MARK: - Variables, Outlets, and Constants
  // *****************************************
  
  @IBOutlet weak var groupName: UILabel!
  
  
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
