//
//  ForgotpasswordViewController.swift
//  Tonguer
//
//  Created by GrepRuby on 02/04/15.
//  Copyright (c) 2015 GrepRuby. All rights reserved.
//

import UIKit

class ForgotpasswordViewController: UIViewController,UITextFieldDelegate {
  
  var barBackBtn :UIBarButtonItem!
  var imgVwLogo : UIImageView!
  var btnSend:UIButton!
  var barforwordBtn :UIBarButtonItem!
  var api: AppApi!
  
  var custxtEmail:CustomTextFieldBlurView!
  
  override func viewDidLoad() {
    super.viewDidLoad()

    api = AppApi.sharedClient()
    
    self.defaultUIDesign()
  }
  
  func defaultUIDesign(){
    self.title = "Forgot password"
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
    
    imgVwLogo = UIImageView(frame: CGRectMake((self.view.frame.width-140)/2,self.view.frame.origin.y+100,140,150))
    imgVwLogo.image = UIImage(named: "Splash.png")
    self.view.addSubview(imgVwLogo)
    
    var frameEmail:CGRect = CGRectMake(self.view.frame.origin.x+20,self.imgVwLogo.frame.size.height+124,self.view.frame.size.width-40, 40)
    
    custxtEmail = CustomTextFieldBlurView(frame:frameEmail, imgName:"emailicon.png")
    custxtEmail.attributedPlaceholder = NSAttributedString(string:"Email",attributes:[NSForegroundColorAttributeName: UIColor(red: 66.0/255.0, green: 150.0/255.0, blue: 173.0/255.0,alpha:1.0)])
    // custxtEmail.returnKeyType = UIReturnType.Done
    custxtEmail.delegate = self;
    custxtEmail.returnKeyType = UIReturnKeyType.Done
    custxtEmail.clearButtonMode = UITextFieldViewMode.Always
    custxtEmail.keyboardType = .EmailAddress
    self.view.addSubview(custxtEmail)
    
    self.btnSend = UIButton(frame: CGRectMake(frameEmail.origin.x,frameEmail.origin.y+frameEmail.height+20,frameEmail.width, frameEmail.height))
    self.btnSend.setTitle("Send", forState: UIControlState.Normal)
    self.btnSend.backgroundColor = UIColor(red: 237.0/255.0, green: 62.0/255.0, blue: 61.0/255.0,alpha:1.0);
    self.btnSend.tintColor = UIColor.whiteColor()
    btnSend.addTarget(self, action: "btnSendTapped", forControlEvents: UIControlEvents.TouchUpInside)
    self.view.addSubview(self.btnSend)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func btnSendTapped(){
    self.forgotpasswordApiCall()
  }
  
  func btnBackTapped(){
    self.navigationController?.popViewControllerAnimated(true)
  }
  
  func btnforwardTapped(){
    let vc = self.storyboard?.instantiateViewControllerWithIdentifier("AppFlowID") as AppFlowViewController
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  func forgotpasswordApiCall(){
    var dict: NSMutableDictionary! = NSMutableDictionary()
    dict.setObject(custxtEmail.text, forKey: "email")
    
    var aParams: NSMutableDictionary = NSMutableDictionary()
    aParams.setObject(dict, forKey: "user")
    
    self.api.forgotPassword(aParams, success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
      println(responseObject)
      },
      failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
        println(error)
    })

    
  }
  
  
}
