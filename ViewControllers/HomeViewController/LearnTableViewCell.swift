//
//  LearnTableViewCell.swift
//  Tonguer
//
//  Created by GrepRuby on 07/05/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import UIKit

class LearnTableViewCell: BaseTableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
  
  
  func defaultCellContent(aParam:NSDictionary!){
    
    var imgVw: UIImageView!
    var lblTitle: UILabel!
    var lblVaild: UILabel!
    var lblDate: UILabel!
    var vWcell:UIView!
    
    if(isiPhone5orLower){
      imgVw = UIImageView(frame: CGRectMake(10, 10, 80, 80))
      vWcell = UIView(frame: CGRectMake(90, 10, 200, 80))
      lblTitle = UILabel(frame: CGRectMake(0,0,190,30))
      lblVaild = UILabel(frame: CGRectMake(lblTitle.frame.origin.x,lblTitle.frame.origin.y+30,100, 30))
      lblDate = UILabel(frame: CGRectMake(80,lblVaild.frame.origin.y,lblVaild.frame.width, 30))
    }else if(isiPhone6){
      imgVw = UIImageView(frame: CGRectMake(10, 10, 80, 80))
      vWcell = UIView(frame: CGRectMake(90, 10, 250, 80))
      lblTitle = UILabel(frame: CGRectMake(5,5,190,30))
      lblVaild = UILabel(frame: CGRectMake(lblTitle.frame.origin.x,lblTitle.frame.origin.y+30,100, 30))
      lblDate = UILabel(frame: CGRectMake(80,lblVaild.frame.origin.y,lblVaild.frame.width, 30))
    }else if(isiPhone6plus){
      imgVw = UIImageView(frame: CGRectMake(10, 10, 80, 80))
      vWcell = UIView(frame: CGRectMake(90, 10, 300, 80))
      lblTitle = UILabel(frame: CGRectMake(5,5,190,30))
      lblVaild = UILabel(frame: CGRectMake(lblTitle.frame.origin.x,lblTitle.frame.origin.y+30,100, 30))
      lblDate = UILabel(frame: CGRectMake(80,lblVaild.frame.origin.y,lblVaild.frame.width, 30))
    }
    
    
    
    let url = NSURL(string: aParam.objectForKey("image") as NSString)
    let data = NSData(contentsOfURL: url!)
    imgVw.image = UIImage(data: data!)
    imgVw.layer.borderWidth = 0.5
    imgVw.layer.borderColor = UIColor.lightGrayColor().CGColor
    self.contentView.addSubview(imgVw)
    
    vWcell.backgroundColor =  UIColor.whiteColor()
    vWcell.layer.borderWidth = 0.5
    vWcell.layer.borderColor = UIColor.lightGrayColor().CGColor
    self.contentView.addSubview(vWcell)
    
    
    
    lblTitle.text = aParam.objectForKey("name") as NSString
    //lblTitle.backgroundColor = UIColor.grayColor()
    lblTitle.textColor = UIColor.blackColor()
    lblTitle.font = lblTitle.font.fontWithSize(15)
    vWcell.addSubview(lblTitle)
    
    
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
