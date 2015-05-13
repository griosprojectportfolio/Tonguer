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
    
    var width:CGFloat = 320;
    if(isiPhone5orLower) {
      width = 320 - 60;
    } else if (isiPhone6) {
      width = 375 - 60;
    } else if (isiPhone6plus) {
      width = 414 - 60;
    }
    
    var strAnswer = aParam.valueForKey("comment") as NSString
    var rect: CGRect! = strAnswer.boundingRectWithSize(CGSize(width:width-20,height:300), options:NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(12)], context: nil)
    
    print("****\(rect), *** \(width)")

    var arry = self.contentView.subviews
    var vwSub: UIView!
    for vwSub in arry {
      vwSub.removeFromSuperview()
    }
    
    
       vWcell = UIView(frame:CGRectMake(10,0, width, rect.size.height + 4))
       lblAns = UILabel(frame: CGRectMake(5,2, vWcell.frame.size.width - 10, rect.size.height))
      lblBy = UILabel(frame: CGRectMake(width - 180,rect.size.height+5,20, 20))
      lblname = UILabel(frame: CGRectMake(width - 150,rect.size.height+5,150, 20))
    
    
    //vWcell.backgroundColor = UIColor.lightGrayColor()
    vWcell.layer.cornerRadius = 5
    vWcell.layer.borderWidth = 1
    self.contentView.addSubview(vWcell)
    
    lblAns.numberOfLines = 0
    lblAns.text = aParam.valueForKey("comment") as NSString
    lblAns.textColor = UIColor.blackColor()
    lblAns.font = lblAns.font.fontWithSize(12)
    vWcell.addSubview(lblAns)
    
    
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
