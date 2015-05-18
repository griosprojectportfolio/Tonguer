//
//  SettingTableViewCell.swift
//  Tonguer
//
//  Created by GrepRuby on 21/04/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import UIKit

class SettingTableViewCell:BaseTableViewCell {
  
  var lbltitle: UILabel!
  var vWCell: UIView!
  var swtRemind: UISwitch!
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  func defaultUICellContent(name: NSString , index: NSInteger){
    
    var arry = self.contentView.subviews
    var vwSub: UIView!
    for vwSub in arry {
      vwSub.removeFromSuperview()
    }
    
    if(isiPhone5orLower){
      vWCell = UIView(frame: CGRectMake(20, 10,320-50,60))
      setcellContentProperties(name,index: index)
    }
    if(isiPhone6){
      vWCell = UIView(frame: CGRectMake(20, 10,375-50,60))
      setcellContentProperties(name,index: index)
    }
    if(isiPhone6plus){
      vWCell = UIView(frame: CGRectMake(20, 10,414-50,60))
     setcellContentProperties(name,index: index)
    }
  }
  
  func setcellContentProperties(name:NSString , index: NSInteger){
    vWCell.layer.borderWidth = 0.5
    vWCell.layer.borderColor = UIColor.lightGrayColor().CGColor
    self.contentView.addSubview(vWCell)
    
    lbltitle = UILabel(frame: CGRectMake(5,5,200,50))
    lbltitle.text = name
    lbltitle.font = lbltitle.font.fontWithSize(15)
    //lbltitle.backgroundColor = UIColor.redColor()
    vWCell.addSubview(lbltitle)
    
    if(index == 2){
       swtRemind = UISwitch(frame: CGRectMake(vWCell.frame.width - 40,25, 30,30))
      self.contentView.addSubview(swtRemind)
    }
    
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
