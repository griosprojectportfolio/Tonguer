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
  var lblContent: UILabel!
  var actiIndecatorVw: ActivityIndicatorView!
  var height:CGFloat = 0
  var toolBar:UIToolbar!
  override func viewDidLoad() {
    super.viewDidLoad()
    api = AppApi.sharedClient()
    
    self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
    
    self.navigationItem.setHidesBackButton(true, animated:false)
    
    var backbtn:UIButton = UIButton(frame: CGRectMake(0, 0,25,25))
    backbtn.setImage(UIImage(named: "whiteback.png"), forState: UIControlState.Normal)
    backbtn.addTarget(self, action: "btnBackTapped", forControlEvents: UIControlEvents.TouchUpInside)
    
    barBackBtn = UIBarButtonItem(customView: backbtn)
    self.navigationItem.setLeftBarButtonItem(barBackBtn, animated: true)

//    actiIndecatorVw = ActivityIndicatorView(frame: self.view.frame)
//    self.view.addSubview(actiIndecatorVw)

    //self.getCommentTopicApiCall()
    self.defaultUIDesign()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    self.getCommentTopicApiCall()
  }
  
  func defaultUIDesign(){
    print(dictTopic)
    //self.title = "Forum"
    
    scrollview = UIScrollView(frame: CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.height))
    
    scrollview.showsHorizontalScrollIndicator = true
    scrollview.scrollEnabled = true
    scrollview.userInteractionEnabled = true
    //scrollview.backgroundColor = UIColor.grayColor()

    self.view.addSubview(scrollview)

    imgVw = UIImageView(frame: CGRectMake(10,10,20,20))
    //imgVw.backgroundColor = UIColor.grayColor()
    imgVw.image = UIImage(named: "T.png")
    scrollview.addSubview(imgVw)
    
    
    vWLine = UIView(frame: CGRectMake(imgVw.frame.origin.x+imgVw.frame.width, imgVw.frame.origin.y, 1, imgVw.frame.height))
    vWLine.backgroundColor = UIColor.lightGrayColor()
   scrollview.addSubview(vWLine)
    
    var barBtnDone: UIBarButtonItem! = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: "barBtnDonTapped")
    var barSpace: UIBarButtonItem! = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target:self, action: nil)
    
    toolBar = UIToolbar(frame: CGRectMake(0, 0, self.view.frame.width,50))
    toolBar.items = [barSpace,barBtnDone]
    
    var strContent: NSString = dictTopic.valueForKey("content") as NSString
    
     var rect: CGRect! = strContent.boundingRectWithSize(CGSize(width:self.view.frame.size.width-60,height:300), options:NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(12)], context: nil)
    
