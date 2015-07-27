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
  var toolBar: UIToolbar!
  var scrollVW: UIScrollView!
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
    
    scrollVW = UIScrollView(frame: CGRectMake(self.view.frame.origin.x,0, self.view.frame.size.width, self.view.frame.height))
    scrollVW.showsVerticalScrollIndicator = false
    //scrollVW.userInteractionEnabled = true
    //scrollVW.backgroundColor = UIColor.grayColor()
    if(self.isiPhone5orLower){
      scrollVW.contentSize = CGSize(width:0,height:500)
    }
    
    self.view.addSubview(scrollVW)
    
    var frameTitle:CGRect = CGRectMake(scrollVW.frame.origin.x+10,20,scrollVW.frame.width-20, 40)

    txtTitle = CustomTextFieldBlurView(frame:frameTitle, imgName:"")
    txtTitle.attributedPlaceholder = NSAttributedString(string:"Title",attributes:[NSForegroundColorAttributeName: UIColor(red: 66.0/255.0, green: 150.0/255.0, blue: 173.0/255.0,alpha:1.0)])
    //custxtEmail.returnKeyType = UIReturnType.Done
    txtTitle.delegate = self;
    txtTitle.returnKeyType = UIReturnKeyType.Done
    txtTitle.clearButtonMode = UITextFieldViewMode.Always
    scrollVW.addSubview(txtTitle)
    
    var barBtnDone: UIBarButtonItem! = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: "barBtnDonTapped:")
    var barSpace: UIBarButtonItem! = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target:self, action: nil)
    
    toolBar = UIToolbar(frame: CGRectMake(0, 0, self.view.frame.width,50))
    toolBar.items = [barSpace,barBtnDone]
    
    txtVwContent = UITextView(frame: CGRectMake(txtTitle.frame.origin.x,txtTitle.frame.origin.y+txtTitle.frame.height+20, txtTitle.frame.width, 140))
    txtVwContent.delegate = self
    txtVwContent.layer.borderWidth = 1
    txtVwContent.inputAccessoryView = toolBar
    txtVwContent.layer.borderColor = UIColor(red: 71.0/255.0, green: 168.0/255.0, blue: 184.0/255.0,alpha:1.0).CGColor
    scrollVW.addSubview(txtVwContent)
    
    lblTxtVwPlace = UILabel(frame: CGRectMake((self.txtVwContent.frame.width-200)/2,(self.txtVwContent.frame.height-30)/2,200, 30))
    //lblTxtVwPlace.backgroundColor = UIColor.redColor()
    lblTxtVwPlace.text = "Fill the Content"
    lblTxtVwPlace.textAlignment = NSTextAlignment.Center
    lblTxtVwPlace.font = lblTxtVwPlace.font.fontWithSize(12)
    lblTxtVwPlace.textColor = UIColor(red: 71.0/255.0, green: 168.0/255.0, blue: 184.0/255.0,alpha:1.0)
    txtVwContent.addSubview(lblTxtVwPlace)

  }
  
  func barBtnDonTapped(sender:UIBarButtonItem){
    txtVwContent.resignFirstResponder()
    //scrollVW.contentOffset = CGPoint(x: 0, y: 0)
  }
  
  func btnBackTapped(){
    self.navigationController?.popViewControllerAnimated(true)
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return false
  }
  
  
  func textViewShouldBeginEditing(textView: UITextView) -> Bool {
    lblTxtVwPlace.hidden = true
    
    return true
  }
  
  func textViewDidBeginEditing(textView: UITextView) {
    if(isiPhone4orLower){
    scrollVW.contentOffset = CGPoint(x: 0, y:30)
    }
  }
  
  func textViewDidEndEditing(textView: UITextView) {
    if(isiPhone4orLower){
    scrollVW.contentOffset = CGPoint(x: 0, y:-60)
    }
  }
  
  
  func btnBarPostTapped(sender:AnyObject){
    
    if(txtTitle.text.isEmpty || txtVwContent.text.isEmpty){
      var alert: UIAlertView = UIAlertView(title: "Alert", message: "You missing a some entries please fill up.", delegate:self, cancelButtonTitle:"OK")
      alert.show()
    }else{
       self.postCreateNewTopicApi()
    }
  }

  //************* Create New toic Api Call**************
  
  func postCreateNewTopicApi(){
    
    var aParams: NSMutableDictionary = NSMutableDictionary()
    aParams.setValue(auth_token[0], forKey: "auth-token")
    aParams.setValue(classID, forKey: "class_id")
    aParams.setValue(txtTitle.text, forKey:"topic[title]")
    aParams.setValue(txtVwContent.text, forKey:"topic[content]")
    self.api.createClassTopic(aParams as [NSObject : AnyObject], success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
      println(responseObject)
      self.navigationController?.popViewControllerAnimated(true)
      },
      failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
        println(error)
        
    })
    
  }

  
  
  
}
