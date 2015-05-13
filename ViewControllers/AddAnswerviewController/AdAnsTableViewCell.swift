//
//  AdAnsTableViewCell.swift
//  Tonguer
//
//  Created by GrepRuby on 07/04/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import UIKit

class AdAnsTableViewCell: BaseTableViewCell {
  
  var vWcell :UIView!
  var lblAns :UILabel!
  var lblBy :UILabel!
  var lblname :UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
  
  func defaultUIDesign(aParam:NSDictionary){
    
    
    if(isiPhone5orLower){
      lblAns = UILabel(frame: CGRectMake(5,0,320-20,30))
      lblBy = UILabel(frame: CGRectMake(200,40,20, 20))
      lblname = UILabel(frame: CGRectMake(225,40,150, 20))
    }
    if(isiPhone6){
       lblAns = UILabel(frame: CGRectMake(20,0,375-80,30))
       lblBy = UILabel(frame: CGRectMake(250,40,100, 20))
      lblname = UILabel(frame: CGRectMake(275,40,50, 20))
    }
    if(isiPhone6plus){
       lblAns = UILabel(frame: CGRectMake(5,0,414-20,30))
      lblBy = UILabel(frame: CGRectMake(300,40,20, 20))
      lblname = UILabel(frame: CGRectMake(320,40,150, 20))
    }
    
    lblAns.backgroundColor = UIColor.lightGrayColor()
    lblAns.layer.cornerRadius = 5
    lblAns.layer.borderWidth = 1
    lblAns.numberOfLines = 0
    lblAns.text = aParam.valueForKey("comment") as NSString
    lblAns.textColor = UIColor.blackColor()
    lblAns.font = lblAns.font.fontWithSize(12)
    self.contentView.addSubview(lblAns)
    
    
    lblBy.text = "By-"
    //lblBy.backgroundColor = UIColor.redColor()
    lblBy.textColor = UIColor.grayColor()
    lblBy.font = lblBy.font.fontWithSize(10)
    self.contentView.addSubview(lblBy)
    
    
    lblname.text = aParam.valueForKey("by") as NSString
    lblname.backgroundColor = UIColor(red: 237.0/255.0, green: 62.0/255.0, blue: 61.0/255.0,alpha:1.0)
    lblname.textColor = UIColor.blackColor()
    lblname.textAlignment = NSTextAlignment.Center
    lblname.font = lblBy.font.fontWithSize(10)
    self.contentView.addSubview(lblname)

    
    
  }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
