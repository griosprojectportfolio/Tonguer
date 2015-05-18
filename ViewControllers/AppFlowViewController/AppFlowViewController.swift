//
//  AppFlowViewController.swift
//  Tonguer
//
//  Created by GrepRuby on 07/04/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import UIKit

class AppFlowViewController: BaseViewController {
  
  var barBackBtn :UIBarButtonItem!
  var barforwordBtn :UIBarButtonItem!
  var imgVwVedio : UIImageView!
  var imgVwAlpha : UIImageView!
  var VwimgBG :UIView!
  var lblDescrip : UILabel!
  var btnplay : UIButton!
  var scrollVW: UIScrollView!
  var strMessage: NSString = "This is a preliminary document for an API or technology in development. Apple is supplying this information to help you plan for the adoption of the technologies and programming interfaces described herein for use on Apple-branded products. This information is subject to change, and software implemented according to this document should be tested with final operating system software and final documentation. Newer versions of this document may be  First throw call stack: (0x16b1022 0x1842cd6 0xed3871 0x599a 0xe3a1e 0xe2fec 0x109f1d 0xf41cb 0x10adf1 0x10ae0d 0x10aea9 0x496f5 0x4973c 0x1a596 0x1b274 0x2a183 0x2ac38 0x1e634 0x159bef5 0x1685195 0x15e9ff2 0x15e88da 0x15e7d84 0x15e7c9b 0x1ac65 0x1c626 0x32ed 0x2385 0x1) terminate called throwing an exception(lldb)."
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.defaultUIDesign()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func defaultUIDesign(){
    
    self.title = "About App"
    self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
    
    self.navigationItem.setHidesBackButton(true, animated:false)
    
    var backbtn:UIButton = UIButton(frame: CGRectMake(0, 0,25,25))
    backbtn.setImage(UIImage(named: "whiteback.png"), forState: UIControlState.Normal)
    backbtn.addTarget(self, action: "btnBackTapped", forControlEvents: UIControlEvents.TouchUpInside)
    
    barBackBtn = UIBarButtonItem(customView: backbtn)
    
    self.navigationItem.setLeftBarButtonItem(barBackBtn, animated: true)
    
    scrollVW = UIScrollView(frame: CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height))
    
    scrollVW.showsHorizontalScrollIndicator = true
    scrollVW.scrollEnabled = true
    scrollVW.userInteractionEnabled = true
    //scrollVW.backgroundColor = UIColor.grayColor()
    scrollVW.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height+64)
    
   self.view.addSubview(scrollVW)
    
     var rect: CGRect! = strMessage.boundingRectWithSize(CGSize(width:self.view.frame.size.width-60,height:300), options:NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(12)], context: nil)
    
    
    
    
    VwimgBG = UIView(frame: CGRectMake(scrollVW.frame.origin.x+20,scrollVW.frame.origin.y+20, scrollVW.frame.size.width - 40,300))
    //VwimgBG.backgroundColor = UIColor.blackColor()
    scrollVW.addSubview(VwimgBG)
    
    imgVwVedio = UIImageView(frame: CGRectMake((VwimgBG.frame.width-140)/2, (VwimgBG.frame.height-140)/2, 140,150))
    imgVwVedio.image = UIImage(named: "Splash.png")
    VwimgBG.addSubview(imgVwVedio)
    
    imgVwAlpha = UIImageView()
    imgVwAlpha.frame = VwimgBG.bounds
    imgVwAlpha.userInteractionEnabled = true
    imgVwAlpha.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
    VwimgBG.addSubview(imgVwAlpha)
    
    btnplay = UIButton(frame: CGRectMake((imgVwAlpha.frame.width-40)/2,(imgVwAlpha.frame.height-40)/2,40, 40))
    btnplay.backgroundColor = UIColor.whiteColor()
    btnplay.layer.cornerRadius = 20
    btnplay.layer.borderWidth = 1
    btnplay.setImage(UIImage(named: "playicon.png"), forState: UIControlState.Normal)
    btnplay.addTarget(self, action: "btnPayTapped:", forControlEvents: UIControlEvents.TouchUpInside)
    imgVwAlpha.addSubview(btnplay)
    self.view.bringSubviewToFront(btnplay)
    
    lblDescrip = UILabel(frame: CGRectMake(scrollVW.frame.origin.x+20,VwimgBG.frame.origin.y+VwimgBG.frame.size.height+10,scrollVW.frame.width-40,rect.height))
    lblDescrip.text = strMessage
    lblDescrip.numberOfLines = 0
    lblDescrip.textAlignment = NSTextAlignment.Justified
    lblDescrip.font = lblDescrip.font.fontWithSize(12)
    lblDescrip.textColor = UIColor.grayColor()
    //lblDescrip.backgroundColor = UIColor.greenColor()
    scrollVW.addSubview(lblDescrip)
    
  }
  
  func btnBackTapped(){
    self.navigationController?.popViewControllerAnimated(true)
  }
  
  func btnPayTapped(sender:AnyObject){
    print("Tapped")
  }
  
}
