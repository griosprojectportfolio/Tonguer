//
//  HomeTableViewCell.swift
//  Tonguer
//
//  Created by GrepRuby on 22/04/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
  
 
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
   
  }
  
  func defaultCellContent(aParam:NSDictionary!,Frame:CGRect){
    
    var arry = self.contentView.subviews
    var vwSub: UIView!
    for vwSub in arry {
      vwSub.removeFromSuperview()
    }
    var imgVw: UIImageView!
    var lblTitle,lblDate,lblVaild: UILabel!
    var vWcell:UIView!
    
    imgVw = UIImageView(frame: CGRectMake(Frame.origin.x+10,Frame.origin.y+10,80,80))
    vWcell = UIView(frame: CGRectMake(imgVw.frame.origin.x+imgVw.frame.width,imgVw.frame.origin.y,Frame.width-(imgVw.frame.origin.x+imgVw.frame.width+20),imgVw.frame.height))
    lblTitle = UILabel(frame: CGRectMake(5,3,vWcell.frame.width-10,30))
    lblVaild = UILabel(frame: CGRectMake(lblTitle.frame.origin.x,vWcell.frame.height-30,100, 30))
    lblDate = UILabel(frame: CGRectMake(lblVaild.frame.origin.x+lblVaild.frame.width, lblVaild.frame.origin.y,150, 30))
    
    let url = NSURL(string: aParam.objectForKey("image") as NSString)
    imgVw.sd_setImageWithURL(url)
    imgVw.layer.borderWidth = 0.5
    imgVw.layer.borderColor = UIColor.lightGrayColor().CGColor
    self.contentView.addSubview(imgVw)
  
    vWcell.backgroundColor = UIColor.whiteColor()
    vWcell.layer.borderWidth = 0.5
    vWcell.layer.borderColor = UIColor.lightGrayColor().CGColor
    self.contentView.addSubview(vWcell)
    
     lblTitle.text = aParam.objectForKey("name") as NSString
    //lblTitle.backgroundColor = UIColor.grayColor()
    lblTitle.textColor = UIColor.blackColor()
    lblTitle.font = lblTitle.font.fontWithSize(15)
    lblTitle.tag = 20
    lblTitle.numberOfLines = 0
    lblTitle.lineBreakMode = NSLineBreakMode.ByWordWrapping
    lblTitle.sizeToFit()
    vWcell.addSubview(lblTitle)
    
//    var lbl = self.contentView.viewWithTag(20) as UILabel
//    lbl.text =  aParam.objectForKey("name") as NSString
    
    //lblTitle.backgroundColor = UIColor.lightGrayColor()
    lblVaild.text = "Valid Days-"
    lblVaild.textColor = UIColor.grayColor()
    lblVaild.font = lblVaild.font.fontWithSize(13)
    vWcell.addSubview(lblVaild)
    
    var day: NSNumber! = aParam.objectForKey("days") as NSNumber
    
    lblDate.text = day.stringValue
    //lblDate.backgroundColor = UIColor.redColor()
    lblDate.textColor = UIColor.grayColor()
    lblDate.font = lblDate.font.fontWithSize(12)
    vWcell.addSubview(lblDate)
  }
  
  
   
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
