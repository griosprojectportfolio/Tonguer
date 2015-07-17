//
//  PickupTableViewCell.swift
//  Tonguer
//
//  Created by GrepRuby on 20/04/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import UIKit

class PickupTableViewCell: BaseTableViewCell {
  
  @IBOutlet var imgVw: UIImageView!
  @IBOutlet var vWcell: UIView!
  @IBOutlet  var lblClassName: UILabel!
  @IBOutlet var lblDate: UILabel!
  @IBOutlet  var lblPriz: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  func defaultCellContents(aParam:NSDictionary,frame:CGRect){
    
    
    imgVw.frame = CGRectMake(frame.origin.x+20,frame.origin.y+20,80,80)
    vWcell.frame = CGRectMake(imgVw.frame.origin.x+imgVw.frame.width,20,frame.width-(imgVw.frame.width+40),80)
    self.setContentProperties(aParam)
  }
  
  func setContentProperties(aParam:NSDictionary){
    
    var object:AnyObject! = aParam["image"]
    var strImgUrl: NSString!
    if(object.isKindOfClass(NSDictionary)){
      var img: NSString? = aParam.valueForKey("image")?.valueForKey("url") as? NSString
      
      if((img?.isKindOfClass(NSNull)) != nil){
       strImgUrl = aParam.valueForKey("image")?.valueForKey("url") as String
      }else{
        strImgUrl = ""
      }
    }else if(object.isKindOfClass(NSString)){
      strImgUrl = aParam["image"] as String
    }
    
    if(strImgUrl == ""){
      let url = NSURL(string:"http://www.popular.com.my/images/no_image.gif")
      imgVw.sd_setImageWithURL(url)
    }else{
      let url = NSURL(string: strImgUrl)
      imgVw.sd_setImageWithURL(url)
    }
    //imgVw.backgroundColor = UIColor.redColor()
    imgVw.layer.borderWidth = 0.3
    imgVw.layer.borderColor = UIColor.lightGrayColor().CGColor
    
    
    vWcell.layer.borderWidth = 0.3
    vWcell.layer.borderColor = UIColor.lightGrayColor().CGColor
    vWcell.backgroundColor = UIColor.whiteColor()
    
    
    lblClassName.frame =  CGRectMake(5,0,vWcell.frame.size.width,30)
    lblClassName.text = aParam.objectForKey("name") as NSString
    //lblClassName.backgroundColor = UIColor.blueColor()
    lblClassName.font = lblClassName.font.fontWithSize(13)
    lblClassName.textColor = UIColor.blackColor()
    lblClassName.numberOfLines = 0
    lblClassName.lineBreakMode = NSLineBreakMode.ByWordWrapping
    lblClassName.sizeToFit()
    
    
    lblPriz.frame =  CGRectMake(vWcell.frame.width-50,vWcell.frame.height-30,50,30)
    if((aParam.objectForKey("price")?.integerValue) != nil){
      lblPriz.text =  NSString(format: "%i",(aParam.objectForKey("price")?.integerValue)!)
    }else{
      lblPriz.text = "0.0"
    }
    
    lblPriz.font = lblClassName.font.fontWithSize(12)
    lblPriz.textAlignment = NSTextAlignment.Center
    lblPriz.textColor = UIColor.whiteColor()
    lblPriz.backgroundColor =  UIColor(red: 237.0/255.0, green: 62.0/255.0, blue: 61.0/255.0,alpha:1.0)
    

    var str: NSString = "Valid_days: "
    var strDays: NSString = NSString(format: "%i",(aParam.objectForKey("valid_days")?.integerValue)!)
    var strCommon = str+strDays

    lblDate.frame =  CGRectMake(10,vWcell.frame.height-30,lblPriz.frame.origin.x-10,30)
    lblDate.text = strCommon //NSString(format: "%i",(aParam.objectForKey("valid_days")?.integerValue)!)    //aParam.objectForKey("valid_days") as NSString
    lblDate.font = lblDate.font.fontWithSize(12)
    lblDate.textColor = UIColor.grayColor()
    //lblDate.backgroundColor = UIColor.redColor()
    

  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
}
