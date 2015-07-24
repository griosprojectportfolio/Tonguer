//
//  VideoTableViewCell.swift
//  Tonguer
//
//  Created by GrepRuby on 03/04/15.
//  Copyright (c) 2015 GrepRuby. All rights reserved.
//

import UIKit

class VideoTableViewCell: BaseTableViewCell {
  
 @IBOutlet var celltxtView:UIView!
 @IBOutlet var cellImgView:UIImageView!
 @IBOutlet var lblText:UILabel!
 @IBOutlet var btnplay:UIButton!
 @IBOutlet var btnComplete:UIButton!
 @IBOutlet var btnDownload:UIButton!
 @IBOutlet var downloadProgress: UIProgressView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  func defaultUIDesign(aParm:NSDictionary,frame:CGRect){
  
    cellImgView.frame =  CGRectMake(frame.origin.x+20,15,frame.width-40,130)
    celltxtView.frame =  CGRectMake(cellImgView.frame.origin.x,cellImgView.frame.height+15,cellImgView.frame.width ,50)
    btnComplete.frame =  CGRectMake(celltxtView.frame.size.width-85,5,80,40)
    lblText.frame =  CGRectMake(5,2,btnComplete.frame.origin.x,40)
    downloadProgress = UIProgressView(frame: CGRectMake(5,lblText.frame.origin.y+40,btnComplete.frame.origin.x-20,5))
    btnplay.frame =  CGRectMake((cellImgView.frame.width-40)/2,(cellImgView.frame.height-40)/2,50,50)
    btnDownload.frame =  CGRectMake((cellImgView.frame.width-40)/2,(cellImgView.frame.height-40)/2,50,50)
    self.setContentsProperties(aParm)
    
  }
  
  func setContentsProperties(aParam: NSDictionary){
    
    let url = NSURL(string: aParam.objectForKey("image") as! String)
    cellImgView.layer.borderWidth = 0.3
    cellImgView.layer.borderColor = UIColor.grayColor().CGColor
    cellImgView.sd_setImageWithURL(url)

    
    celltxtView.layer.borderWidth = 0.3
    celltxtView.layer.borderColor = UIColor.grayColor().CGColor
  
    
    lblText.numberOfLines = 5
    lblText.font = lblText.font.fontWithSize(13)
    lblText.text = aParam.objectForKey("name") as? String
    //lblText.backgroundColor = UIColor.yellowColor()
    lblText.textColor = UIColor.grayColor()
    
    
    btnComplete.backgroundColor = UIColor.whiteColor()
    btnComplete.setTitle("Done", forState: UIControlState.Normal)
    btnComplete.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
    btnComplete.backgroundColor = UIColor(red: 71.0/255.0, green: 168.0/255.0, blue: 184.0/255.0,alpha:1.0)
    btnComplete.userInteractionEnabled = true
    btnComplete.layer.cornerRadius = 5
    btnComplete.layer.borderWidth = 1
    btnComplete.layer.borderColor = UIColor.whiteColor().CGColor
    btnComplete.layer.masksToBounds = true
    
    
//    downloadProgress.setProgress(10, animated:true)
//    celltxtView.addSubview(downloadProgress)
    
   // btnplay.backgroundColor = UIColor(red: 71.0/255.0, green: 168.0/255.0, blue: 184.0/255.0,alpha:1.0)
    btnplay.setImage(UIImage(named: "playicon.png"), forState: UIControlState.Normal)
//    btnplay.setTitle(">", forState: UIControlState.Normal)
//    btnplay.titleLabel?.font = btnplay.titleLabel?.font.fontWithSize(30)
//    btnplay.titleLabel?.textAlignment = NSTextAlignment.Center
//    btnplay.titleLabel?.textColor = UIColor.whiteColor()
    btnplay.tintColor = UIColor(red: 71.0/255.0, green: 168.0/255.0, blue: 184.0/255.0,alpha:1.0)
    btnplay.userInteractionEnabled = true
    btnplay.layer.cornerRadius = 25
    btnplay.layer.borderWidth = 1
    btnplay.layer.borderColor = UIColor.clearColor().CGColor
    btnplay.layer.masksToBounds = true
    
    btnDownload.setImage(UIImage(named: "download.png"), forState: UIControlState.Normal)
    //    btnplay.setTitle(">", forState: UIControlState.Normal)
    //    btnplay.titleLabel?.font = btnplay.titleLabel?.font.fontWithSize(30)
    //    btnplay.titleLabel?.textAlignment = NSTextAlignment.Center
    //    btnplay.titleLabel?.textColor = UIColor.whiteColor()
    btnDownload.tintColor = UIColor(red: 71.0/255.0, green: 168.0/255.0, blue: 184.0/255.0,alpha:1.0)
    btnDownload.userInteractionEnabled = true
    btnDownload.layer.cornerRadius = 25
    btnDownload.layer.borderWidth = 1
    btnDownload.layer.borderColor = UIColor.clearColor().CGColor
    btnDownload.layer.masksToBounds = true
    btnDownload.hidden = true
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }

}
