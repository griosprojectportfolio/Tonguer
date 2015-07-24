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
    
    var strAnswer = aParam.valueForKey("comment") as! NSString

    var arry = self.contentView.subviews
    var vwSub: UIView!
    for vwSub in arry {
      vwSub.removeFromSuperview()
    }
    
    // lblBy = UILabel(frame: CGRectMake(width - 180,rect.size.height+5,20, 20))
    // lblname = UILabel(frame: CGRectMake(width - 150,rect.size.height+5,150, 20))
    
    
    var strName: NSString! = aParam.valueForKey("by") as! NSString
    var strComment: NSString! = aParam.valueForKey("comment")as! NSString
    
    var stringSize = strComment.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())

    lblAns = UILabel()
    lblAns.numberOfLines = 0
    lblAns.font = lblAns.font.fontWithSize(11)

//
//    var attrs = [NSFontAttributeName : UIFont.boldSystemFontOfSize(12)]
//     var boldString = NSMutableAttributedString(string:strfist, attributes:attrs)
//    boldString.beginEditing()
//    boldString.addAttribute(NSForegroundColorAttributeName, value: UIColor.darkGrayColor(), range: NSRange(location:0,length:boldString.length))
    var rect: CGRect! = stringSize.boundingRectWithSize(CGSize(width: width-10,height:300), options:NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName:lblAns.font], context: nil)
    print("****\(rect), *** \(width)")

    vWcell = UIView(frame:CGRectMake(40,5, width, rect.size.height + 20))
    lblAns.frame = CGRectMake(5,10, vWcell.frame.size.width-10, rect.size.height)
    vWcell.addSubview(lblAns)

    // var normalString = NSMutableAttributedString(string:strComment, attributes:attrs)
    // normalString.addAttribute(NSForegroundColorAttributeName, value: UIColor.lightGrayColor(), range: NSRange(location:0,length:normalString.length))

    // boldString.appendAttributedString(normalString)
    lblAns.text = stringSize//boldString

    //vWcell.backgroundColor = UIColor.lightGrayColor()
    vWcell.layer.cornerRadius = 2
    vWcell.layer.borderWidth = 0.5
    vWcell.layer.borderColor = UIColor.lightGrayColor().CGColor
    self.contentView.addSubview(vWcell)
    

    
    
//    lblBy.text = "By-"
//    //lblBy.backgroundColor = UIColor.redColor()
//    lblBy.textColor = UIColor.grayColor()
//    lblBy.font = lblBy.font.fontWithSize(10)
//    self.contentView.addSubview(lblBy)
//    
//    
//    lblname.text = aParam.valueForKey("by") as NSString
//    lblname.backgroundColor = UIColor(red: 237.0/255.0, green: 62.0/255.0, blue: 61.0/255.0,alpha:1.0)
//    lblname.textColor = UIColor.blackColor()
//    lblname.textAlignment = NSTextAlignment.Center
//    lblname.font = lblBy.font.fontWithSize(10)
//    self.contentView.addSubview(lblname)

    
    
  }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
