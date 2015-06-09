//
//  AddTopicViewController.swift
//  Tonguer
//
//  Created by GrepRuby on 30/04/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import UIKit

class AddTopicViewController: BaseViewController,UITextFieldDelegate,UITextViewDelegate{
  
  var barBackBtn :UIBarButtonItem!
  var txtTitle: CustomTextFieldBlurView!
  var txtVwContent: UITextView!
  var lblTxtVwPlace: UILabel!
  var classID: NSInteger!
  var api: AppApi!
  override func viewDidLoad() {
    super.viewDidLoad()
    api = AppApi.sharedClient()
    print(classID)
    self.defaultUIDesign()
    
    }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func defaultUIDesign(){
    
    self.title = "Add Topic"
    
    self.navigationItem.setHidesBackButton(true, animated:false)
    
    var backbtn:UIButton = UIButton(frame: CGRectMake(0, 0,25,25))
    backbtn.setImage(UIImage(named: "whiteback.png"), forState: UIControlState.Normal)
    backbtn.addTarget(self, action: "btnBackTapped", forControlEvents: UIControlEvents.TouchUpInside)
    
    barBackBtn = UIBarButtonItem(customView: backbtn)
    self.navigationItem.setLeftBarButtonItem(barBackBtn, animated: true)
    
    var btnBarPost: UIBarButtonItem! = UIBarButtonItem(title: "Add", style: UIBarButtonItemStyle.Plain, target: self, action: "btnBarPostTapped:")
    btnBarPost.tintColor = UIColor.whiteColor()
    
    self.navigationItem.setRightBarButtonItem(btnBarPost, animated: true)
    
    var frameTitle:CGRect = CGRectMake(self.view.frame.origin.x+10,self.view.frame.origin.y+84, self.view.frame.width-20, 40)

    txtTitle = CustomTextFieldBlurView(frame:frameTitle, imgName:"")
    txtTitle.attributedPlaceholder = NSAttributedString(string:"Title",attributes:[NSForegroundColorAttributeName: UIColor(red: 66.0/255.0, green: 150.0/255.0, blue: 173.0/255.0,alpha:1.0)])
    //custxtEmail.returnKeyType = UIReturnType.Done
    txtTitle.delegate = self;
    txtTitle.returnKeyType = UIReturnKeyType.Done
    txtTitle.clearButtonMode = UITextFieldViewMode.Always
    self.view.addSubview(txtTitle)
    
    txtVwContent = UITextView(frame: CGRectMake(txtTitle.frame.origin.x,txtTitle.frame.origin.y+txtTitle.frame.height+20, txtTitle.frame.width, 150))
    txtVwContent.delegate = self
    txtVwContent.layer.borderWidth = 1
    txtVwContent.layer.borderColor = UIColor(red: 71.0/255.0, green: 168.0/255.0, blue: 184.0/255.0,alpha:1.0).CGColor
    self.view.addSubview(txtVwContent)
    
    lblTxtVwPlace = UILabel(frame: CGRectMake((self.txtVwContent.frame.width-200)/2,(self.txtVwContent.frame.height-30)/2,200, 30))
    //lblTxtVwPlace.backgroundColor = UIColor.redColor()
    lblTxtVwPlace.text = "Fill the Content"
    lblTxtVwPlace.textAlignment = NSTextAlignment.Center
    lblTxtVwPlace.font = lblTxtVwPlace.font.fontWithSize(12)
    lblTxtVwPlace.textColor = UIColor(red: 71.0/255.0, green: 168.0/255.0, blue: 184.0/255.0,alpha:1.0)
    txtVwContent.addSubview(lblTxtVwPlace)

  }
  
  func btnBackTapped(){
    self.navigationController?.popViewControllerAnimated(true)
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return false
  }
  
  func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
    
    if(text == "\n"){
      textView.resignFirstResponder()
      return false
    }
    return true
  }
  
  func textViewShouldBeginEditing(textView: UITextView) -> Bool {
    lblTxtVwPlace.hidden = true
    return true
  }
  
  func btnBarPostTapped(sender:AnyObject){
    self.postCreateNewTopicApi()
    
  }

  //************* Create New toic Api Call**************
  
  func postCreateNewTopicApi(){
    
    var aParams: NSMutableDictionary! = NSMutableDictionary()
    aParams.setValue(auth_token[0], forKey: "auth_token")
    aParams.setValue(classID, forKey: "class_id")
    aParams.setValue(txtTitle.text, forKey:"topic[title]")
    aParams.setValue(txtVwContent.text, forKey:"topic[content]")
    self.api.createClassTopic(aParams, success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
      println(responseObject)
      self.navigationController?.popViewControllerAnimated(true)
      },
      failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
        println(error)
        
    })
    
  }

  
  
  
}
