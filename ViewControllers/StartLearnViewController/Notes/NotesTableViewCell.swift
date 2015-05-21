//
//  NotesTableViewCell.swift
//  Tonguer
//
//  Created by GrepRuby on 29/04/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import UIKit

class NotesTableViewCell:BaseTableViewCell {
  
  var imageVW: UIImageView!
  var lblContent: UILabel!
  var lblClassNam: UILabel!
  var lblDate: UILabel!
  var lblTime: UILabel!
  var lblLikeCount: UILabel!
  var imageVWLike: UIImageView!
  var imageVWDateAntime: UIImageView!
  var vwCell: UIView!
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  func defaultUIDesign(aParam:NSDictionary,Frame:CGRect){
    
    var arry = self.contentView.subviews
    var vwSub: UIView!
    for vwSub in arry {
      vwSub.removeFromSuperview()
    }
    
    imageVW = UIImageView(frame: CGRectMake(Frame.origin.x+10,Frame.origin.y+10,80, 70))
    
    imageVW.image = UIImage(named: "demoimg.png")
    self.contentView.addSubview(imageVW)
    print(Frame.width)
    vwCell = UIView(frame: CGRectMake(imageVW.frame.origin.x+imageVW.frame.width,imageVW.frame.origin.y,(Frame.width)-(imageVW.frame.width+40),imageVW.frame.height))
    vwCell.layer.borderWidth = 0.5
    vwCell.layer.borderColor = UIColor.lightGrayColor().CGColor
    self.contentView.addSubview(vwCell)
    
    imageVWLike = UIImageView(frame: CGRectMake(vwCell.frame.width-100,2,20,20))
    //imageVWLike.backgroundColor = UIColor.redColor()
    imageVWLike.image = UIImage(named: "likeimg.png")
    vwCell.addSubview(imageVWLike)
    
    lblContent = UILabel(frame: CGRectMake(5, 2,imageVWLike.frame.origin.x-5,20))
    //lblContent.backgroundColor = UIColor.redColor()
    lblContent.text = aParam.valueForKey("content") as NSString
    lblContent.font = lblContent.font.fontWithSize(12)
    lblContent.textColor = UIColor.grayColor()
    vwCell.addSubview(lblContent)
    
    lblLikeCount = UILabel(frame: CGRectMake(imageVWLike.frame.origin.x + 25,imageVWLike.frame.origin.y,vwCell.frame.width - imageVWLike.frame.origin.x-30, 20))
    lblLikeCount.text =  NSString(format: "%i",(aParam.objectForKey("like")?.integerValue)!)
    lblLikeCount.font = lblLikeCount.font.fontWithSize(12)
    lblLikeCount.textAlignment = NSTextAlignment.Left
    lblLikeCount.textColor = UIColor.grayColor()
    //lblLikeCount.backgroundColor = UIColor.redColor()
    vwCell.addSubview(lblLikeCount)
    
    imageVWDateAntime = UIImageView(frame: CGRectMake((vwCell.frame.width-15)/2,vwCell.frame.height-20,15,15))
    imageVWDateAntime.image = UIImage(named: "date.png")
    vwCell.addSubview(imageVWDateAntime)
    
    lblClassNam = UILabel(frame: CGRectMake(lblContent.frame.origin.x,vwCell.frame.height-30,imageVWDateAntime.frame.origin.x - 5,30))
    lblClassNam.text = "Class Name"
    lblClassNam.font = lblClassNam.font.fontWithSize(12)
    lblClassNam.textColor = UIColor.grayColor()
    vwCell.addSubview(lblClassNam)
    
    var date:NSDate! = aParam.valueForKey("date") as NSDate
    var formatter: NSDateFormatter! = NSDateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    
    var strDate: NSString! = formatter.stringFromDate(date)
    
    lblDate = UILabel(frame: CGRectMake(imageVWDateAntime.frame.origin.x+20,vwCell.frame.height-23,vwCell.frame.width-imageVWDateAntime.frame.origin.x-30,20))
    lblDate.text = strDate
    lblDate.font = lblClassNam.font.fontWithSize(12)
    lblDate.textColor = UIColor.grayColor()
    //lblDate.backgroundColor = UIColor.redColor()
    vwCell.addSubview(lblDate)
    
    
    
  }


}
