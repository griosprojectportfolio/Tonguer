//
//  MyNotesTableViewCell.swift
//  Tonguer
//
//  Created by GrepRuby on 29/04/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import UIKit

class MyNotesTableViewCell:BaseTableViewCell  {
  
 @IBOutlet var imageVW: UIImageView!
 @IBOutlet var lblContent: UILabel!
 @IBOutlet var lblClassNam: UILabel!
 @IBOutlet var lblDate: UILabel!
 @IBOutlet var lblLikeCount: UILabel!
 @IBOutlet var imageVWLike: UIImageView!
 @IBOutlet var imageVWDateAntime: UIImageView!
 @IBOutlet  var vwCell: UIView!

  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  
  func defaultUIDesign(aParam:NSDictionary,Frame:CGRect){
    print(aParam)
    imageVW.frame = CGRectMake(Frame.origin.x+10,Frame.origin.y+10,80, 70)
    
    var object:AnyObject! = aParam["image"]
    var strImgUrl: String!
    if(object.isKindOfClass(NSDictionary)){
      strImgUrl = aParam.valueForKey("image")?.valueForKey("url") as! String
    }else if(object.isKindOfClass(NSString)){
      strImgUrl = aParam["image"] as! String
    }
    
    if(strImgUrl == nil){
      imageVW.image = UIImage(named:"defaultImg")!
    }else{
      let url = NSURL(string: strImgUrl)
      imageVW.sd_setImageWithURL(url, placeholderImage: UIImage(named: "defaultImg"))
    }
    print(Frame.width)
    vwCell.frame = CGRectMake(imageVW.frame.origin.x+imageVW.frame.width,imageVW.frame.origin.y,(Frame.width)-(imageVW.frame.width+40),imageVW.frame.height)
    vwCell.layer.borderWidth = 0.5
    vwCell.layer.borderColor = UIColor.lightGrayColor().CGColor

    imageVWLike.frame = CGRectMake(vwCell.frame.width-60,2,20,20)
    imageVWLike.image = UIImage(named: "likeimg.png")

    lblContent.frame = CGRectMake(5, 2,imageVWLike.frame.origin.x-5,20)
    lblContent.text = aParam.valueForKey("content") as? String
    lblContent.font = lblContent.font.fontWithSize(12)
    lblContent.textColor = UIColor.grayColor()

    lblLikeCount.frame = CGRectMake(imageVWLike.frame.origin.x + 20,imageVWLike.frame.origin.y,vwCell.frame.width - imageVWLike.frame.origin.x-23, 20)
    lblLikeCount.text =  NSString(format: "%i",(aParam.objectForKey("like")?.integerValue)!) as String
    lblLikeCount.font = lblLikeCount.font.fontWithSize(12)
    lblLikeCount.textAlignment = NSTextAlignment.Left
    lblLikeCount.textColor = UIColor.grayColor()

    imageVWDateAntime.frame = CGRectMake(vwCell.frame.width-90,vwCell.frame.height-20,15,15)
    imageVWDateAntime.image = UIImage(named: "date.png")

    lblClassNam.frame = CGRectMake(lblContent.frame.origin.x,vwCell.frame.height-30,imageVWDateAntime.frame.origin.x - 5,30)
    lblClassNam.text = aParam.valueForKey("cls_name") as? String
    lblClassNam.font = lblClassNam.font.fontWithSize(12)
    lblClassNam.textColor = UIColor.grayColor()
    var strDate: String!
   
    var dateObj: NSObject = aParam.valueForKey("date") as! NSObject
    if(dateObj.isKindOfClass(NSDate)){
      var date:NSDate! = aParam.valueForKey("date") as! NSDate
      var formatter: NSDateFormatter! = NSDateFormatter()
      formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
      formatter.dateFormat = "dd-MM-yyyy"
      strDate = formatter.stringFromDate(date)
    }else if(dateObj.isKindOfClass(NSString)){
      var str = aParam.valueForKey("date") as! NSString
      var strDet = str.substringToIndex(str.length-14)
      strDate = strDet//aParam.valueForKey("date") as NSString
    }
    
    lblDate.frame = CGRectMake(imageVWDateAntime.frame.origin.x+20,vwCell.frame.height-23,vwCell.frame.width-(imageVWDateAntime.frame.origin.x+22),20)
    lblDate.text = strDate
    lblDate.font = lblClassNam.font.fontWithSize(12)
    lblDate.textColor = UIColor.grayColor()
    //lblDate.backgroundColor = UIColor.redColor()
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected statead
  }
  
  
  
}
