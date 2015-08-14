//
//  VideoTableViewCell.swift
//  Tonguer
//
//  Created by GrepRuby on 03/04/15.
//  Copyright (c) 2015 GrepRuby. All rights reserved.
//

import UIKit

class VideoTableViewCell: BaseTableViewCell{
  
 @IBOutlet var celltxtView:UIView!
 @IBOutlet var cellImgView:UIImageView!
 @IBOutlet var lblText:UILabel!
 @IBOutlet var btnplay:UIButton!
 @IBOutlet var btnComplete:UIButton!
 @IBOutlet var btnDownload:UIButton!
 @IBOutlet var downloadProgress: UIProgressView!
 @IBOutlet var dwonCompleteImgView:UIImageView!
 @IBOutlet var lbldwonComplete:UILabel!
  
  var circle:UIView!
  var blackView:UIView!
  var progressCircle:CAShapeLayer!
  var cellIndex:NSInteger!
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
  
    cellImgView.frame =  CGRectMake(frame.origin.x+20,10,frame.width-40,130)
    lbldwonComplete.frame = CGRectMake(140,15,80,20)
    celltxtView.frame =  CGRectMake(cellImgView.frame.origin.x,cellImgView.frame.height+10,cellImgView.frame.width ,50)
    btnComplete.frame =  CGRectMake(cellImgView.frame.width-52,13,70,30)
    lblText.frame =  CGRectMake(50,15,btnComplete.frame.origin.x,20)
    downloadProgress = UIProgressView(frame: CGRectMake(5,lblText.frame.origin.y+40,btnComplete.frame.origin.x-20,5))
    btnplay.frame =  CGRectMake(celltxtView.frame.width-40,10,30,30)
    //btnDownload.frame =  CGRectMake((cellImgView.frame.width-40)/2,(cellImgView.frame.height-40)/2,50,50)
    dwonCompleteImgView.frame = CGRectMake(5,10,30,30)
    self.setContentsProperties(aParm)
    
  }
  
  func setContentsProperties(aParam: NSDictionary){
    
    let url = NSURL(string: aParam.objectForKey("image") as! String)
    cellImgView.layer.borderWidth = 0.3
    cellImgView.layer.borderColor = UIColor.grayColor().CGColor
    cellImgView.sd_setImageWithURL(url, placeholderImage:UIImage(named: "defaultImg"))

    
    celltxtView.layer.borderWidth = 0.3
    celltxtView.layer.borderColor = UIColor.grayColor().CGColor
    celltxtView.backgroundColor = UIColor.whiteColor()
  
    
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
    
    btnplay.backgroundColor = UIColor.whiteColor()
    btnplay.setImage(UIImage(named: "playicon.png"), forState: UIControlState.Normal)
//    btnplay.setTitle(">", forState: UIControlState.Normal)
//    btnplay.titleLabel?.font = btnplay.titleLabel?.font.fontWithSize(30)
//    btnplay.titleLabel?.textAlignment = NSTextAlignment.Center
//    btnplay.titleLabel?.textColor = UIColor.whiteColor()
    btnplay.tintColor = UIColor.greenColor()
    btnplay.userInteractionEnabled = true
    btnplay.layer.cornerRadius = 15
    btnplay.layer.masksToBounds = true
    
//    btnDownload.setImage(UIImage(named: "download.png"), forState: UIControlState.Normal)
//    //    btnplay.setTitle(">", forState: UIControlState.Normal)
//    //    btnplay.titleLabel?.font = btnplay.titleLabel?.font.fontWithSize(30)
//    //    btnplay.titleLabel?.textAlignment = NSTextAlignment.Center
//    //    btnplay.titleLabel?.textColor = UIColor.whiteColor()
//    btnDownload.tintColor = UIColor(red: 71.0/255.0, green: 168.0/255.0, blue: 184.0/255.0,alpha:1.0)
//    btnDownload.userInteractionEnabled = true
//    btnDownload.layer.cornerRadius = 25
//    btnDownload.layer.borderWidth = 1
//    btnDownload.layer.borderColor = UIColor.clearColor().CGColor
//    btnDownload.layer.masksToBounds = true
//    btnDownload.hidden = true
//    //setVideoDownloadingProgessbar(btnplay.frame)
    
    
    dwonCompleteImgView.backgroundColor = UIColor.whiteColor()
    dwonCompleteImgView.tintColor = UIColor.greenColor()
    dwonCompleteImgView.layer.cornerRadius = 15
    dwonCompleteImgView.image = UIImage(named: "downComplete")
    dwonCompleteImgView.hidden = true
    celltxtView.bringSubviewToFront(dwonCompleteImgView)
    
    lbldwonComplete.text = "Downloaded"
    lbldwonComplete.font = lbldwonComplete.font.fontWithSize(10)
    lbldwonComplete.textAlignment = NSTextAlignment.Center
    lbldwonComplete.textColor = UIColor.whiteColor()
    lbldwonComplete.backgroundColor = UIColor(red: 237.0/255.0, green: 62.0/255.0, blue: 61.0/255.0,alpha:1.0)
    lbldwonComplete.hidden = true
    lbldwonComplete.layer.cornerRadius = 2
    lbldwonComplete.layer.borderWidth = 1
    lbldwonComplete.layer.borderColor = UIColor.whiteColor().CGColor
    lbldwonComplete.layer.masksToBounds = true

    
  }
  
  func setVideoDownloadingProgessbar(frame:CGRect,stokend:CGFloat){
     circle = UIView();
    //circle.bounds = CGRectMake(celltxtView.frame.width-40,10,30,30)
    circle.frame = CGRectMake(celltxtView.frame.width-40,10,30,30)
    circle.backgroundColor = UIColor.whiteColor()
    circle.layer.cornerRadius = 15
    circle.hidden = true
    circle.layoutIfNeeded()
    
     progressCircle = CAShapeLayer();
    
    let centerPoint = CGPoint (x: circle.bounds.width / 2, y: circle.bounds.width / 2);
    let circleRadius : CGFloat = circle.bounds.width / 2 * 0.7;
    
    var circlePath = UIBezierPath(arcCenter: centerPoint, radius: circleRadius, startAngle: CGFloat(-0.5 * M_PI), endAngle: CGFloat(1.5 * M_PI), clockwise:true);
    
    progressCircle = CAShapeLayer ();
    progressCircle.path = circlePath.CGPath;
    progressCircle.strokeColor = UIColor.greenColor().CGColor
    progressCircle.fillColor = UIColor.clearColor().CGColor;
    progressCircle.lineWidth = 3.0;
    progressCircle.strokeStart = 0;
    progressCircle.strokeEnd = stokend;
    
    circle.layer.addSublayer(progressCircle);
    
    celltxtView.addSubview(circle)
  }
  
//  func setDownloadcompleteImage(image:UIImage,status:Bool){
//    dwonCompleteImgView.backgroundColor = UIColor.whiteColor()
//    dwonCompleteImgView.layer.cornerRadius = 25
//    dwonCompleteImgView.image = image
//    dwonCompleteImgView.hidden = status
//    cellImgView.addSubview(dwonCompleteImgView)
//  }

  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }

}
