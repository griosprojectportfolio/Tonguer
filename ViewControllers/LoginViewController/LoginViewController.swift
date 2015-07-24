//
//  LoginViewController.swift
//  Tonguer
//
//  Created by GrepRuby on 01/04/15.
//  Copyright (c) 2015 GrepRuby. All rights reserved.
//

import UIKit

class LoginViewController:BaseViewController,UITextFieldDelegate {

  var imgVwLogo : UIImageView!

  var btnLogin,btnForgotpass,btnSignup: UIButton!
  var api: AppApi!
  var actiIndecatorVw: ActivityIndicatorView!
  var custxtEmail,custxtPassword:CustomTextFieldBlurView!
  
  let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

  override func viewDidLoad() {
    super.viewDidLoad()
    self.defaultUIDesign()

    if (self.auth_token.count != 0) {
      var authToken:NSString = self.auth_token[0]
      if (authToken.length != 0) {
        var vc = self.storyboard?.instantiateViewControllerWithIdentifier("HomeID") as! HomeViewController
        self.navigationController?.pushViewController(vc, animated:false)
        return;
      }
    }
  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)

    api = AppApi.sharedClient()
  }

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    custxtEmail.text = ""
    custxtPassword.text = ""
  }

  func defaultUIDesign(){

    self.title = "User Login"
    self.navigationController?.navigationBar.barTintColor = UIColor(red: 52.0/255.0, green: 119.0/255.0, blue: 162.0/255.0, alpha: 1.0)
    self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]

    imgVwLogo = UIImageView()
    imgVwLogo.frame = CGRectMake((self.view.frame.size.width-150)/2,100,140,150);
    imgVwLogo.image = UIImage(named: "Splash.png")
    self.view.addSubview(imgVwLogo)

    var frameEmail:CGRect = CGRectMake(self.view.frame.origin.x+20,self.imgVwLogo.frame.size.height+124,self.view.frame.size.width-40, 40)

    if (custxtEmail != nil) {
      custxtEmail = nil
    }
    custxtEmail = CustomTextFieldBlurView(frame:frameEmail, imgName:"emailicon.png")
    custxtEmail.attributedPlaceholder = NSAttributedString(string:"Email",attributes:[NSForegroundColorAttributeName: UIColor(red: 66.0/255.0, green: 150.0/255.0, blue: 173.0/255.0,alpha:1.0)])
    //custxtEmail.returnKeyType = UIReturnType.Done
    custxtEmail.delegate = self;
    custxtEmail.text = ""
    custxtEmail.returnKeyType = UIReturnKeyType.Done
    custxtEmail.clearButtonMode = UITextFieldViewMode.Always
    custxtEmail.keyboardType = .EmailAddress
    custxtEmail.autocorrectionType = UITextAutocorrectionType.No
    self.view.addSubview(custxtEmail)

    
    if (custxtPassword != nil) {
      custxtPassword = nil
    }
    
    var framePass:CGRect = CGRectMake(frameEmail.origin.x, (frameEmail.origin.y + frameEmail.size.height)+20, frameEmail.size.width, frameEmail.size.height)
    custxtPassword = CustomTextFieldBlurView(frame:framePass, imgName:"passicon.png")
    custxtPassword.attributedPlaceholder = NSAttributedString(string:"Password",attributes:[NSForegroundColorAttributeName: UIColor(red: 66.0/255.0, green: 150.0/255.0, blue: 173.0/255.0,alpha:1.0)])
    // custxtEmail.returnKeyType = UIReturnType.Done
    custxtPassword.delegate = self;
    custxtPassword.text = ""
    custxtPassword.secureTextEntry = true
    custxtPassword.returnKeyType = UIReturnKeyType.Done
    custxtPassword.clearButtonMode = UITextFieldViewMode.Always
    self.view.addSubview(custxtPassword)
    
    btnSignup = UIButton()
    btnSignup.frame = CGRectMake(framePass.origin.x,framePass.origin.y+60,(framePass.size.width-5)/2,40)
    btnSignup.setTitle("SignUp", forState: UIControlState.Normal)
    btnSignup.backgroundColor = UIColor(red: 71.0/255.0, green: 168.0/255.0, blue: 184.0/255.0,alpha:1.0)
    btnSignup.tintColor = UIColor.whiteColor()
    btnSignup.addTarget(self, action:"signupButtonTapped", forControlEvents: UIControlEvents.TouchUpInside)
    self.view.addSubview(btnSignup)

    btnLogin = UIButton()
    btnLogin.frame = CGRectMake(self.btnSignup.frame.size.width+25,self.btnSignup.frame.origin.y,self.btnSignup.frame.size.width,40)
    btnLogin.setTitle("Login", forState: UIControlState.Normal)
    btnLogin.backgroundColor = UIColor(red: 237.0/255.0, green: 62.0/255.0, blue: 61.0/255.0,alpha:1.0)
    btnLogin.tintColor = UIColor.whiteColor()
    btnLogin.addTarget(self, action: "loginButtonTapped", forControlEvents: UIControlEvents.TouchUpInside)
    self.view.addSubview(btnLogin)

    btnForgotpass = UIButton(frame: CGRectMake((self.view.frame.size.width-150),self.view.frame.size.height-50, 150, 40))
    btnForgotpass.setTitle("Forgotpassword?", forState: UIControlState.Normal)
    // btnForgotpass.backgroundColor = UIColor(red: 237.0/255.0, green: 62.0/255.0, blue: 61.0/255.0,alpha:1.0)
    btnForgotpass.setTitleColor(UIColor(red: 66.0/255.0, green: 150.0/255.0, blue: 173.0/255.0,alpha:1.0), forState: UIControlState.Normal)
    btnForgotpass.addTarget(self, action: "forgotpassButtonTapped", forControlEvents: UIControlEvents.TouchUpInside)
    self.view.addSubview(btnForgotpass)

  }
  
  func textFieldDidBeginEditing(textField: UITextField) {
    
    var frame:CGRect = self.view.frame
    frame.origin.y = frame.origin.y - 40
    self.view.frame = frame
  }

  func textFieldDidEndEditing(textField: UITextField) {
    
    var frame:CGRect = self.view.frame
    frame.origin.y = frame.origin.y + 40
    self.view.frame = frame
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    
    textField.resignFirstResponder()
    return false
  }

  func signupButtonTapped(){
    var vc = self.storyboard?.instantiateViewControllerWithIdentifier("RagistrationID") as!RagistrationViewController
    self.navigationController?.pushViewController(vc, animated: true)
  }

  func loginButtonTapped(){

    if custxtEmail.text.isEmpty  {
      self.stringisEmpty(custxtEmail.text, placeholder:"email")
      return
    }
 
    if custxtPassword.text.isEmpty  {
      self.stringisEmpty(custxtEmail.text, placeholder:"password")
      return
    }
    self.view.endEditing(true)
    if(CommonUtilities.checkNetconnection()){
      self.loginApiCall()
    }else{
      var alertVw:UIAlertView = UIAlertView(title:"Alert", message:"Please check your netconection.", delegate: nil, cancelButtonTitle:"OK")
      alertVw.show()
    }
  }

  func forgotpassButtonTapped(){
    var vc = self.storyboard?.instantiateViewControllerWithIdentifier("ForgotpassID") as! ForgotpasswordViewController
    self.navigationController?.pushViewController(vc, animated: true)
  }

  func stringisEmpty(string:String, placeholder:String) {
    var message:String = "Please enter " + placeholder + "."
    var alertVw:UIAlertView = UIAlertView(title:"Alert", message:message, delegate: nil, cancelButtonTitle:"OK")
    alertVw.show()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    
  }

  func loginApiCall(){
    
  let strDeviceToken = appDelegate.deviceTokenString
   
   // var aParams: NSDictionary = ["user[email]" : custxtEmail.text, "user[password]" : custxtPassword.text,"user[device_token]":strDeviceToken]
     var aParams: NSDictionary = ["user[email]" : custxtEmail.text, "user[password]" : custxtPassword.text]

    actiIndecatorVw = ActivityIndicatorView(frame: self.view.frame)
    self.view.addSubview(actiIndecatorVw)

    self.api.loginUser(aParams as [NSObject : AnyObject], success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in

        println(responseObject)
        var dict: NSDictionary! = responseObject?.objectForKey("data") as! NSDictionary
        var aParam: NSDictionary = responseObject?.objectForKey("user") as! NSDictionary

        self.auth_token = [dict.objectForKey("auth_token") as! NSString];
        CommonUtilities.addUserInformation(aParam)

      self.getFreeClassApiCall()
      self.getPayClassApiCall()
      self.userClassApiCall()
      self.userLearnClsApiCall()
      self.userLearnedClsApiCall()
      self.getHostPayClsApiCall()
      self.getAddvertiesmentApiCall()
      self.abouUSApiCall()
      self.adminContactApi()
      },
      failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
        println(operation?.responseObject)
        self.actiIndecatorVw.removeFromSuperview()
        self.loginValidation()
    })


  }


  func delay(delay:Double, closure:()->()) {
    dispatch_after(
      dispatch_time(
        DISPATCH_TIME_NOW,
        Int64(delay * Double(NSEC_PER_SEC))
      ),
      dispatch_get_main_queue(), closure)
  }


  func loginValidation(){

    if(custxtEmail.text == "" && custxtPassword.text == ""){
      var alert: UIAlertView! = UIAlertView(title: "Alert", message: "Enter a email and password.", delegate: self, cancelButtonTitle: "Ok")
      alert.show()
    }else{

      var alert: UIAlertView! = UIAlertView(title: "Alert", message: "Some error check email and password.", delegate: self, cancelButtonTitle: "Ok")
      alert.show()

    }
  }

  //************ Data Store in the Database And Api Calling Methodes****************
  
  func adminContactApi(){
    
    var aParams: NSDictionary = NSDictionary(objects: self.auth_token, forKeys: ["auth-token"])
    
    self.api.getAdminContact(nil, success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
      println(responseObject)
      },
      failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
        println(error)
        
    })
    
  }
  
  
  func abouUSApiCall(){
    
    var aParams: NSDictionary = NSDictionary(objects: self.auth_token, forKeys: ["auth-token"])
    
    self.api.aboutUS(nil, success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
      println(responseObject)
      },
      failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
        println(error)
        
    })
    
  }
  

  func userClassApiCall(){

    var aParams: NSDictionary = NSDictionary(objects: self.auth_token, forKeys: ["auth-token"])

    self.api.userDefaultCls(aParams as [NSObject : AnyObject], success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
      println(responseObject)
      
      },
      failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
        println(error)

    })

  }

  func userLearnClsApiCall(){

    var aParams: NSDictionary = NSDictionary(objects: self.auth_token, forKeys: ["auth-token"])

    self.api.userLearnCls(aParams as [NSObject : AnyObject], success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
      println(responseObject)
      

      },
      failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
        println(error)

    })

  }

  func userLearnedClsApiCall(){

    var aParams: NSDictionary = NSDictionary(objects: self.auth_token, forKeys: ["auth-token"])

    self.api.userLearnedCls(aParams as [NSObject : AnyObject], success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
      println(responseObject)
      

      },
      failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
        println(error)

    })
  }


  func getFreeClassApiCall(){

    var aParams: NSDictionary = ["auth-token":auth_token[0]]
    self.api.freeClass(aParams as [NSObject : AnyObject], success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
      println(responseObject)
      },
      failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
        println(error)
    })

  }

  func getPayClassApiCall(){

    var aParams: NSDictionary = ["auth-token":auth_token[0]]
    self.api.payClass(aParams as [NSObject : AnyObject], success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
      println(responseObject)
      },
      failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
        println(error)

    })

  }

  func getHostPayClsApiCall(){

    var aParams: NSDictionary = ["auth-token":auth_token[0]]
    self.api.hostpayClass(aParams as [NSObject : AnyObject], success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
      println(responseObject)
      
      self.delay(4, closure: { () -> () in

        self.actiIndecatorVw.loadingIndicator.stopAnimating()
        self.actiIndecatorVw.removeFromSuperview()
        var vc = self.storyboard?.instantiateViewControllerWithIdentifier("HomeID") as! HomeViewController
        self.navigationController?.pushViewController(vc, animated: true)
      })
      },
      failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
        println(error)
        self.delay(4, closure: { () -> () in
          
          self.actiIndecatorVw.loadingIndicator.stopAnimating()
          self.actiIndecatorVw.removeFromSuperview()
          var vc = self.storyboard?.instantiateViewControllerWithIdentifier("HomeID") as! HomeViewController
          self.navigationController?.pushViewController(vc, animated: true)
        })

    })
  }
  
  func getAddvertiesmentApiCall(){
    
    var aParams: NSDictionary = ["auth-token":auth_token[0]]
    self.api.addvertiesment(aParams as [NSObject : AnyObject], success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
      println(responseObject)
      let arry = responseObject as! NSArray
      
      },
      failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
        println(error)
        
    })
    
  }

  
  
}
