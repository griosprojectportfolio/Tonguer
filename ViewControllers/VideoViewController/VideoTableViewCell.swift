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
  var circle:UIView!
  var blackView:UIView!
  var progressCircle:CAShapeLayer!
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
  }

  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
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
    cellImgView.sd_setImageWithURL(url, placeholderImage:UIImage(named: "vdoDefault.png"))

    
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
    
   //downloadProgress.setProgress(10, animated:true)
  // celltxtView.addSubview(downloadProgress)
    
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
    //setVideoDownloadingProgessbar(btnplay.frame)
  }
  
  func setVideoDownloadingProgessbar(frame:CGRect,stokend:CGFloat){
     circle = UIView();
    
   // circle.bounds = CGRectMake((cellImgView.frame.width-40)/2,(cellImgView.frame.height-40)/2,50,50)
    circle.frame = CGRectMake((cellImgView.frame.width-50)/2,(cellImgView.frame.height-50)/2,50,50)
    circle.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    circle.layer.cornerRadius = 25
    circle.hidden = true
    circle.layoutIfNeeded()
    
     progressCircle = CAShapeLayer();
    
    let centerPoint = CGPoint (x: circle.bounds.width / 2, y: circle.bounds.width / 2);
    let circleRadius : CGFloat = circle.bounds.width / 2 * 0.7;
    
    var circlePath = UIBezierPath(arcCenter: centerPoint, radius: circleRadius, startAngle: CGFloat(-0.5 * M_PI), endAngle: CGFloat(1.5 * M_PI), clockwise: true    );
    
    progressCircle = CAShapeLayer ();
    progressCircle.path = circlePath.CGPath;
    progressCircle.strokeColor = UIColor.whiteColor().CGColor
    progressCircle.fillColor = UIColor.clearColor().CGColor;
    progressCircle.lineWidth = 5.0;
    progressCircle.strokeStart = 0;
    progressCircle.strokeEnd = stokend;
    
    circle.layer.addSublayer(progressCircle);
    
    cellImgView.addSubview(circle)
  }

  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }

}
