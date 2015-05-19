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
  var lblQues: UILabel!
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
    
    scrollview = UIScrollView(frame: CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.height))
    
    scrollview.showsHorizontalScrollIndicator = true
    scrollview.scrollEnabled = true
    scrollview.userInteractionEnabled = true
    //scrollview.backgroundColor = UIColor.grayColor()
    
    
    self.view.addSubview(scrollview)
    
    
    var strQuest = dictQus.valueForKey("question") as NSString
    var rect: CGRect! = strQuest.boundingRectWithSize(CGSize(width:self.view.frame.size.width-40,height:300), options:NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(12)], context: nil)
    scrollview.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height+rect.height)
    
    imgVw = UIImageView(frame: CGRectMake(5,5, 20, 20))
    //imgVw.backgroundColor = UIColor.grayColor()
    imgVw.image = UIImage(named: "Q.png")
    scrollview.addSubview(imgVw)
    
    
    vWLine = UIView(frame: CGRectMake(imgVw.frame.origin.x+imgVw.frame.width+10, imgVw.frame.origin.y, 1, imgVw.frame.height))
    vWLine.backgroundColor = UIColor.lightGrayColor()
    scrollview.addSubview(vWLine)
    
    lblQues = UILabel(frame: CGRectMake(vWLine.frame.origin.x+5,vWLine.frame.origin.y,rect.width,rect.height))
    
    lblQues.text = strQuest
    lblQues.numberOfLines = 0
    lblQues.textAlignment = NSTextAlignment.Justified
    lblQues.font = lblQues.font.fontWithSize(12)
    lblQues.textColor = UIColor.grayColor()
    //lblContent.backgroundColor = UIColor.greenColor()
    scrollview.addSubview(lblQues)

    
    btnSend = UIButton(frame: CGRectMake(scrollview.frame.origin.x+20,(lblQues.frame.size.height+lblQues.frame.origin.y+150),scrollview.frame.width-40, 40))
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
   // scrollview.contentOffset = CGPoint(x:0, y:0)
  }
  
  
  func btnSendButtonTapped(sender: AnyObject){
    
    if(txtViewAddAns.text == ""){
      var alert: UIAlertView! = UIAlertView(title: "Alert", message: "Please enter a Answer", delegate: self, cancelButtonTitle: "Ok")
      alert.show()

    }else{
      self.postAddAnswerApiCall()
    }
  
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
