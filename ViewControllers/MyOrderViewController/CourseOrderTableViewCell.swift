//
//  CourseOrderTableViewCell.swift
//  Tonguer
//
//  Created by GrepRuby on 27/05/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import UIKit

class CourseOrderTableViewCell: UITableViewCell {
  
  @IBOutlet var btnNotPay: UIButton!
  @IBOutlet var vwCell: UIView!
  @IBOutlet var lblPrice: UILabel!
  @IBOutlet var lblClassName: UILabel!
  @IBOutlet var lblDate: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
  
  
  func defaultCellContents(obj:UserClassOrder,frame:CGRect){
    
    var strMessage = obj.cls_name
    var rect: CGRect! = strMessage.boundingRectWithSize(CGSize(width:frame.size.width-60,height:300), options:NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(12)], context: nil)
    
    vwCell.frame = CGRectMake(frame.origin.x+10,10,frame.width-20,80+rect.height)
    vwCell.layer.borderWidth = 1
    vwCell.layer.borderColor = UIColor.lightGrayColor().CGColor

    var price:NSString = NSString(format:"%i",obj.cls_amount.doubleValue)
    
    lblPrice.frame = CGRectMake(vwCell.frame.width-60,0,50,40)
    lblPrice.text = "$"+price
    lblPrice.font = lblPrice.font.fontWithSize(18)
    lblPrice.textColor = UIColor(red: 237.0/255.0, green: 62.0/255.0, blue: 61.0/255.0,alpha:1.0)

     lblClassName.frame = CGRectMake(2, 0,lblPrice.frame.origin.x-5,40)
    lblClassName.text = obj.cls_name
    lblClassName.font = lblClassName.font.fontWithSize(15)
    lblClassName.textColor = UIColor.lightGrayColor()
    lblClassName.numberOfLines = 0

    btnNotPay.frame  = CGRectMake(vwCell.frame.width-110,vwCell.frame.height-40,100,30)
    btnNotPay.setTitle("Note Pay", forState:UIControlState.Normal)
    btnNotPay.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
    btnNotPay.backgroundColor = UIColor(red: 237.0/255.0, green: 62.0/255.0, blue: 61.0/255.0,alpha:1.0)

    lblDate.frame = CGRectMake(5,vwCell.frame.height-40,btnNotPay.frame.origin.x-20,40)
    var strDate = obj.date as NSString
    var subStr = strDate.substringWithRange(NSRange(location:0, length:strDate.length-8))
    
    var dateformat:NSDateFormatter = NSDateFormatter()
    dateformat.dateFormat = "yyyy-MM-dd'T'HH:mm"
    let date = dateformat.dateFromString(subStr)
    dateformat.dateFormat = "dd-MM-yyyy H:mm"
    let datestr = dateformat.stringFromDate(date!)
    var strclsDate = dateformat.stringFromDate(date!)
    print(strclsDate)
    lblDate.text = strclsDate
    lblDate.font = lblClassName.font.fontWithSize(15)
    lblDate.textColor = UIColor.lightGrayColor()
  }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
