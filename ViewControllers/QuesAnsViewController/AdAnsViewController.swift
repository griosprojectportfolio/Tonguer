//
//  AdAnsViewController.swift
//  Tonguer
//
//  Created by GrepRuby on 12/05/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import UIKit

class AdAnsViewController: BaseViewController,UITextViewDelegate, UIAlertViewDelegate {
  
  
  var scrollview: UIScrollView!
  var barBackBtn :UIBarButtonItem!
  var txtViewQues,txtViewAddAns :UITextView!
  
  var imgVw :UIImageView!
  var vWLine,vWQues :  UIView!

  var btnSend :UIButton!
  var strQuestion: NSString!
  var dictQus: NSDictionary!
  var lblQues: UILabel!
  var api: AppApi!
  var alertSend: UIAlertView!
  var toolBar:UIToolbar!
  var isTecxtViewUp:Bool = false
  var arryAnswer:NSArray! = NSArray()

    override func viewDidLoad() {
        super.viewDidLoad()
      api = AppApi.sharedClient()
      self.navigationItem.setHidesBackButton(true, animated:false)
      
      var backbtn:UIButton = UIButton(frame: CGRectMake(0, 0,25,25))
      backbtn.setImage(UIImage(named: "whiteback.png"), forState: UIControlState.Normal)
      backbtn.addTarget(self, action: "btnBackTapped", forControlEvents: UIControlEvents.TouchUpInside)
      
      barBackBtn = UIBarButtonItem(customView: backbtn)
      self.navigationItem.setLeftBarButtonItem(barBackBtn, animated: true)
    getUserAnswerApiCall()
     
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
  }
  
