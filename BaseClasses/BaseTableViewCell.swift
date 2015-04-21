//
//  BaseTableViewCell.swift
//  Tonguer
//
//  Created by GrepRuby on 20/04/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import UIKit

class BaseTableViewCell: UITableViewCell {
  
  let isiPhone5orLower    =   UIScreen.mainScreen().bounds.size.width == 320
  let isiPhone6           =   UIScreen.mainScreen().bounds.size.width == 375
  let isiPhone6plus       =   UIScreen.mainScreen().bounds.size.width == 414  
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
