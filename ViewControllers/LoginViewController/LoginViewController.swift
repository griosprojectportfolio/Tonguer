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

  var btnLogin : UIButton!
  var btnSignup : UIButton!

  var btnForgotpass : UIButton!

  var api: AppApi!
  var actiIndecatorVw: ActivityIndicatorView!
  var custxtEmail:CustomTextFieldBlurView!
  var custxtPassword:CustomTextFieldBlurView!

  override func viewDidLoad() {
    super.viewDidLoad()

    if (self.auth_token.count != 0) {
      var authToken:NSString = self.auth_token[0]
      if (authToken.length != 0) {
        var vc = self.storyboard?.instantiateViewControllerWithIdentifier("HomeID") as HomeViewController
        self.navigationController?.pushViewController(vc, animated:false)
        return;
      }
    }
  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)

    api = AppApi.sharedClient()
    self.defaultUIDesign()
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

    custxtEmail = CustomTextFieldBlurView(frame:frameEmail, imgName:"emailicon.png")
    custxtEmail.attributedPlaceholder = NSAttributedString(string:"Email",attributes:[NSForegroundColorAttributeName: UIColor(red: 66.0/255.0, green: 150.0/255.0, blue: 173.0/255.0,alpha:1.0)])
    //custxtEmail.returnKeyType = UIReturnType.Done
    custxtEmail.delegate = self;
    custxtEmail.returnKeyType = UIReturnKeyType.Done
    custxtEmail.clearButtonMode = UITextFieldViewMode.Always
    custxtEmail.keyboardType = .EmailAddress
    self.view.addSubview(custxtEmail)

    var framePass:CGRect = CGRectMake(frameEmail.origin.x, (frameEmail.origin.y + frameEmail.size.height)+20, frameEmail.size.width, frameEmail.size.height)
    custxtPassword = CustomTextFieldBlurView(frame:framePass, imgName:"passicon.png")
    custxtPassword.attributedPlaceholder = NSAttributedString(string:"Password",attributes:[NSForegroundColorAttributeName: UIColor(red: 66.0/255.0, green: 150.0/255.0, blue: 173.0/255.0,alpha:1.0)])
    // custxtEmail.returnKeyType = UIReturnType.Done
    custxtPassword.delegate = self;
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

  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return false
  }

  func signupButtonTapped(){
    var vc = self.storyboard?.instantiateViewControllerWithIdentifier("RagistrationID") as RagistrationViewController
    self.navigationController?.pushViewController(vc, animated: true)
  }

  func loginButtonTapped(){

    self.view.endEditing(true)
    self.loginApiCall()
  }

  func forgotpassButtonTapped(){
    var vc = self.storyboard?.instantiateViewControllerWithIdentifier("ForgotpassID") as ForgotpasswordViewController
    self.navigationController?.pushViewController(vc, animated: true)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  func loginApiCall(){
    //var aParams: NSDictionary = ["user[email]" : custxtEmail.text, "user[password]" : custxtPassword.text]

    var aParams: NSDictionary = ["user[email]" : "ajulwania@grepruby.com", "user[password]" : "arun123456"]

    actiIndecatorVw = ActivityIndicatorView(frame: self.view.frame)
    self.view.addSubview(actiIndecatorVw)

    self.api.loginUser(aParams, success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in

      println(responseObject)
      var dict: NSDictionary! = responseObject?.objectForKey("data") as NSDictionary
      var aParam: NSDictionary! = responseObject?.objectForKey("user") as NSDictionary

      self.auth_token = [dict.objectForKey("auth_token") as NSString];


      self.getFreeClassApiCall()
      self.getPayClassApiCall()
      self.userClassApiCall()
      self.userLearnClsApiCall()
      self.userLearnedClsApiCall()
      self.getHostPayClsApiCall()
      self.getAddvertiesmentApiCall()
      },
      failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
        println(error)
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
      var alert: UIAlertView! = UIAlertView(title: "Alert", message: "Enter a Email and Password", delegate: self, cancelButtonTitle: "Ok")
      alert.show()
    }else{

      var alert: UIAlertView! = UIAlertView(title: "Alert", message: "Some Error Chake Email and Password", delegate: self, cancelButtonTitle: "Ok")
      alert.show()

    }
  }

  //************ Data Store in the Database And Api Calling Methodes****************

  func userClassApiCall(){

    var aParams: NSDictionary = NSDictionary(objects: self.auth_token, forKeys: ["auth_token"])

    self.api.userDefaultCls(aParams, success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
      println(responseObject)
      var aParam: NSDictionary! = responseObject?.objectForKey("data") as NSDictionary
      },
      failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
        println(error)

    })

  }

  func userLearnClsApiCall(){

    var aParams: NSDictionary = NSDictionary(objects: self.auth_token, forKeys: ["auth_token"])

    self.api.userLearnCls(aParams, success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
      println(responseObject)
      var aParam: NSDictionary! = responseObject?.objectForKey("data") as NSDictionary

      },
      failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
        println(error)

    })

  }

  func userLearnedClsApiCall(){

    var aParams: NSDictionary = NSDictionary(objects: self.auth_token, forKeys: ["auth_token"])

    self.api.userLearnedCls(aParams, success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
      println(responseObject)
      var aParam: NSDictionary! = responseObject?.objectForKey("data") as NSDictionary

      },
      failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
        println(error)

    })
  }


  func getFreeClassApiCall(){

    var aParams: NSDictionary = ["auth_token":auth_token[0]]
    self.api.freeClass(aParams, success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
      println(responseObject)
      },
      failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
        println(error)
    })

  }

  func getPayClassApiCall(){

    var aParams: NSDictionary = ["auth_token":auth_token[0]]
    self.api.payClass(aParams, success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
      println(responseObject)
      },
      failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
        println(error)

    })

  }

  func getHostPayClsApiCall(){

    var aParams: NSDictionary = ["auth_token":auth_token[0]]
    self.api.hostpayClass(aParams, success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
      println(responseObject)
      var aParam: NSDictionary! = responseObject?.objectForKey("data") as NSDictionary
      //self.haderArr =  aParam.objectForKey("category") as NSMutableArray
      //self.hometableVw.reloadData()

      self.delay(4, closure: { () -> () in

        self.actiIndecatorVw.loadingIndicator.stopAnimating()
        self.actiIndecatorVw.removeFromSuperview()
        var vc = self.storyboard?.instantiateViewControllerWithIdentifier("HomeID") as HomeViewController
        self.navigationController?.pushViewController(vc, animated: true)
      })
      },
      failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
        println(error)

    })
  }
  
  func getAddvertiesmentApiCall(){
    
    var aParams: NSDictionary = ["auth_token":auth_token[0]] //NSDictionary(objects: [auth_token], forKeys: ["auth_token"])
    
    self.api.addvertiesment(aParams, success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
      println(responseObject)
      let arry = responseObject as NSArray
      
      },
      failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
        println(error)
        
    })
    
  }

  
  
}
