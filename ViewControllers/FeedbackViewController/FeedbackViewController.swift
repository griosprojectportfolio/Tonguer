//
//  FeedbackViewController.swift
//  Tonguer
//
//  Created by GrepRuby on 02/04/15.
//  Copyright (c) 2015 GrepRuby. All rights reserved.
//

import UIKit

class FeedbackViewController: UIViewController,UITextFieldDelegate,UITextViewDelegate {
  
  var barBackBtn :UIBarButtonItem!
  var barforwordBtn :UIBarButtonItem!
  var imgVwLogo : UIImageView!
  var txtViewComment :UITextView!
  var btnSend :UIButton!
  var custxtFname:CustomTextFieldBlurView!
  var custxtEmail:CustomTextFieldBlurView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.defaultUIDesign()
    
  }
  
  func defaultUIDesign(){
    self.title = "Feedback"
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

    
    imgVwLogo = UIImageView(frame:CGRectMake((self.view.frame.size.width-100)/2,84, 90, 100))
    imgVwLogo.image = UIImage(named: "Splash.png")
    self.view.addSubview(imgVwLogo)
    
    var framefname:CGRect = CGRectMake(self.view.frame.origin.x+20, self.imgVwLogo.frame.origin.y+120, self.view.frame.size.width-40, 40)
    custxtFname = CustomTextFieldBlurView(frame:framefname, imgName:"user.png")
    custxtFname.attributedPlaceholder = NSAttributedString(string:"First Name",attributes:[NSForegroundColorAttributeName: UIColor(red: 66.0/255.0, green: 150.0/255.0, blue: 173.0/255.0,alpha:1.0)])
    // custxtEmail.returnKeyType = UIReturnType.Done
    custxtFname.delegate = self;
    custxtFname.returnKeyType = UIReturnKeyType.Done
    custxtFname.clearButtonMode = UITextFieldViewMode.Always
    custxtFname.keyboardType = .EmailAddress
    self.view.addSubview(custxtFname)
    
    var frameEmail:CGRect = CGRectMake(framefname.origin.x,framefname.origin.y+framefname.height+10,framefname.width, framefname.height)
    custxtEmail = CustomTextFieldBlurView(frame:frameEmail, imgName:"emailicon.png")
    custxtEmail.attributedPlaceholder = NSAttributedString(string:"Email",attributes:[NSForegroundColorAttributeName: UIColor(red: 66.0/255.0, green: 150.0/255.0, blue: 173.0/255.0,alpha:1.0)])
    // custxtEmail.returnKeyType = UIReturnType.Done
    custxtEmail.delegate = self;
    custxtEmail.returnKeyType = UIReturnKeyType.Done
    custxtEmail.clearButtonMode = UITextFieldViewMode.Always
    custxtEmail.keyboardType = .EmailAddress
    self.view.addSubview(custxtEmail)
    
    txtViewComment = UITextView(frame: CGRectMake(frameEmail.origin.x, frameEmail.origin.y+frameEmail.height+10, frameEmail.width, 200))
    txtViewComment.text = "Type Your Comment"
    txtViewComment.delegate = self
    txtViewComment.textColor = UIColor(red: 66.0/255.0, green: 150.0/255.0, blue: 173.0/255.0,alpha:1.0)
    txtViewComment.layer.borderWidth = 1
    txtViewComment.layer.borderColor = UIColor(red: 66.0/255.0, green: 150.0/255.0, blue: 173.0/255.0,alpha:1.0).CGColor
    self.view.addSubview(txtViewComment)
    
    self.btnSend = UIButton(frame: CGRectMake(txtViewComment.frame.origin.x,(txtViewComment.frame.origin.y+txtViewComment.frame.size.height)+20, txtViewComment.frame.size.width, 40))
    self.btnSend.setTitle("Send", forState: UIControlState.Normal)
    self.btnSend.backgroundColor = UIColor(red: 237.0/255.0, green: 62.0/255.0, blue: 61.0/255.0,alpha:1.0);
    self.btnSend.tintColor = UIColor.whiteColor()
    self.view.addSubview(self.btnSend)

    
  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  func textViewDidChange(textView: UITextView) {
    
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return false
  }
  
  func btnBackTapped(){
    self.navigationController?.popViewControllerAnimated(true)
  }
  
  func btnforwardTapped(){
    let vc = self.storyboard?.instantiateViewControllerWithIdentifier("PickCenterID") as PickupCoursecenterViewController
    self.navigationController?.pushViewController(vc, animated: true)
  }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
