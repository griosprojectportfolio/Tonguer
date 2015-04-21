//
//  LoginViewController.swift
//  Tonguer
//
//  Created by GrepRuby on 01/04/15.
//  Copyright (c) 2015 GrepRuby. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController,UITextFieldDelegate {
  
   var imgVwLogo : UIImageView!
  @IBOutlet weak var txtFieldEmail : UITextField!
   var txtFieldPassword : UITextField!
  
   var btnLogin : UIButton!
   var btnSignup : UIButton!
  
  var btnForgotpass : UIButton!
  
  var api: AppApi!
  
  var custxtEmail:CustomTextFieldBlurView!
  var custxtPassword:CustomTextFieldBlurView!

    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    btnForgotpass = UIButton(frame: CGRectMake((self.view.frame.size.width-150), self.btnLogin.frame.origin.y+100, 150, 40))
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
//    var vc = self.storyboard?.instantiateViewControllerWithIdentifier("HomeID") as HomeViewController
//    self.navigationController?.pushViewController(vc, animated: true)
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
    var aParams: NSDictionary = ["user[email]" : custxtEmail.text, "user[password]" : custxtPassword.text]
    
    self.api.loginUser(aParams, success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
      println(responseObject)
      var dict: NSDictionary! = responseObject?.objectForKey("data") as NSDictionary
     var auth_token: NSString! = dict.objectForKey("auth_token") as NSString
      self.apiDataAccess(auth_token)
      },
      failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
        println(error)
        self.loginValidation()
    })
    
    }
  
  func apiDataAccess(token:NSString){
    println(token)
    var vc = self.storyboard?.instantiateViewControllerWithIdentifier("HomeID") as HomeViewController
    vc.authToken = token
    self.navigationController?.pushViewController(vc, animated: true)
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
  
  
}
