//
//  AppFlowViewController.swift
//  Tonguer
//
//  Created by GrepRuby on 07/04/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import UIKit

class AppFlowViewController: UIViewController {
  
  var barBackBtn :UIBarButtonItem!
  var barforwordBtn :UIBarButtonItem!
  var imgVwVedio : UIImageView!
  var imgVwAlpha : UIImageView!
  var VwimgBG :UIView!
  var lblDescrip : UILabel!
  var btnplay : UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.defaultUIDesign()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func defaultUIDesign(){
    
    self.title = "About Flow of App"
    self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
    
    self.navigationItem.setHidesBackButton(true, animated:false)
    
    var backbtn:UIButton = UIButton(frame: CGRectMake(0, 0,25,25))
    backbtn.setImage(UIImage(named: "whiteback.png"), forState: UIControlState.Normal)
    backbtn.addTarget(self, action: "btnBackTapped", forControlEvents: UIControlEvents.TouchUpInside)
    
    barBackBtn = UIBarButtonItem(customView: backbtn)
    
    self.navigationItem.setLeftBarButtonItem(barBackBtn, animated: true)
    
    var btnforword:UIButton = UIButton(frame: CGRectMake(0, 0,25,25))
    btnforword.setImage(UIImage(named: "whiteforward.png"), forState: UIControlState.Normal)
    btnforword.addTarget(self, action: "btnforwardTapped", forControlEvents: UIControlEvents.TouchUpInside)
    
    barforwordBtn = UIBarButtonItem(customView: btnforword)
    
    self.navigationItem.setRightBarButtonItem(barforwordBtn, animated: true)

    
    lblDescrip = UILabel(frame: CGRectMake(self.view.frame.origin.x+20,(self.view.frame.height-200),self.view.frame.width-40, 180))
    lblDescrip.text = "This is a preliminary document for an API or technology in development. Apple is supplying this information to help you plan for the adoption of the technologies and programming interfaces described herein for use on Apple-branded products. This information is subject to change, and software implemented according to this document should be tested with final operating system software and final documentation. Newer versions of this document may be."
    lblDescrip.numberOfLines = 0
    lblDescrip.font = lblDescrip.font.fontWithSize(12)
    lblDescrip.textColor = UIColor.grayColor()
    //lblDescrip.backgroundColor = UIColor.greenColor()
    self.view.addSubview(lblDescrip)
    
    VwimgBG = UIView(frame: CGRectMake(self.view.frame.origin.x+20,self.view.frame.origin.y+74, self.view.frame.size.width - 40,lblDescrip.frame.origin.y-80))
    //VwimgBG.backgroundColor = UIColor.blackColor()
    self.view.addSubview(VwimgBG)
    
    imgVwVedio = UIImageView(frame: CGRectMake((VwimgBG.frame.width-140)/2, (VwimgBG.frame.height-140)/2, 140,150))
    imgVwVedio.image = UIImage(named: "Splash.png")
    VwimgBG.addSubview(imgVwVedio)
    
    imgVwAlpha = UIImageView()
    imgVwAlpha.frame = VwimgBG.bounds
    imgVwAlpha.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
    VwimgBG.addSubview(imgVwAlpha)
    
    btnplay = UIButton(frame: CGRectMake((imgVwAlpha.frame.width-40)/2,(imgVwAlpha.frame.height-40)/2,40, 40))
    btnplay.backgroundColor = UIColor.whiteColor()
    btnplay.layer.cornerRadius = 20
    btnplay.layer.borderWidth = 1
    btnplay.setImage(UIImage(named: "playimg.png"), forState: UIControlState.Normal)
    imgVwAlpha.addSubview(btnplay)
    
  }
  
  func btnBackTapped(){
    self.navigationController?.popViewControllerAnimated(true)
  }
  
  func btnforwardTapped(){
    let vc = self.storyboard?.instantiateViewControllerWithIdentifier("MyOderID") as MyOrderViewController
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
}
