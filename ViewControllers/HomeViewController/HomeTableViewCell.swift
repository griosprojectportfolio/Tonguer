//
//  HomeTableViewCell.swift
//  Tonguer
//
//  Created by GrepRuby on 22/04/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
  
  @IBOutlet var imgVw: UIImageView!
  @IBOutlet  var lblTitle : UILabel!
  @IBOutlet  var lblVaild: UILabel!
  @IBOutlet var lblDate : UILabel!
  @IBOutlet  var vWcell:UIView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    
  }
  
  
//  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
//    super.init(style: style, reuseIdentifier: reuseIdentifier)
//  }
//
//  required init(coder aDecoder: NSCoder) {
//      fatalError("init(coder:) has not been implemented")
//  }
  
  
  func configureCellView(Frame:CGRect){
    cellContentReset()
    imgVw.frame = CGRectMake(Frame.origin.x+10,Frame.origin.y+10,80,80)
    imgVw.layer.borderWidth = 0.5
    imgVw.layer.borderColor = UIColor.lightGrayColor().CGColor
   
    
    vWcell.frame =  CGRectMake(imgVw.frame.origin.x+imgVw.frame.width,imgVw.frame.origin.y,Frame.width-(imgVw.frame.origin.x+imgVw.frame.width+20),imgVw.frame.height)
    vWcell.backgroundColor = UIColor.whiteColor()
    vWcell.layer.borderWidth = 0.5
    vWcell.layer.borderColor = UIColor.lightGrayColor().CGColor
    
    
    lblTitle.frame = CGRectMake(5,3,vWcell.frame.width-10,30)
    lblTitle.textColor = UIColor.blackColor()
    lblTitle.font = lblTitle.font.fontWithSize(15)
    lblTitle.numberOfLines = 0
    lblTitle.lineBreakMode = NSLineBreakMode.ByWordWrapping
    
    
    
    lblVaild.frame = CGRectMake(lblTitle.frame.origin.x,vWcell.frame.height-30,100, 30)
    lblVaild.text = "Valid Days-"
    lblVaild.textColor = UIColor.grayColor()
    lblVaild.font = lblVaild.font.fontWithSize(13)
    
    
    lblDate.frame = CGRectMake(lblVaild.frame.origin.x+lblVaild.frame.width, lblVaild.frame.origin.y,150, 30)
    lblDate.textColor = UIColor.grayColor()
    lblDate.font = lblDate.font.fontWithSize(12)
    
    self.cellContentReset()
    
  }
  
  func defaultCellContent(aParam:NSDictionary!){
    
    print(aParam)
    cellContentReset()
    let url = NSURL(string: aParam.objectForKey("image") as! String)
    imgVw.sd_setImageWithURL(url)
    lblTitle.text = aParam.objectForKey("name") as? String
    lblTitle.sizeToFit()
    var day: NSNumber! = aParam.objectForKey("days") as! NSNumber
    lblDate.text = day.stringValue
  }
  
  func cellContentReset(){
    lblTitle.text = ""
    imgVw.image = nil
    lblDate.text = ""
  }
  
  
   
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
