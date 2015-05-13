//
//  AdAnsViewController.swift
//  Tonguer
//
//  Created by GrepRuby on 12/05/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import UIKit

class AdAnsViewController: BaseViewController,UITextViewDelegate {
  
  
  var scrollview: UIScrollView!
  var barBackBtn :UIBarButtonItem!
  var txtViewQues :UITextView!
  var txtViewAddAns :UITextView!
  var imgVw :UIImageView!
  var vWLine :  UIView!
  var vWQues :  UIView!
  var btnSend :UIButton!
  var strQuestion: NSString!
  var dictQus: NSDictionary!
  var lbltitle: UILabel!
  var api: AppApi!

    override func viewDidLoad() {
        super.viewDidLoad()
      api = AppApi.sharedClient()
    self.defaultUIDesign()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  func defaultUIDesign(){
  
    self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
    
    self.navigationItem.setHidesBackButton(true, animated:false)
    
    var backbtn:UIButton = UIButton(frame: CGRectMake(0, 0,25,25))
    backbtn.setImage(UIImage(named: "whiteback.png"), forState: UIControlState.Normal)
    backbtn.addTarget(self, action: "btnBackTapped", forControlEvents: UIControlEvents.TouchUpInside)
    
    barBackBtn = UIBarButtonItem(customView: backbtn)
    self.navigationItem.setLeftBarButtonItem(barBackBtn, animated: true)
    
    scrollview = UIScrollView(frame: CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y+64, self.view.frame.size.width, self.view.frame.height-64))
    
    scrollview.showsHorizontalScrollIndicator = true
    scrollview.scrollEnabled = true
    scrollview.userInteractionEnabled = true
    //scrollview.backgroundColor = UIColor.grayColor()
    scrollview.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height-70)
    
    self.view.addSubview(scrollview)
    
    
    vWQues = UIView(frame: CGRectMake(scrollview.frame.origin.x+20,0, scrollview.frame.width-40,200))
    //vWQues.backgroundColor = UIColor.redColor()
    vWQues.layer.borderWidth = 1
    vWQues.layer.borderColor = UIColor.lightGrayColor().CGColor
    scrollview.addSubview(vWQues)
    
    imgVw = UIImageView(frame: CGRectMake(5,5, 20, 20))
    imgVw.backgroundColor = UIColor.grayColor()
    imgVw.image = UIImage(named: "Q.png")
    vWQues.addSubview(imgVw)
    
    
    vWLine = UIView(frame: CGRectMake(imgVw.frame.origin.x+imgVw.frame.width+10, imgVw.frame.origin.y, 1, imgVw.frame.height))
    vWLine.backgroundColor = UIColor.lightGrayColor()
    vWQues.addSubview(vWLine)
    
    txtViewQues = UITextView(frame:CGRectMake(vWLine.frame.origin.x+5, 0, vWQues.frame.width-40, vWQues.frame.height-5))
    txtViewQues.text = dictQus.valueForKey("question") as NSString
   // txtViewQues.backgroundColor = UIColor.grayColor()
    txtViewQues.userInteractionEnabled = false
    txtViewQues.textColor = UIColor.grayColor()
    txtViewQues.allowsEditingTextAttributes = false
    vWQues.addSubview(txtViewQues)
    
    
    btnSend = UIButton(frame: CGRectMake(scrollview.frame.origin.x+20,(vWQues.frame.size.height+vWQues.frame.origin.y+150),scrollview.frame.width-40, 40))
    self.btnSend.setTitle("Add Your Answer", forState: UIControlState.Normal)
    self.btnSend.backgroundColor = UIColor(red: 237.0/255.0, green: 62.0/255.0, blue: 61.0/255.0,alpha:1.0);
    self.btnSend.tintColor = UIColor.whiteColor()
    btnSend.addTarget(self, action: "btnSendButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
    scrollview.addSubview(self.btnSend)
    
    txtViewAddAns = UITextView(frame: CGRectMake(btnSend.frame.origin.x,btnSend.frame.origin.y-btnSend.frame.size.height-70,btnSend.frame.width, 100))
    //txtViewAddAns.text = "Type Your Answer"
    
    txtViewAddAns.delegate = self
    txtViewAddAns.textColor = UIColor(red: 66.0/255.0, green: 150.0/255.0, blue: 173.0/255.0,alpha:1.0)
    txtViewAddAns.layer.borderWidth = 1
    txtViewAddAns.layer.borderColor = UIColor(red: 66.0/255.0, green: 150.0/255.0, blue: 173.0/255.0,alpha:1.0).CGColor
    scrollview.addSubview(txtViewAddAns)
    
  }
 
  func btnBackTapped(){
    self.navigationController?.popViewControllerAnimated(true)
  }
  
  func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
    
    if(text == "\n"){
      scrollview.contentOffset = CGPoint(x:0, y:0)
      textView.resignFirstResponder()
      return false
    }
    return true
  }
 
  func textViewDidBeginEditing(textView: UITextView) {
    scrollview.contentOffset = CGPoint(x:0, y:txtViewAddAns.frame.height-20)
  }
  
  
  func btnSendButtonTapped(sender: AnyObject){
    self.postAddAnswerApiCall()
  }
  

  //******************* Add Answer Api call Methode ************
  
  func postAddAnswerApiCall(){
    
    var aParams: NSMutableDictionary! = NSMutableDictionary()
   
    aParams.setValue(auth_token[0], forKey: "auth_token")
    aParams.setValue(dictQus.valueForKey("id"),forKey: "question_id")
    aParams.setValue(txtViewAddAns.text, forKey: "answer[answer]")
    self.api.clsQueaAnswer(aParams, success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
      println(responseObject)
      var alert: UIAlertView! = UIAlertView(title: "Alert", message: "Answer Send Successfully", delegate: self, cancelButtonTitle: "Ok")
      alert.show()
      },
      failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
        println(error)
        var alert: UIAlertView! = UIAlertView(title: "Alert", message: "Don't Send", delegate: self, cancelButtonTitle: "Ok")
        alert.show()
        
    })

    
  }

}
