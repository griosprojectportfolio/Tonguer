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
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  func defaultUIDesign(aParm:NSDictionary){
    
    if(isiPhone5orLower){
      cellImgView = UIImageView(frame: CGRectMake(20, 15, 320-40,130))
      celltxtView = UIView(frame: CGRectMake(cellImgView.frame.origin.x,cellImgView.frame.height+15,cellImgView.frame.width ,50))
      lblText = UILabel(frame: CGRectMake(5,2,celltxtView.frame.width-20, celltxtView.frame.height-5));
      btnplay = UIButton(frame: CGRectMake((cellImgView.frame.width-50)/2,(cellImgView.frame.height-50)/2,50,50))
      self.setContentsProperties(aParm)
    }
    
    if(isiPhone6){
      cellImgView = UIImageView(frame: CGRectMake(20, 15, 375-40,130))
      celltxtView = UIView(frame: CGRectMake(cellImgView.frame.origin.x,cellImgView.frame.height+15,cellImgView.frame.width ,50))
      lblText = UILabel(frame: CGRectMake(5,2,celltxtView.frame.width-20, celltxtView.frame.height-5));
      btnplay = UIButton(frame: CGRectMake(170,50,50,50))
      self.setContentsProperties(aParm)
    }
    
    if(isiPhone6plus){
      
      cellImgView = UIImageView(frame: CGRectMake(20, 15, 414-40,130))
      celltxtView = UIView(frame: CGRectMake(cellImgView.frame.origin.x,cellImgView.frame.height+15,cellImgView.frame.width ,50))
      lblText = UILabel(frame: CGRectMake(5,2,celltxtView.frame.width-20, celltxtView.frame.height-5));
      btnplay = UIButton(frame: CGRectMake((cellImgView.frame.width-50)/2,(cellImgView.frame.height-50)/2,50,50))
      self.setContentsProperties(aParm)
      
      
    }
    
    
  }
  
  func setContentsProperties(aParam: NSDictionary){
    let url = NSURL(string: aParam.objectForKey("image") as NSString)
    let data = NSData(contentsOfURL: url!)
    cellImgView.layer.borderWidth = 0.3
    cellImgView.layer.borderColor = UIColor.grayColor().CGColor
    cellImgView.image = UIImage(data: data!)
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
    
    btnplay.backgroundColor = UIColor.whiteColor()
    btnplay.setBackgroundImage(UIImage(named: "playimg.png"), forState: UIControlState.Normal)
    btnplay.userInteractionEnabled = true
    btnplay.layer.cornerRadius = 30
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
