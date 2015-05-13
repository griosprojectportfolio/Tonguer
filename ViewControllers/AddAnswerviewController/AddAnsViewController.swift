//
//  AddAnsViewController.swift
//  Tonguer
//
//  Created by GrepRuby on 03/04/15.
//  Copyright (c) 2015 GrepRuby. All rights reserved.
//

import UIKit

class AddAnsViewController: BaseViewController,UITextViewDelegate,UITableViewDataSource,UITableViewDelegate{
  
  var api:AppApi!
  
  var scrollview: UIScrollView!
  var adAnstableView: UITableView!
  var barBackBtn :UIBarButtonItem!
  var txtViewQues :UITextView!
  var txtViewAddAns :UITextView!
  var imgVw :UIImageView!
  var vWLine :  UIView!
  var vWQues :  UIView!
  var btnSend :UIButton!
  var strdata: NSString!
  var dictTopic: NSDictionary!
  var arrCommentData: NSMutableArray! = NSMutableArray()
  var lbltitle: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    api = AppApi.sharedClient()
    self.defaultUIDesign()
    self.getCommentTopicApiCall()
    self.dataFetchFromDatabaseDiscus()
  }
  
  func defaultUIDesign(){
    print(dictTopic)
    //self.title = "Forum"
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
    
    
    vWQues = UIView(frame: CGRectMake(scrollview.frame.origin.x+20,0, scrollview.frame.width-40,100))
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
    txtViewQues.text = dictTopic.valueForKey("content") as NSString
    //txtViewQues.backgroundColor = UIColor.grayColor()
    txtViewQues.userInteractionEnabled = false
    txtViewQues.textColor = UIColor.grayColor()
    txtViewQues.allowsEditingTextAttributes = false
    vWQues.addSubview(txtViewQues)
  

    btnSend = UIButton(frame: CGRectMake(scrollview.frame.origin.x+20,scrollview.frame.size.height-60,scrollview.frame.width-40, 40))
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
    
    adAnstableView = UITableView(frame: CGRectMake(scrollview.frame.origin.x+20,vWQues.frame.origin.y+vWQues.frame.size.height+10,scrollview.frame.width-40 ,txtViewAddAns.frame.origin.y-txtViewAddAns.frame.size.height-80))
    //adAnstableView.backgroundColor = UIColor.redColor()
    adAnstableView.delegate = self
    adAnstableView.dataSource = self
  
    scrollview.addSubview(adAnstableView)
    
    adAnstableView.registerClass(AdAnsTableViewCell.self, forCellReuseIdentifier: "cell")
    
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return arrCommentData.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    var cell:AdAnsTableViewCell! = nil
    
       cell = adAnstableView.dequeueReusableCellWithIdentifier("cell") as AdAnsTableViewCell
       //cell.backgroundColor = UIColor.redColor()
       cell.selectionStyle = UITableViewCellSelectionStyle.None
       cell.defaultUIDesign(arrCommentData.objectAtIndex(indexPath.row) as NSDictionary)
    
    return cell
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    
    var dict: NSDictionary! = arrCommentData.objectAtIndex(indexPath.row) as NSDictionary
    
    var data: NSString! = dict.valueForKey("comment") as NSString
    
    var rect: CGRect! = data.boundingRectWithSize(CGSize(width:300,height:CGFloat.max), options:NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(12)], context: nil)
    
    return rect.height+60
  }
  
  
  func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
    
    if(text == "\n"){
      scrollview.contentOffset = CGPoint(x:0, y:0)
      textView.resignFirstResponder()
      return false
    }
    return true
  }
  
//  func textViewDidChange(textView: UITextView) {
//    
//    if(textView.text == "\n"){
//      scrollview.contentOffset = CGPoint(x:0, y:0)
//    }
//     textView.resignFirstResponder()
//  }
  
  func textViewDidBeginEditing(textView: UITextView) {
    scrollview.contentOffset = CGPoint(x:0, y:txtViewAddAns.frame.height+100)
  }
  
  func btnBackTapped(){
    self.navigationController?.popViewControllerAnimated(true)
  }
  
  
  func btnSendButtonTapped(semder:AnyObject){
    self.postCommentTopicApiCall()
    self.dataFetchFromDatabaseDiscus()
    adAnstableView.reloadData()
  }
  
  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  //************Api methode Call Get Comments*********
  
  func getCommentTopicApiCall(){
    
    var aParams: NSMutableDictionary! = NSMutableDictionary()
    aParams.setValue(auth_token[0], forKey: "auth_token")
    aParams.setValue(dictTopic.valueForKey("id"), forKey:"topic_id")
    aParams.setValue(txtViewAddAns.text, forKey:"comment[comment]")
    self.api.discusTopicComments(aParams, success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
      println(responseObject)
      },
      failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
        println(error)
        
    })
    
  }
  
  //************Api methode Call Post Comments*********
  
  func postCommentTopicApiCall(){
    
    var aParams: NSMutableDictionary! = NSMutableDictionary()
    aParams.setValue(auth_token[0], forKey: "auth_token")
    aParams.setValue(dictTopic.valueForKey("id"), forKey:"topic_id")
    aParams.setValue(txtViewAddAns.text, forKey:"comment[comment]")
    self.api.discusTopicPostComments(aParams, success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
      println(responseObject)
      
      },
      failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
        println(error)
        
    })
    
  }

  

//***********Data Fetch from DataBase************
  
  func dataFetchFromDatabaseDiscus(){
    
    let arrFetchAdmin: NSArray = DisTopicComments.MR_findAll()
    
    for var index = 0; index < arrFetchAdmin.count; ++index{
      let clsObject: DisTopicComments = arrFetchAdmin.objectAtIndex(index) as DisTopicComments
      var dict: NSMutableDictionary! = NSMutableDictionary()
      dict.setValue(clsObject.comment_id, forKey: "id")
      dict.setValue(clsObject.commment, forKey: "comment")
      dict.setValue(clsObject.name, forKey: "by")
      arrCommentData.addObject(dict)
    }

    
  }
  
  
  

}
