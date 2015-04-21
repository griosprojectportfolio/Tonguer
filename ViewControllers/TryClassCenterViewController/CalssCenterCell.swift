//
//  CalssCenterCell.swift
//  Tonguer
//
//  Created by GrepRuby on 17/04/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import UIKit

class CalssCenterCell: BaseTableViewCell {
  
  var imgVw1: UIImageView!
  var imgVw2: UIImageView!
  var vWcell: UIView!
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  func defaultCellContent(){
    
    self.backgroundColor = UIColor.clearColor()
    self.selectionStyle = UITableViewCellSelectionStyle.None
    
    if(isiPhone5orLower){
      imgVw1 = UIImageView(frame: CGRectMake(20,10,(300/2)-30,80))
       self.setImgVw1Properies()
      imgVw2 = UIImageView(frame: CGRectMake(imgVw1.frame.width+40, imgVw1.frame.origin.y,imgVw1.frame.width, imgVw1.frame.height))
      self.setImgVw2Properies()
    }
    
    if(isiPhone6){
      imgVw1 = UIImageView(frame: CGRectMake(20,10,(355/2)-30,80))
      self.setImgVw1Properies()
    imgVw2 = UIImageView(frame: CGRectMake(imgVw1.frame.width+40, imgVw1.frame.origin.y,imgVw1.frame.width, imgVw1.frame.height))
      self.setImgVw2Properies()
    }
    
    if(isiPhone6plus){
      imgVw1 = UIImageView(frame: CGRectMake(20,10,(394/2)-30,80))
      self.setImgVw1Properies()
      imgVw2 = UIImageView(frame: CGRectMake(imgVw1.frame.width+40, imgVw1.frame.origin.y,imgVw1.frame.width, imgVw1.frame.height))
      self.setImgVw2Properies()
    }

  
  }
  
  func setImgVw1Properies(){
    imgVw1.image = UIImage(named: "img2.png")
    imgVw1.userInteractionEnabled = true
    //imgVw1.backgroundColor = UIColor.redColor()
    self.contentView.addSubview(imgVw1)
  }
  
  func setImgVw2Properies(){
    imgVw2.image = UIImage(named: "img2.png")
    imgVw2.userInteractionEnabled = true
    //imgVw2.backgroundColor = UIColor.greenColor()
    self.contentView.addSubview(imgVw2)

  }
  
  
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
