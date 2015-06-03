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
  var lblClassName: UILabel!
  var lblDate: UILabel!
  var lblPriz: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  func defaultCellContents(aParam:NSDictionary){
    
    var arry = self.contentView.subviews
    var vwSub: UIView!
    for vwSub in arry {
      vwSub.removeFromSuperview()
    }

    
    if(isiPhone5orLower){
      imgVw = UIImageView(frame: CGRectMake(320-120, 5,80,80))
      vWcell = UIView(frame: CGRectMake(40, 5,imgVw.frame.origin.x-40, 80))
      self.setContentProperties(aParam)
    }
    if(isiPhone6){
      imgVw = UIImageView(frame: CGRectMake(375-120, 5,80,80))
       vWcell = UIView(frame: CGRectMake(40, 5,imgVw.frame.origin.x-40, 80))
      self.setContentProperties(aParam)
    }
    if(isiPhone6plus){
      imgVw = UIImageView(frame: CGRectMake(414-120, 5,80,80))
      vWcell = UIView(frame: CGRectMake(40, 5,imgVw.frame.origin.x-40, 80))
      self.setContentProperties(aParam)
    }
  }
  
  func setContentProperties(aParam:NSDictionary){
    
    let strImgUrl = aParam["image"] as? String
    
    if(strImgUrl == nil){
      let url = NSURL(string:"http://www.popular.com.my/images/no_image.gif")
      imgVw.sd_setImageWithURL(url)
    }else{
      let url = NSURL(string: aParam.objectForKey("image") as NSString)
      imgVw.sd_setImageWithURL(url)
    }
    //imgVw.backgroundColor = UIColor.redColor()
    imgVw.layer.borderWidth = 0.3
    imgVw.layer.borderColor = UIColor.lightGrayColor().CGColor
    self.contentView.addSubview(imgVw)
    
    vWcell.layer.borderWidth = 0.3
    vWcell.layer.borderColor = UIColor.lightGrayColor().CGColor
    vWcell.backgroundColor = UIColor.whiteColor()
    self.contentView.addSubview(vWcell)
    
    lblClassName = UILabel(frame: CGRectMake(10,0, vWcell.frame.width-20,30))
    lblClassName.text = aParam.objectForKey("name") as NSString
    lblClassName.font = lblClassName.font.fontWithSize(15)
    lblClassName.textColor = UIColor.blackColor()
    vWcell.addSubview(lblClassName)
    
    
    
    lblPriz = UILabel(frame: CGRectMake(vWcell.frame.width-50,vWcell.frame.height-30,50,30))
    if((aParam.objectForKey("price")?.integerValue) != nil){
      lblPriz.text =  NSString(format: "%i",(aParam.objectForKey("price")?.integerValue)!)
    }else{
      lblPriz.text = "0.0"
    }
    
    lblPriz.font = lblClassName.font.fontWithSize(12)
    lblPriz.textAlignment = NSTextAlignment.Center
    lblPriz.textColor = UIColor.whiteColor()
    lblPriz.backgroundColor =  UIColor(red: 237.0/255.0, green: 62.0/255.0, blue: 61.0/255.0,alpha:1.0)
    vWcell.addSubview(lblPriz)
    
    lblDate = UILabel(frame: CGRectMake(10,vWcell.frame.height-30,lblPriz.frame.origin.x-10,30))
    lblDate.text = NSString(format: "%i",(aParam.objectForKey("valid_days")?.integerValue)!)    //aParam.objectForKey("valid_days") as NSString
    lblDate.font = lblDate.font.fontWithSize(12)
    lblDate.textColor = UIColor.grayColor()
    //lblDate.backgroundColor = UIColor.redColor()
    vWcell.addSubview(lblDate)

  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
}
