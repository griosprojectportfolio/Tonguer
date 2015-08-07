//
//  ClassTableViewCell.swift
//  Tonguer
//
//  Created by GrepRuby on 27/04/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import UIKit

class ClassTableViewCell: BaseTableViewCell {
  
  @IBOutlet  var imgVw: UIImageView!
  @IBOutlet  var vWcell: UIView!
  @IBOutlet  var lblClassName: UILabel!
  @IBOutlet var lblDate: UILabel!
  @IBOutlet var lblPriz: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  func defaultCellContents(aParam:NSDictionary,frame:CGRect){
    
//    var arry = self.contentView.subviews
//    var vwSub: UIView!
//    for vwSub in arry {
//      vwSub.removeFromSuperview()
//    }
    
    imgVw.frame =  CGRectMake(frame.origin.x+20,20,80,80)
    vWcell.frame =  CGRectMake(imgVw.frame.origin.x+imgVw.frame.width,20,frame.width-(imgVw.frame.origin.x+imgVw.frame.width+20),80)
    lblClassName.frame = CGRectMake(10,0, vWcell.frame.width-20,30)
    lblPriz.frame =  CGRectMake(vWcell.frame.width-50,vWcell.frame.height-30,50,30)
    lblDate.frame = CGRectMake(10,vWcell.frame.height-30,lblPriz.frame.origin.x-10,30)
    self.setContentProperties(aParam)
    
  }
  
  func setContentProperties(aParam:NSDictionary){
    
    let url = NSURL(string: aParam.objectForKey("image") as! String)
    imgVw.sd_setImageWithURL(url, placeholderImage: UIImage(named: "vdoDefault.png"))

    //imgVw.image = UIImage(named: aParam.objectForKey("image") as NSString)
    //imgVw.backgroundColor = UIColor.redColor()
    imgVw.layer.borderWidth = 0.3
    imgVw.layer.borderColor = UIColor.lightGrayColor().CGColor
    self.contentView.addSubview(imgVw)
    
    vWcell.layer.borderWidth = 0.3
    vWcell.layer.borderColor = UIColor.lightGrayColor().CGColor
    
    lblClassName.text = aParam.objectForKey("name") as? String
    lblClassName.font = lblClassName.font.fontWithSize(13)
    lblClassName.textColor = UIColor.blackColor()
    lblClassName.numberOfLines = 0
    lblClassName.lineBreakMode = NSLineBreakMode.ByWordWrapping
    lblClassName.sizeToFit()
    
    lblPriz.text = aParam.objectForKey("price") as! NSString as String
    lblPriz.font = lblClassName.font.fontWithSize(12)
    lblPriz.textAlignment = NSTextAlignment.Center
    lblPriz.textColor = UIColor.whiteColor()
    lblPriz.backgroundColor =  UIColor(red: 237.0/255.0, green: 62.0/255.0, blue: 61.0/255.0,alpha:1.0)
    
    var strValid: NSString! = "Valid to "
    var strDays: NSString! = aParam.objectForKey("valid_days") as! NSString
    lblDate.text =  "\(strValid)\(strDays) Days"
    lblDate.font = lblDate.font.fontWithSize(12)
    lblDate.textColor = UIColor.grayColor()
    //lblDate.backgroundColor = UIColor.redColor()
   
    
  }

  
  
}
