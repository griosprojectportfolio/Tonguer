//
//  ForgotpasswordViewController.swift
//  Tonguer
//
//  Created by GrepRuby on 02/04/15.
//  Copyright (c) 2015 GrepRuby. All rights reserved.
//

import UIKit

class ForgotpasswordViewController: BaseViewController,UITextFieldDelegate {
  
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

    self.navigationItem.setHidesBackButton(true, animated:false)
    
    var backbtn:UIButton = UIButton(frame: CGRectMake(0, 0,25,25))
    backbtn.setImage(UIImage(named: "whiteback.png"), forState: UIControlState.Normal)
    backbtn.addTarget(self, action: "btnBackTapped", forControlEvents: UIControlEvents.TouchUpInside)
    
    barBackBtn = UIBarButtonItem(customView: backbtn)
    
    self.navigationItem.setLeftBarButtonItem(barBackBtn, animated: true)
    
  
    
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
    if(custxtEmail.text.isEmpty){
      var alert: UIAlertView = UIAlertView(title: "Alert", message: "Please enter your mail address.", delegate:self, cancelButtonTitle:"OK")
      alert.show()

    }else{
     self.forgotpasswordApiCall()
    }
  }
  
  func btnBackTapped(){
    self.navigationController?.popViewControllerAnimated(true)
  }
  
  func btnforwardTapped(){
    let vc = self.storyboard?.instantiateViewControllerWithIdentifier("AppFlowID") as! AppFlowViewController
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  func forgotpasswordApiCall(){
    var dict: NSMutableDictionary! = NSMutableDictionary()
    dict.setObject(custxtEmail.text, forKey: "user")
    
//    var aParams: NSMutableDictionary = NSMutableDictionary()
//    aParams.setObject(dict, forKey: "user")
    
    self.api.forgotPassword(dict as [NSObject : AnyObject], success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
      println(responseObject)
      var alert: UIAlertView = UIAlertView(title: "Alert", message: "Password is successfully send your mail address.", delegate:self, cancelButtonTitle:"OK")
      alert.show()
      },
      failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
        println(error)
        var alert: UIAlertView = UIAlertView(title: "Alert", message: "Password is not send your mail address(Mail address is worng).", delegate:self, cancelButtonTitle:"OK")
        alert.show()
    })

    
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return false
  }
  
  func textFieldDidBeginEditing(textField: UITextField) {
    if(self.isiPhone5orLower){
      var frame:CGRect = self.view.frame
      frame.origin.y = frame.origin.y - 100
      self.view.frame = frame
    }else{
      //      var frame:CGRect = self.view.frame
      //      frame.origin.y = frame.origin.y - 100
      //      self.view.frame = frame
    }
    
  }
  
  func textFieldDidEndEditing(textField: UITextField) {
    
    if(self.isiPhone5orLower){
      var frame:CGRect = self.view.frame
      frame.origin.y = frame.origin.y + 100
      self.view.frame = frame
    }else{
      //      var frame:CGRect = self.view.frame
      //      frame.origin.y = frame.origin.y - 100
      //      self.view.frame = frame
    }
    
  }

  
  
  
}
