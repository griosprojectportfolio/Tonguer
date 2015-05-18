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
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  func defaultUIDesign(aParm:NSDictionary){
    
    var arry = self.contentView.subviews
    var vwSub: UIView!
    for vwSub in arry {
      vwSub.removeFromSuperview()
    }

    
    if(isiPhone5orLower){
      vwHidden = UIView(frame: CGRectMake(self.contentView.frame.origin.x,self.contentView.frame.origin.y,self.contentView.frame.width, self.contentView.frame.height))
      cellImgView = UIImageView(frame: CGRectMake(20, 15, 320-40,130))
      celltxtView = UIView(frame: CGRectMake(cellImgView.frame.origin.x,cellImgView.frame.height+15,cellImgView.frame.width ,50))
      lblText = UILabel(frame: CGRectMake(5,2,celltxtView.frame.width-20, celltxtView.frame.height-5));
      btnplay = UIButton(frame: CGRectMake((cellImgView.frame.width-40)/2,(cellImgView.frame.height-40)/2,40,40))
      self.setContentsProperties(aParm)
    }
    
    if(isiPhone6){
      vwHidden = UIView(frame: CGRectMake(self.contentView.frame.origin.x,self.contentView.frame.origin.y,self.contentView.frame.width, self.contentView.frame.height))
      cellImgView = UIImageView(frame: CGRectMake(20, 15, 375-40,130))
      celltxtView = UIView(frame: CGRectMake(cellImgView.frame.origin.x,cellImgView.frame.height+15,cellImgView.frame.width ,50))
      lblText = UILabel(frame: CGRectMake(5,2,celltxtView.frame.width-20, celltxtView.frame.height-5));
      btnplay = UIButton(frame: CGRectMake(170,55,40,40))
      self.setContentsProperties(aParm)
    }
    
    if(isiPhone6plus){
        vwHidden = UIView(frame: CGRectMake(self.contentView.frame.origin.x,self.contentView.frame.origin.y,self.contentView.frame.width, self.contentView.frame.height))
      cellImgView = UIImageView(frame: CGRectMake(20, 15, 414-40,130))
      celltxtView = UIView(frame: CGRectMake(cellImgView.frame.origin.x,cellImgView.frame.height+15,cellImgView.frame.width ,50))
      lblText = UILabel(frame: CGRectMake(5,2,celltxtView.frame.width-20, celltxtView.frame.height-5));
      btnplay = UIButton(frame: CGRectMake((cellImgView.frame.width-40)/2,(cellImgView.frame.height-40)/2,40,40))
      self.setContentsProperties(aParm)
      
      
    }
    
    
  }
  
  func setContentsProperties(aParam: NSDictionary){
    
//    vwHidden.backgroundColor = UIColor.grayColor()
//    self.contentView.addSubview(vwHidden)
    
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
