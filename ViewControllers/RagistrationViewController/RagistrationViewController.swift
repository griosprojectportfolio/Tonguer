//
//  RagistrationViewController.swift
//  Tonguer
//
//  Created by GrepRuby on 02/04/15.
//  Copyright (c) 2015 GrepRuby. All rights reserved.
//

import UIKit

class RagistrationViewController: BaseViewController,UITextFieldDelegate {
  
  var scrollview : UIScrollView!
  var imgVwLogo : UIImageView!
  var btnSignUp : UIButton!
  var barBackBtn :UIBarButtonItem!
  var actiIndecatorVw: ActivityIndicatorView!
  var api: AppApi!
  var custxtEmail,custxtPassword,custxtFname,custxtLname,custxtConpass,custxtDOB:CustomTextFieldBlurView!
  let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
      
      api = AppApi.sharedClient()
        self.defaultUIDesign()
     
      }
  
  func defaultUIDesign(){
    
    self.title = "User Registration"
    
   self.navigationItem.setHidesBackButton(true, animated:false)
    
    var backbtn:UIButton = UIButton(frame: CGRectMake(0, 0,25,25))
        backbtn.setImage(UIImage(named: "whiteback.png"), forState: UIControlState.Normal)
        backbtn.addTarget(self, action: "btnBackTapped", forControlEvents: UIControlEvents.TouchUpInside)
    
    barBackBtn = UIBarButtonItem(customView: backbtn)
    
    self.navigationItem.setLeftBarButtonItem(barBackBtn, animated: true)
    
    scrollview = UIScrollView(frame: CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y+64, self.view.frame.width, self.view.frame.height))
    //scrollview.backgroundColor = UIColor.grayColor()
    scrollview.userInteractionEnabled = true
    scrollview.contentSize = CGSize(width: self.view.frame.width, height:self.view.frame.height+100)
    self.view.addSubview(scrollview)
    
    imgVwLogo = UIImageView()
    imgVwLogo.frame = CGRectMake((scrollview.frame.size.width-100)/2,10, 100, 100)
    imgVwLogo.image = UIImage(named: "Splash.png")
    scrollview.addSubview(imgVwLogo)

    
    var framefname:CGRect = CGRectMake(scrollview.frame.origin.x+20, self.imgVwLogo.frame.origin.y+120, scrollview.frame.size.width-40, 40)
    custxtFname = CustomTextFieldBlurView(frame:framefname, imgName:"user.png")
    custxtFname.attributedPlaceholder = NSAttributedString(string:"First Name",attributes:[NSForegroundColorAttributeName: UIColor(red: 66.0/255.0, green: 150.0/255.0, blue: 173.0/255.0,alpha:1.0)])
    custxtFname.delegate = self;
    custxtFname.returnKeyType = UIReturnKeyType.Next
    custxtFname.clearButtonMode = UITextFieldViewMode.Always
    scrollview.addSubview(custxtFname)
    
    var framelname:CGRect = CGRectMake(framefname.origin.x,framefname.origin.y+framefname.size.height+10, framefname.size.width,framefname.size.height)
    custxtLname = CustomTextFieldBlurView(frame:framelname, imgName:"user.png")
    custxtLname.attributedPlaceholder = NSAttributedString(string:"Last Name",attributes:[NSForegroundColorAttributeName: UIColor(red: 66.0/255.0, green: 150.0/255.0, blue: 173.0/255.0,alpha:1.0)])
    custxtLname.delegate = self;
    custxtLname.returnKeyType = UIReturnKeyType.Next
    custxtLname.clearButtonMode = UITextFieldViewMode.Always
    scrollview.addSubview(custxtLname)
    
    var frameEmail:CGRect = CGRectMake(framelname.origin.x,framelname.origin.y+framelname.size.height+10, framelname.width, framelname.height)
    custxtEmail = CustomTextFieldBlurView(frame:frameEmail, imgName:"emailicon.png")
    custxtEmail.attributedPlaceholder = NSAttributedString(string:"Email",attributes:[NSForegroundColorAttributeName: UIColor(red: 66.0/255.0, green: 150.0/255.0, blue: 173.0/255.0,alpha:1.0)])
    custxtEmail.delegate = self;
    custxtEmail.returnKeyType = UIReturnKeyType.Next
    custxtEmail.clearButtonMode = UITextFieldViewMode.Always
    custxtEmail.keyboardType = .EmailAddress
    scrollview.addSubview(custxtEmail)
    
    var framePass:CGRect = CGRectMake(frameEmail.origin.x,frameEmail.origin.y+frameEmail.height+10,frameEmail.width, frameEmail.height)
    custxtPassword = CustomTextFieldBlurView(frame:framePass, imgName:"passicon.png")
    custxtPassword.attributedPlaceholder = NSAttributedString(string:"Password",attributes:[NSForegroundColorAttributeName: UIColor(red: 66.0/255.0, green: 150.0/255.0, blue: 173.0/255.0,alpha:1.0)])
    custxtPassword.delegate = self;
    custxtPassword.returnKeyType = UIReturnKeyType.Next
    custxtPassword.secureTextEntry = true
    custxtPassword.clearButtonMode = UITextFieldViewMode.Always
   scrollview.addSubview(custxtPassword)

    var frameConPass:CGRect = CGRectMake(framePass.origin.x, framePass.origin.y+framePass.height+10, framePass.width, framePass.height)
    custxtConpass = CustomTextFieldBlurView(frame:frameConPass, imgName:"passicon.png")
    custxtConpass.attributedPlaceholder = NSAttributedString(string:"Confirm Password",attributes:[NSForegroundColorAttributeName: UIColor(red: 66.0/255.0, green: 150.0/255.0, blue: 173.0/255.0,alpha:1.0)])
    custxtConpass.delegate = self;
    custxtConpass.returnKeyType = UIReturnKeyType.Done
    custxtConpass.secureTextEntry = true
    custxtConpass.clearButtonMode = UITextFieldViewMode.Always
   scrollview.addSubview(custxtConpass)
    
    var framedob:CGRect = CGRectMake(frameConPass.origin.x,frameConPass.origin.y+frameConPass.height+10, frameConPass.width, frameConPass.height)
    custxtDOB = CustomTextFieldBlurView(frame:framedob, imgName:"calander.png")
    custxtDOB.attributedPlaceholder = NSAttributedString(string:"DOB",attributes:[NSForegroundColorAttributeName: UIColor(red: 66.0/255.0, green: 150.0/255.0, blue: 173.0/255.0,alpha:1.0)])
    custxtDOB.delegate = self;
    custxtDOB.returnKeyType = UIReturnKeyType.Done
    custxtDOB.clearButtonMode = UITextFieldViewMode.Always
    scrollview.addSubview(custxtDOB)
    
    btnSignUp = UIButton()
    btnSignUp.frame = CGRectMake(self.custxtDOB.frame.origin.x,(self.custxtDOB.frame.origin.y), self.custxtDOB.frame.size.width, 40)
    btnSignUp.setTitle("SignUp", forState: UIControlState.Normal)
    btnSignUp.backgroundColor = UIColor(red: 237.0/255.0, green: 62.0/255.0, blue: 61.0/255.0,alpha:1.0)
    btnSignUp.tintColor = UIColor.whiteColor()
    btnSignUp.addTarget(self, action: "btnSignupTapped", forControlEvents: UIControlEvents.TouchUpInside)
    scrollview.addSubview(btnSignUp)
  }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  func btnBackTapped(){
    self.navigationController?.popViewControllerAnimated(true)
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    scrollview.contentOffset = CGPoint(x: 0, y: 0)
    textField.resignFirstResponder()
    return false
  }
  
  func textFieldDidBeginEditing(textField: UITextField) {
    scrollview.contentOffset = CGPoint(x: 0, y: 80)
  }
  
  
  func btnSignupTapped(){
    signUpValidation()
  }
  
  func signupApiCall(){
    let strDeviceToken = appDelegate.deviceTokenString
    
    var dict: NSMutableDictionary = NSMutableDictionary()
    dict.setObject(custxtEmail.text, forKey:"email")
    dict.setObject(custxtFname.text, forKey:"first_name")
    dict.setObject(custxtLname.text, forKey:"last_name")
    dict.setObject(custxtPassword.text, forKey:"password")
    dict.setObject(custxtConpass.text, forKey:"password_confirmation")
    dict.setObject(strDeviceToken, forKey:"device_token")
    
    var aParam: NSMutableDictionary = NSMutableDictionary()
    aParam.setObject(dict, forKey: "user")
    println(aParam)
    
    actiIndecatorVw = ActivityIndicatorView(frame:CGRectMake(0, 0,self.view.frame.width,self.view.frame.height))
    self.view.addSubview(actiIndecatorVw)
    
    api.signUpUser(aParam as [NSObject : AnyObject], success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
      println(responseObject)
      var dict: NSDictionary! = responseObject?.objectForKey("data") as! NSDictionary
      var aParam: NSDictionary = responseObject?.objectForKey("user") as! NSDictionary
      CommonUtilities.addUserInformation(aParam)
      var auth_token: NSString! = dict.objectForKey("auth_token") as! NSString
      self.auth_token = [auth_token]
      self.actiIndecatorVw.removeFromSuperview()
      var vc = self.storyboard?.instantiateViewControllerWithIdentifier("HomeID") as! HomeViewController
      self.navigationController?.pushViewController(vc, animated: true)
      },
      failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
        println(error)
        self.actiIndecatorVw.removeFromSuperview()
        var alert: UIAlertView! = UIAlertView(title: "Alert", message: "Don't Left any feild.", delegate: self, cancelButtonTitle: "Ok")
        alert.show()
    })
  }
  
  
  
  func signUpValidation(){
    
    var strPawword = custxtPassword.text as NSString
    var strPawwordCnf = custxtConpass.text as NSString
    
    if(custxtEmail.text == "" || custxtPassword.text == "" || custxtFname.text == "" || custxtLname.text == "" || custxtConpass.text == ""){
      var alert: UIAlertView! = UIAlertView(title: "Alert", message: "Don't Left any feild.", delegate: self, cancelButtonTitle: "Ok")
      alert.show()
      return
    }
    
    if(strPawword.length<8){
      var alert: UIAlertView! = UIAlertView(title: "Alert", message: "Password is too short (minimum is 8 characters).", delegate: self, cancelButtonTitle: "Ok")
      alert.show()
      return
    }
    
    if(strPawword != strPawwordCnf){
      var alert: UIAlertView! = UIAlertView(title: "Alert", message: "Password does't match.", delegate: self, cancelButtonTitle: "Ok")
      alert.show()
      return
    }
    var isValid = isValidEmail(custxtEmail.text)
    if(isValid){
      
    }else{
      var alert: UIAlertView! = UIAlertView(title: "Alert", message: "Please enter a valid email address.", delegate: self, cancelButtonTitle: "Ok")
      alert.show()
      return
    }

    self.signupApiCall()
  }
  
  func isValidEmail(testStr : String) -> Bool {
    println("validate calendar: \(testStr)")
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
    
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    
    if emailTest.evaluateWithObject(testStr) {
      return true
    }
    return false
  }
  
//    func isValidEmail(testStr:String) -> Bool {
//    println("validate calendar: \(testStr)")
//      
//      let emailRegEx = "^[a-zA-Z0-9.!#$%&'+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)$"
//    
//    if let emailTest = NSPredicate(format:"SELF MATCHES %@",emailRegEx){
//      return emailTest.evaluateWithObject(testStr)
//    }
//    return false
//  }
  
}
