//
//  PickupTableViewCell.swift
//  Tonguer
//
//  Created by GrepRuby on 20/04/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import UIKit

class PickupTableViewCell: BaseTableViewCell {
  
  var imgVw: UIImageView!
  var vWcell: UIView!
  var lblData: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  func defaultCellContents(){
    
    if(isiPhone5orLower){
      imgVw = UIImageView(frame: CGRectMake(320-120, 5,80,80))
      vWcell = UIView(frame: CGRectMake(40, 5,imgVw.frame.origin.x-40, 80))
      self.setContentProperties()
    }
    if(isiPhone6){
      imgVw = UIImageView(frame: CGRectMake(375-120, 5,80,80))
       vWcell = UIView(frame: CGRectMake(40, 5,imgVw.frame.origin.x-40, 80))
      self.setContentProperties()
    }
    if(isiPhone6plus){
      imgVw = UIImageView(frame: CGRectMake(414-120, 5,80,80))
      vWcell = UIView(frame: CGRectMake(40, 5,imgVw.frame.origin.x-40, 80))
      self.setContentProperties()
    }
  }
  
  func setContentProperties(){
    imgVw.image = UIImage(named: "img2.png")
    //imgVw.backgroundColor = UIColor.redColor()
    imgVw.layer.borderWidth = 0.5
    imgVw.layer.borderColor = UIColor.lightGrayColor().CGColor
    self.contentView.addSubview(imgVw)
    
    vWcell.layer.borderWidth = 0.5
    vWcell.layer.borderColor = UIColor.lightGrayColor().CGColor
    self.contentView.addSubview(vWcell)
    
    lblData = UILabel(frame: CGRectMake(5, 2, vWcell.frame.width-20,40))
    lblData.text = "kjhkjhkjhkjhkjhjkhkjh"
    lblData.font = lblData.font.fontWithSize(12)
    lblData.textColor = UIColor.grayColor()
    vWcell.addSubview(lblData)
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
