//
//  VideoTableViewCell.swift
//  Tonguer
//
//  Created by GrepRuby on 03/04/15.
//  Copyright (c) 2015 GrepRuby. All rights reserved.
//

import UIKit

class VideoTableViewCell: BaseTableViewCell {
  
  var celltxtView:UIView!
  var cellImgView:UIImageView!
  var lblText:UILabel!
  var btnplay:UIButton!
  var vwHidden:UIView!
  var btnComplete:UIButton!
  var downloadProgress: UIProgressView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  func defaultUIDesign(aParm:NSDictionary,frame:CGRect){
    
    var arry = self.contentView.subviews
    var vwSub: UIView!
    for vwSub in arry {
      vwSub.removeFromSuperview()
    }
    
    cellImgView = UIImageView(frame: CGRectMake(frame.origin.x+20,15,frame.width-40,130))
    celltxtView = UIView(frame: CGRectMake(cellImgView.frame.origin.x,cellImgView.frame.height+15,cellImgView.frame.width ,50))
    btnComplete = UIButton(frame: CGRectMake(celltxtView.frame.size.width-85,5,80,40))
    lblText = UILabel(frame: CGRectMake(5,2,btnComplete.frame.origin.x,40));
    downloadProgress = UIProgressView(frame: CGRectMake(5,lblText.frame.origin.y+40,btnComplete.frame.origin.x-20,5))
    btnplay = UIButton(frame: CGRectMake((cellImgView.frame.width-30)/2,(cellImgView.frame.height-30)/2,40,40))
    self.setContentsProperties(aParm)
    
  }
  
  func setContentsProperties(aParam: NSDictionary){
    
//    vwHidden.backgroundColor = UIColor.grayColor()
//    self.contentView.addSubview(vwHidden)
    
    let url = NSURL(string: aParam.objectForKey("image") as NSString)
    cellImgView.layer.borderWidth = 0.3
    cellImgView.layer.borderColor = UIColor.grayColor().CGColor
    cellImgView.sd_setImageWithURL(url)

    self.contentView.addSubview(cellImgView)
    
    celltxtView.layer.borderWidth = 0.3
    celltxtView.layer.borderColor = UIColor.grayColor().CGColor
    self.contentView.addSubview(celltxtView)
    
    lblText.numberOfLines = 5
    lblText.font = lblText.font.fontWithSize(13)
    lblText.text = aParam.objectForKey("name") as NSString
    //lblText.backgroundColor = UIColor.yellowColor()
    lblText.textColor = UIColor.grayColor()
    celltxtView.addSubview(lblText);
    
    btnComplete.backgroundColor = UIColor.whiteColor()
    btnComplete.setTitle("Done", forState: UIControlState.Normal)
    btnComplete.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
    btnComplete.backgroundColor = UIColor(red: 71.0/255.0, green: 168.0/255.0, blue: 184.0/255.0,alpha:1.0)
    btnComplete.userInteractionEnabled = true
    btnComplete.layer.cornerRadius = 5
    btnComplete.layer.borderWidth = 1
    btnComplete.layer.borderColor = UIColor.whiteColor().CGColor
    btnComplete.layer.masksToBounds = true
    celltxtView.addSubview(btnComplete)
    
    //downloadProgress.setProgress(10, animated:true)
    //celltxtView.addSubview(downloadProgress)
    
    btnplay.backgroundColor = UIColor.whiteColor()
    btnplay.setImage(UIImage(named: "playicon.png"), forState: UIControlState.Normal)
    btnplay.userInteractionEnabled = true
    btnplay.layer.cornerRadius = 20
    btnplay.layer.borderWidth = 1
    btnplay.layer.borderColor = UIColor.whiteColor().CGColor
    btnplay.layer.masksToBounds = true
    self.contentView.addSubview(btnplay)
    self.contentView.bringSubviewToFront(btnplay)
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }

}