//    if(self.view.frame.height+rect.height > self.view.frame.height+100) {
//      scrollview.contentSize = CGSize(width: self.view.frame.width, height: rect.height+300)
//    }
    lblContent = UILabel(frame: CGRectMake(vWLine.frame.origin.x+5,vWLine.frame.origin.y-5,self.view.frame.width-50,rect.height))
    
    lblContent.text = strContent
    lblContent.numberOfLines = 0
    lblContent.textAlignment = NSTextAlignment.Justified
    lblContent.font = lblContent.font.fontWithSize(12)
    lblContent.textColor = UIColor.grayColor()
    //lblContent.backgroundColor = UIColor.greenColor()
    scrollview.addSubview(lblContent)

    
    adAnstableView = UITableView(frame: CGRectMake(scrollview.frame.origin.x,lblContent.frame.origin.y+lblContent.frame.size.height+20,scrollview.frame.width ,200))
   // adAnstableView.backgroundColor = UIColor.yellowColor()
    adAnstableView.separatorStyle = UITableViewCellSeparatorStyle.None
    adAnstableView.rowHeight = 50
    adAnstableView.delegate = self
    adAnstableView.dataSource = self
  
    scrollview.addSubview(adAnstableView)
    
    adAnstableView.registerClass(AdAnsTableViewCell.self, forCellReuseIdentifier: "cell")
    
  }
  
  func barBtnDonTapped () {
    self.view.endEditing(true)
    scrollview.contentOffset = CGPoint(x:0, y:-64)
  }
  
  func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
    return "Comments"
  }
  
  func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 200
  }
  
  func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    
    var vWFooter: UIView! = UIView(frame: CGRectMake(0,0,self.view.frame.width,200))
    //vWFooter.backgroundColor = UIColor(red: 71.0/255.0, green: 168.0/255.0, blue: 184.0/255.0,alpha:1.0)
    vWFooter.layer.borderWidth = 0.5
    vWFooter.layer.borderColor = UIColor.lightGrayColor().CGColor
    
    txtViewAddAns = UITextView(frame: CGRectMake(5,5,self.view.frame.width-10,100))
    //txtView.backgroundColor = UIColor.grayColor()
    txtViewAddAns.text = ""
    txtViewAddAns.inputAccessoryView = toolBar
    txtViewAddAns.delegate = self
    //txtView.textColor = UIColor(red: 66.0/255.0, green: 150.0/255.0, blue: 173.0/255.0,alpha:1.0)
    txtViewAddAns.layer.borderWidth = 1
    txtViewAddAns.layer.borderColor = UIColor(red: 66.0/255.0, green: 150.0/255.0, blue: 173.0/255.0,alpha:1.0).CGColor
    vWFooter.addSubview(txtViewAddAns)
    
    var btnSends: UIButton! = UIButton(frame: CGRectMake(txtViewAddAns.frame.origin.x,txtViewAddAns.frame.origin.y+txtViewAddAns.frame.height+20,txtViewAddAns.frame.width, 40))
     btnSends.setTitle("Send", forState: UIControlState.Normal)
     btnSends.backgroundColor = UIColor(red: 237.0/255.0, green: 62.0/255.0, blue: 61.0/255.0,alpha:1.0);
     btnSends.tintColor = UIColor.whiteColor()
     btnSends.addTarget(self, action: "btnSendButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
     vWFooter.addSubview(btnSends)
    
    return vWFooter
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return arrCommentData.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
      var cell:AdAnsTableViewCell! = nil
    
       cell = adAnstableView.dequeueReusableCellWithIdentifier("cell") as AdAnsTableViewCell
      // cell.backgroundColor = UIColor.redColor()
       cell.selectionStyle = UITableViewCellSelectionStyle.None
       cell.defaultUIDesign(arrCommentData.objectAtIndex(indexPath.row) as NSDictionary)
    
    return cell
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    
    var dict: NSDictionary! = arrCommentData.objectAtIndex(indexPath.row) as NSDictionary
    
    var data: NSString! = dict.valueForKey("comment") as NSString
    
    var rect: CGRect! = data.boundingRectWithSize(CGSize(width:self.view.frame.size.width-60,height:300), options:NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(12)], context: nil)
    return (rect.height+40)
  }
  
  
  func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
   
    return true
  }
  
  
  

  
  func dynamicHeightOfTbleView () {
    
    var tbleHeight:CGFloat = 0
    for var iLoop = 0 ; iLoop<arrCommentData.count ; iLoop++ {
   
      var dict: NSDictionary! = arrCommentData.objectAtIndex(iLoop) as NSDictionary
      
      var data: NSString! = dict.valueForKey("comment") as NSString
      
      var rect: CGRect! = data.boundingRectWithSize(CGSize(width:self.view.frame.size.width-60,height:300), options:NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(12)], context: nil)
   
      print("****\(rect.height+40)")
      height = height + rect.height+40;
      tbleHeight = height
      if (height > 500) {
        tbleHeight = 500;
        break
      }
    }
    adAnstableView.frame = CGRectMake(scrollview.frame.origin.x,lblContent.frame.origin.y+lblContent.frame.size.height+20,scrollview.frame.width ,tbleHeight+200)
      scrollview.contentSize = CGSize(width: self.view.frame.width, height: adAnstableView.frame.size.height + adAnstableView.frame.origin.y+10)
  }
  
  func textViewDidBeginEditing(textView: UITextView) {
    if self.arrCommentData.count > 0 {
    scrollview.contentOffset = CGPoint(x:0, y:self.scrollview.frame.origin.y+(lblContent.frame.height+20))
    scrollview.contentSize = CGSize(width: self.view.frame.width, height:self.scrollview.contentSize.height + 250)

    }
  }
  
  func textViewDidEndEditing(textView: UITextView) {
    scrollview.contentSize = CGSize(width: self.view.frame.width, height:self.scrollview.contentSize.height - 250)
  }
  
  func btnBackTapped(){
    self.navigationController?.popViewControllerAnimated(true)
  }  
  
  func btnSendButtonTapped(semder:AnyObject){
    self.postCommentTopicApiCall()
   // self.dataFetchFromDatabaseDiscus()
    var dict: NSMutableDictionary! = NSMutableDictionary()
    dict.setValue(txtViewAddAns.text, forKey: "comment")
    println(dict)
    dict.setValue("User", forKey: "by")
    arrCommentData.addObject(dict)
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
    //aParams.setValue(txtViewAddAns.text, forKey:"comment[comment]")
    self.api.discusTopicComments(aParams, success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
      self.dataFetchFromDatabaseDiscus(responseObject as NSArray)
      self.adAnstableView.reloadData()
      self.dynamicHeightOfTbleView()
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
  
  func dataFetchFromDatabaseDiscus(arrFetchAdmin: NSArray){
      arrCommentData.removeAllObjects()
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
