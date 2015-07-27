//
//  FeedbackViewController.swift
//  Tonguer
//
//  Created by GrepRuby on 02/04/15.
//  Copyright (c) 2015 GrepRuby. All rights reserved.
//

import UIKit

class FeedbackViewController: BaseViewController,UITextFieldDelegate,UITextViewDelegate {
  
  var barBackBtn :UIBarButtonItem!
  var barforwordBtn :UIBarButtonItem!
  var imgVwLogo : UIImageView!
  var txtViewComment :UITextView!
  var btnSend :UIButton!
  var custxtFname:CustomTextFieldBlurView!
  var custxtEmail:CustomTextFieldBlurView!
  var scrollVW:UIScrollView!
  var lblComment: UILabel!
  var toolBar:UIToolbar!
  var api: AppApi!
  override func viewDidLoad() {
    super.viewDidLoad()
    api = AppApi.sharedClient()
    self.defaultUIDesign()
    
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    lblComment.hidden = false
  }
  
  func defaultUIDesign(){
    self.title = "Feedback"
   
    self.navigationItem.setHidesBackButton(true, animated:false)
    
    var backbtn:UIButton = UIButton(frame: CGRectMake(0, 0,25,25))
    backbtn.setImage(UIImage(named: "whiteback.png"), forState: UIControlState.Normal)
    backbtn.addTarget(self, action: "btnBackTapped", forControlEvents: UIControlEvents.TouchUpInside)
    
    barBackBtn = UIBarButtonItem(customView: backbtn)
    self.navigationItem.setLeftBarButtonItem(barBackBtn, animated: true)
    
    scrollVW = UIScrollView(frame: CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height))
    scrollVW.showsVerticalScrollIndicator = false
    scrollVW.scrollEnabled = true
    scrollVW.userInteractionEnabled = true
   // scrollVW.backgroundColor = UIColor.grayColor()
    if(isiPhone4orLower){
      scrollVW.contentSize = CGSize(width: self.view.frame.width, height:500)
    }else{
      scrollVW.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height+20)
    }
    
    
    self.view.addSubview(scrollVW)

    
    imgVwLogo = UIImageView(frame:CGRectMake((scrollVW.frame.size.width-100)/2,20, 90, 100))
    imgVwLogo.image = UIImage(named: "Splash.png")
    scrollVW.addSubview(imgVwLogo)
    
    var framefname:CGRect = CGRectMake(scrollVW.frame.origin.x+20, self.imgVwLogo.frame.origin.y+120, self.view.frame.size.width-40, 40)
    custxtFname = CustomTextFieldBlurView(frame:framefname, imgName:"user.png")
    custxtFname.attributedPlaceholder = NSAttributedString(string:"Name",attributes:[NSForegroundColorAttributeName: UIColor(red: 66.0/255.0, green: 150.0/255.0, blue: 173.0/255.0,alpha:1.0)])
    // custxtEmail.returnKeyType = UIReturnType.Done
    custxtFname.delegate = self;
    custxtFname.returnKeyType = UIReturnKeyType.Done
    custxtFname.clearButtonMode = UITextFieldViewMode.Always
    custxtFname.keyboardType = .EmailAddress
    scrollVW.addSubview(custxtFname)
    
    var frameEmail:CGRect = CGRectMake(framefname.origin.x,framefname.origin.y+framefname.height+10,framefname.width, framefname.height)
    custxtEmail = CustomTextFieldBlurView(frame:frameEmail, imgName:"emailicon.png")
    custxtEmail.attributedPlaceholder = NSAttributedString(string:"Email",attributes:[NSForegroundColorAttributeName: UIColor(red: 66.0/255.0, green: 150.0/255.0, blue: 173.0/255.0,alpha:1.0)])
    // custxtEmail.returnKeyType = UIReturnType.Done
    custxtEmail.delegate = self;
    custxtEmail.returnKeyType = UIReturnKeyType.Done
    custxtEmail.clearButtonMode = UITextFieldViewMode.Always
    custxtEmail.keyboardType = .EmailAddress
   // scrollVW.addSubview(custxtEmail)
    
    var barBtnDone: UIBarButtonItem! = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: "barBtnDonTapped:")
    var barSpace: UIBarButtonItem! = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target:self, action: nil)
    
    toolBar = UIToolbar(frame: CGRectMake(0, 0, self.view.frame.width,50))
    toolBar.items = [barSpace,barBtnDone]

    
    txtViewComment = UITextView(frame: CGRectMake(frameEmail.origin.x, framefname.origin.y+framefname.height+10, frameEmail.width, 200))
    txtViewComment.text = ""
    txtViewComment.delegate = self
    txtViewComment.textColor = UIColor(red: 66.0/255.0, green: 150.0/255.0, blue: 173.0/255.0,alpha:1.0)
    txtViewComment.layer.borderWidth = 1
    txtViewComment.layer.borderColor = UIColor(red: 66.0/255.0, green: 150.0/255.0, blue: 173.0/255.0,alpha:1.0).CGColor
    txtViewComment.inputAccessoryView = toolBar
    scrollVW.addSubview(txtViewComment)
    
    lblComment = UILabel(frame: CGRectMake((txtViewComment.frame.size.width-140)/2,(txtViewComment.frame.size.height-30)/2,150, 30))
    lblComment.text = "Type your Comment"
    lblComment.font = lblComment.font.fontWithSize(12)
    lblComment.textColor = UIColor(red: 66.0/255.0, green: 150.0/255.0, blue: 173.0/255.0,alpha:1.0)
    txtViewComment.addSubview(lblComment)
    
    self.btnSend = UIButton(frame: CGRectMake(txtViewComment.frame.origin.x,(txtViewComment.frame.origin.y+txtViewComment.frame.size.height)+20, txtViewComment.frame.size.width, 40))
    self.btnSend.setTitle("Send", forState: UIControlState.Normal)
    self.btnSend.backgroundColor = UIColor(red: 237.0/255.0, green: 62.0/255.0, blue: 61.0/255.0,alpha:1.0);
    self.btnSend.tintColor = UIColor.whiteColor()
    btnSend.addTarget(self, action: "btnSendTapped:", forControlEvents: UIControlEvents.TouchUpInside)
    scrollVW.addSubview(self.btnSend)
  }
  
  func barBtnDonTapped(sender:UIBarButtonItem){
    scrollVW.contentOffset = CGPoint(x:0, y:-40)
    txtViewComment.resignFirstResponder()
  }
  
  func btnSendTapped(sender:AnyObject){
    if(custxtFname.text.isEmpty || txtViewComment.text.isEmpty){
      var alert: UIAlertView = UIAlertView(title: "", message: "Please Don't left any field", delegate:self, cancelButtonTitle:"OK")
      alert.show()
    }else{
      userLearnClsApiCall()
    }
  }
  
  
  
  func textViewDidBeginEditing(textView: UITextView) {
    lblComment.hidden = true
    if isiPhone4orLower{
       scrollVW.contentOffset = CGPoint(x:0, y:btnSend.frame.height+100)
       scrollVW.contentSize = CGSize(width: self.view.frame.width, height:800)
    }else{
       scrollVW.contentOffset = CGPoint(x:0, y:btnSend.frame.height+50)
    }
   
  }
  
  func textViewDidEndEditing(textView: UITextView) {
    if isiPhone4orLower{
      scrollVW.contentOffset = CGPoint(x:0, y:-50)
      scrollVW.contentSize = CGSize(width: self.view.frame.width, height:500)
    }else{
      scrollVW.contentOffset = CGPoint(x:0, y:-50)
    }

  }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return false
  }
  
  func btnBackTapped(){
    self.navigationController?.popViewControllerAnimated(true)
  }
  
  // ********* FeedBack Api Call Mehtods*************
  
  func userLearnClsApiCall(){
    
    var aParams: NSDictionary = NSDictionary(objects: [self.auth_token[0],custxtFname.text,txtViewComment.text], forKeys: ["auth-token","feedback[name]","feedback[content]"])
    
    self.api.feedback(aParams as [NSObject : AnyObject], success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
      println(responseObject)
    self.txtViewComment.text = ""
    self.custxtFname.text = ""
      var alert: UIAlertView = UIAlertView(title: "Alert", message: "Your feedback hasbeen sent successfully.", delegate:self, cancelButtonTitle:"OK")
      alert.show()
      
      },
      failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
        println(error)
        var alert: UIAlertView = UIAlertView(title: "Alert", message: "Your feedback is not send successfully..", delegate:self, cancelButtonTitle:"OK")
        alert.show()
        
    })
    
  }


    
}
