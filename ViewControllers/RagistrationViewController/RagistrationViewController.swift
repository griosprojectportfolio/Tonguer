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
  
  var api: AppApi!
  
  var custxtEmail:CustomTextFieldBlurView!
  var custxtPassword:CustomTextFieldBlurView!
  var custxtFname:CustomTextFieldBlurView!
  var custxtLname:CustomTextFieldBlurView!
  var custxtConpass:CustomTextFieldBlurView!
  var custxtDOB:CustomTextFieldBlurView!

    override func viewDidLoad() {
        super.viewDidLoad()
      
      api = AppApi.sharedClient()
        self.defaultUIDesign()
     
      }
  
  func defaultUIDesign(){
    
    self.title = "User Registration"
    self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
    
   self.navigationItem.setHidesBackButton(true, animated:false)
    
    var backbtn:UIButton = UIButton(frame: CGRectMake(0, 0,25,25))
        backbtn.setImage(UIImage(named: "back.png"), forState: UIControlState.Normal)
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
    // custxtEmail.returnKeyType = UIReturnType.Done
    custxtFname.delegate = self;
    custxtFname.returnKeyType = UIReturnKeyType.Done
    custxtFname.clearButtonMode = UITextFieldViewMode.Always
    custxtFname.keyboardType = .EmailAddress
    scrollview.addSubview(custxtFname)
    
    var framelname:CGRect = CGRectMake(framefname.origin.x,framefname.origin.y+framefname.size.height+10, framefname.size.width,framefname.size.height)
    custxtLname = CustomTextFieldBlurView(frame:framelname, imgName:"user.png")
    custxtLname.attributedPlaceholder = NSAttributedString(string:"Last Name",attributes:[NSForegroundColorAttributeName: UIColor(red: 66.0/255.0, green: 150.0/255.0, blue: 173.0/255.0,alpha:1.0)])
    // custxtEmail.returnKeyType = UIReturnType.Done
    custxtLname.delegate = self;
    custxtLname.returnKeyType = UIReturnKeyType.Done
    custxtLname.clearButtonMode = UITextFieldViewMode.Always
    custxtLname.keyboardType = .EmailAddress
    scrollview.addSubview(custxtLname)
    
    var frameEmail:CGRect = CGRectMake(framelname.origin.x,framelname.origin.y+framelname.size.height+10, framelname.width, framelname.height)
    custxtEmail = CustomTextFieldBlurView(frame:frameEmail, imgName:"emailicon.png")
    custxtEmail.attributedPlaceholder = NSAttributedString(string:"Email",attributes:[NSForegroundColorAttributeName: UIColor(red: 66.0/255.0, green: 150.0/255.0, blue: 173.0/255.0,alpha:1.0)])
    // custxtEmail.returnKeyType = UIReturnType.Done
    custxtEmail.delegate = self;
    custxtEmail.returnKeyType = UIReturnKeyType.Done
    custxtEmail.clearButtonMode = UITextFieldViewMode.Always
    custxtEmail.keyboardType = .EmailAddress
    scrollview.addSubview(custxtEmail)
    
    var framePass:CGRect = CGRectMake(frameEmail.origin.x,frameEmail.origin.y+frameEmail.height+10,frameEmail.width, frameEmail.height)
    custxtPassword = CustomTextFieldBlurView(frame:framePass, imgName:"passicon.png")
    custxtPassword.attributedPlaceholder = NSAttributedString(string:"Password",attributes:[NSForegroundColorAttributeName: UIColor(red: 66.0/255.0, green: 150.0/255.0, blue: 173.0/255.0,alpha:1.0)])
    // custxtEmail.returnKeyType = UIReturnType.Done
    custxtPassword.delegate = self;
    custxtPassword.returnKeyType = UIReturnKeyType.Done
    custxtPassword.secureTextEntry = true
    custxtPassword.clearButtonMode = UITextFieldViewMode.Always
   scrollview.addSubview(custxtPassword)

    var frameConPass:CGRect = CGRectMake(framePass.origin.x, framePass.origin.y+framePass.height+10, framePass.width, framePass.height)
    custxtConpass = CustomTextFieldBlurView(frame:frameConPass, imgName:"passicon.png")
    custxtConpass.attributedPlaceholder = NSAttributedString(string:"Confirm Password",attributes:[NSForegroundColorAttributeName: UIColor(red: 66.0/255.0, green: 150.0/255.0, blue: 173.0/255.0,alpha:1.0)])
    // custxtEmail.returnKeyType = UIReturnType.Done
    custxtConpass.delegate = self;
    custxtConpass.returnKeyType = UIReturnKeyType.Done
    custxtConpass.secureTextEntry = true
    custxtConpass.clearButtonMode = UITextFieldViewMode.Always
   scrollview.addSubview(custxtConpass)
    
    var framedob:CGRect = CGRectMake(frameConPass.origin.x,frameConPass.origin.y+frameConPass.height+10, frameConPass.width, frameConPass.height)
    custxtDOB = CustomTextFieldBlurView(frame:framedob, imgName:"calander.png")
    custxtDOB.attributedPlaceholder = NSAttributedString(string:"DOB",attributes:[NSForegroundColorAttributeName: UIColor(red: 66.0/255.0, green: 150.0/255.0, blue: 173.0/255.0,alpha:1.0)])
    // custxtEmail.returnKeyType = UIReturnType.Done
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
    
    self.signupApiCall()
  }
  
  func signupApiCall(){
    var dict: NSMutableDictionary! = NSMutableDictionary()
    dict.setObject(custxtEmail.text, forKey:"email")
    dict.setObject(custxtFname.text, forKey:"first_name")
    dict.setObject(custxtLname.text, forKey:"last_name")
    dict.setObject(custxtPassword.text, forKey:"password")
    dict.setObject(custxtConpass.text, forKey:"password_confirmation")
    
    var aParam: NSMutableDictionary! = NSMutableDictionary()
    aParam.setObject(dict, forKey: "user")

//var aParams1: NSDictionary = ["user[email]" : custxtEmail.text, "user[password]" : custxtPassword.text]
    
    println(aParam)
    
    api.signUpUser(aParam, success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
      println(responseObject)
      var dict: NSDictionary! = responseObject?.objectForKey("data") as NSDictionary
      var auth_token: NSString! = dict.objectForKey("auth_token") as NSString
      self.auth_token = [auth_token]
      var vc = self.storyboard?.instantiateViewControllerWithIdentifier("HomeID") as HomeViewController
      self.navigationController?.pushViewController(vc, animated: true)
      },
      failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
        println(error)
        self.signUpValidation()
    })

    
  }
  
  
  func signUpValidation(){
    if(custxtEmail.text == "" && custxtPassword.text == "" && custxtFname.text == "" && custxtLname.text == "" && custxtConpass.text == ""){
      var alert: UIAlertView! = UIAlertView(title: "Alert", message: "Don't Left any feild", delegate: self, cancelButtonTitle: "Ok")
      alert.show()
    }else{
      
      var alert: UIAlertView! = UIAlertView(title: "Alert", message: "Something Worng", delegate: self, cancelButtonTitle: "Ok")
      alert.show()
      
    }

  }
  
  
}