  func defaultUIDesign(){
  
    
    
    scrollview = UIScrollView(frame: CGRectMake(self.view.frame.origin.x,64, self.view.frame.size.width, self.view.frame.height-64))
    
    println(scrollview)
    scrollview.showsHorizontalScrollIndicator = true
    scrollview.scrollEnabled = true
    scrollview.userInteractionEnabled = true
    //scrollview.backgroundColor = UIColor.grayColor()
    
    self.view.addSubview(scrollview)

    var barBtnDone: UIBarButtonItem! = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: "barBtnDonTapped")
    var barSpace: UIBarButtonItem! = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target:self, action: nil)
    toolBar = UIToolbar(frame: CGRectMake(0, 0, self.view.frame.width,50))
    toolBar.items = [barSpace,barBtnDone]

    var strQuest = dictQus.valueForKey("question") as! NSString
    var rect: CGRect! = strQuest.boundingRectWithSize(CGSize(width:self.view.frame.size.width-40,height:300), options:NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(12)], context: nil)
    scrollview.contentSize = CGSize(width: self.view.frame.width, height: 180+rect.height)
    
    imgVw = UIImageView(frame: CGRectMake(5,5, 20, 20))
    //imgVw.backgroundColor = UIColor.grayColor()
    imgVw.image = UIImage(named: "Q.png")
    scrollview.addSubview(imgVw)

    vWLine = UIView(frame: CGRectMake(imgVw.frame.origin.x+imgVw.frame.width, imgVw.frame.origin.y, 1, imgVw.frame.height))
    vWLine.backgroundColor = UIColor.lightGrayColor()
    scrollview.addSubview(vWLine)
    
    lblQues = UILabel(frame: CGRectMake(vWLine.frame.origin.x+5,vWLine.frame.origin.y,rect.width,rect.height))
    
    lblQues.text = strQuest as String
    lblQues.numberOfLines = 0
    lblQues.textAlignment = NSTextAlignment.Justified
    lblQues.font = lblQues.font.fontWithSize(12)
    lblQues.textColor = UIColor.grayColor()
    //lblContent.backgroundColor = UIColor.greenColor()
    scrollview.addSubview(lblQues)
    
    btnSend = UIButton(frame: CGRectMake(scrollview.frame.origin.x+20,(lblQues.frame.size.height+lblQues.frame.origin.y+150),scrollview.frame.width-40, 40))
    //self.btnSend.setTitle("Add Your Answer", forState: UIControlState.Normal)
    self.btnSend.backgroundColor = UIColor(red: 237.0/255.0, green: 62.0/255.0, blue: 61.0/255.0,alpha:1.0);
    self.btnSend.tintColor = UIColor.whiteColor()
    //btnSend.addTarget(self, action: "btnSendButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
    scrollview.addSubview(self.btnSend)
    
    txtViewAddAns = UITextView(frame: CGRectMake(btnSend.frame.origin.x,btnSend.frame.origin.y-btnSend.frame.size.height-70,btnSend.frame.width, 100))
    //txtViewAddAns.text = "Type Your Answer"
    
    txtViewAddAns.delegate = self
    txtViewAddAns.textColor = UIColor(red: 66.0/255.0, green: 150.0/255.0, blue: 173.0/255.0,alpha:1.0)
    txtViewAddAns.layer.borderWidth = 1
    txtViewAddAns.inputAccessoryView = toolBar
    txtViewAddAns.layer.borderColor = UIColor(red: 66.0/255.0, green: 150.0/255.0, blue: 173.0/255.0,alpha:1.0).CGColor
    scrollview.addSubview(txtViewAddAns)
    
    if(arryAnswer.count > 0){
      var obj = arryAnswer.objectAtIndex(0) as! Answer
      txtViewAddAns.text = obj.answer as String
      self.btnSend.setTitle("Update Your Answer", forState: UIControlState.Normal)
      btnSend.addTarget(self, action: "btnUpadteButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
    }else{
      txtViewAddAns.text = ""
      self.btnSend.setTitle("Add Your Answer", forState: UIControlState.Normal)
      btnSend.addTarget(self, action: "btnSendButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
    }

  }
 
  func btnBackTapped(){
    self.navigationController?.popViewControllerAnimated(true)
  }

  func textViewDidBeginEditing(textView: UITextView) {
    println((self.view.frame.size.height - 280))
    if txtViewAddAns.frame.origin.y + txtViewAddAns.frame.size.height > (scrollview.frame.size.height - 280) {
      scrollview.contentOffset = CGPoint(x:0, y:(lblQues.frame.size.height-30))
      //scrollview.contentSize = CGSizeMake(scrollview.frame.size.width,scrollview.frame.size.height + txtViewAddAns.frame.origin.y)
      isTecxtViewUp = true;
    }
    println("\(txtViewAddAns.frame.origin.y) \(scrollview.contentOffset)")
  }
  
  func textViewDidEndEditing(textView: UITextView) {
    if isTecxtViewUp == true {
      scrollview.contentOffset = CGPoint(x:0, y:-(lblQues.frame.size.height+30))
    }
  }

  func btnSendButtonTapped(sender: AnyObject){
    
    if(txtViewAddAns.text == ""){
      var alert: UIAlertView! = UIAlertView(title: "Alert", message: "Please enter a Answer.", delegate: nil, cancelButtonTitle: "Ok")
      alert.show()

    }else{
      self.postAddAnswerApiCall()
    }
  }
  
  func btnUpadteButtonTapped(sender: AnyObject){
    
    if(txtViewAddAns.text == ""){
      var alert: UIAlertView! = UIAlertView(title: "Alert", message: "Please enter a Answer.", delegate: nil, cancelButtonTitle: "Ok")
      alert.show()
      
    }else{
      self.updateAddAnswerApiCall()
    }
  }


  //******************* Add Answer Api call Methode ************
  
  func postAddAnswerApiCall(){
    
    var aParams: NSMutableDictionary = NSMutableDictionary()
   
    aParams.setValue(auth_token[0], forKey: "auth-token")
    aParams.setValue(dictQus.valueForKey("id"),forKey: "question_id")
    aParams.setValue(txtViewAddAns.text, forKey: "answer[answer]")
    self.api.clsQueaAnswer(aParams as [NSObject : AnyObject], success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
      println(responseObject)
       self.alertSend = UIAlertView(title: "Alert", message: "Answer Send Successfully.", delegate: self, cancelButtonTitle: "Ok")
        self.alertSend.show()
      },
      failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
        println(error)
        var alert: UIAlertView! = UIAlertView(title: "Alert", message: "Don't Send.", delegate: nil, cancelButtonTitle: "Ok")
        alert.show()
        
    })
  }

  func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {

    if (alertView == alertSend) {
      let vc = self.storyboard?.instantiateViewControllerWithIdentifier("AnswerID") as! AnswersViewController
      vc.dictQues = self.dictQus
      self.navigationController?.pushViewController(vc, animated:true)
    }
  }
  
  func updateAddAnswerApiCall(){
    
    var aParams: NSMutableDictionary = NSMutableDictionary()
    var obj = arryAnswer.objectAtIndex(0) as! Answer
    aParams.setValue(auth_token[0], forKey: "auth-token")
    aParams.setValue(obj.ans_id,forKey: "answer_id")
    aParams.setValue(txtViewAddAns.text, forKey: "answer")
    self.api.userAnswerUpdateApi(aParams as [NSObject : AnyObject], success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
      println(responseObject)
      self.alertSend = UIAlertView(title: "Alert", message: "Answer Update Successfully.", delegate: self, cancelButtonTitle: "Ok")
      self.alertSend.show()
      },
      failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
        println(error)
        var alert: UIAlertView! = UIAlertView(title: "Alert", message: "Don't upadte.", delegate: nil, cancelButtonTitle: "Ok")
        alert.show()
        
    })
  }

  
  
  func getUserAnswerApiCall(){
    
    var userId:Int = CommonUtilities.sharedDelegate().dictUserInfo.objectForKey("id") as! Int
    var aParams: NSMutableDictionary = NSMutableDictionary()
    aParams.setValue(auth_token[0], forKey: "auth-token")
    aParams.setValue(dictQus.valueForKey("id"), forKey: "question_id")
    aParams.setValue(userId, forKey: "userId")
    println(aParams)
    self.api.userAnswer(aParams as [NSObject : AnyObject], success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
      println(responseObject)
      self.arryAnswer = responseObject as! NSArray
      if(self.arryAnswer.count>0){
       print(self.arryAnswer.count)
      }
      self.defaultUIDesign()
      },
      failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
        println(error)
       self.defaultUIDesign()
    })
  }


  func barBtnDonTapped () {
    self.view.endEditing(true)
    scrollview.contentOffset = CGPoint(x:0, y:0)
  }

}
