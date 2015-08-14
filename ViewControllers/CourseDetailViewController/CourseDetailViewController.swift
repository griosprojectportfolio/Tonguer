//
//  CourseDetailViewController.swift
//  Tonguer
//
//  Created by GrepRuby on 02/04/15.
//  Copyright (c) 2015 GrepRuby. All rights reserved.
//

import UIKit
import CoreTelephony


class CourseDetailViewController: BaseViewController,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate {
  
  var callVw:NSString!
  
  var barBackBtn :UIBarButtonItem!
  var barforwordBtn :UIBarButtonItem!
  
  var tableview: UITableView!
  var imgVw: UIImageView!
  var btnCourseDetail,btnCourselist,btnCourseask,btnCDetail,btnServiceChat,btnHaveClass,btnCall,btnbuy: UIButton!
  var horiVw,horiVw1,horiVw2: UIView!
  var api: AppApi!
  var dataArr: NSArray!
  var dict1,dict2,dict3,dict4,dict5,dictClist,clsDictDe: NSDictionary!
  var isSearch:Bool!
  var clistarr: NSArray!
  var arrOutline: NSArray! = NSArray()
  
  var btnTag: NSInteger! = 1
  var serviceCallNo:NSNumber!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    api = AppApi.sharedClient()
    self.defaultUIDesign()
    print(clsDictDe)
    
    var strName: NSString! = clsDictDe.objectForKey("name") as! NSString
    //var price: NSString! = NSString(format: "%i",(clsDictDe.objectForKey("price")?.integerValue)!)
    var price: NSObject = clsDictDe.objectForKey("price") as! NSObject
    var strPrice: NSString!
    if price.isKindOfClass(NSString){
     strPrice = clsDictDe.objectForKey("price") as! NSString
    }else if price.isKindOfClass(NSNumber) {
      strPrice =  NSString(format: "%i",(clsDictDe.objectForKey("price")?.integerValue)!)
    }
        
    dict1 = NSDictionary(objects: [clsDictDe.objectForKey("name") as! NSString,strPrice,"0"], forKeys: ["coursename","courserate","id"])
    dict2 = NSDictionary(objects: ["course.png","Arrange",clsDictDe.valueForKey("arrange") as! NSString,"1"], forKeys: ["image","tilte","data","id"])
    dict3 = NSDictionary(objects: ["userred.png","Suitable for user",clsDictDe.valueForKey("suitable") as! NSString,"2"], forKeys: ["image","tilte","data","id"])
    if(clsDictDe.valueForKey("target") != nil) {
      dict4 = NSDictionary(objects: ["target.png","Target for",clsDictDe.valueForKey("target") as! NSString,"3"], forKeys: ["image","tilte","data","id"])
      dataArr = NSArray(objects: dict1,dict2,dict3,dict4)
    } else {
      dataArr = NSArray(objects: dict1,dict2,dict3)
    }
    dataFetchAdminContact()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    classOutlineApiCall()
    adminContactApi()
    if(btnTag == 1){
      
    }else if(btnTag == 2){
      
    }
  }
  
  func defaultUIDesign(){
    self.title = "Class Detail"
    
    self.navigationItem.setHidesBackButton(true, animated:false)
    
    var backbtn:UIButton = UIButton(frame: CGRectMake(0, 0,25,25))
    backbtn.setImage(UIImage(named: "whiteback.png"), forState: UIControlState.Normal)
    backbtn.addTarget(self, action: "btnBackTapped", forControlEvents: UIControlEvents.TouchUpInside)
    
    barBackBtn = UIBarButtonItem(customView: backbtn)
    
    self.navigationItem.setLeftBarButtonItem(barBackBtn, animated: true)
    
    imgVw = UIImageView(frame: CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y+64, self.view.frame.size.width, 200))

    var url:NSURL!
    if (isSearch == true) {
      url = NSURL(string: clsDictDe.objectForKey("image")?.objectForKey("url") as! String)
    } else {
      url = NSURL(string: clsDictDe.objectForKey("image") as! String)
    }

    imgVw.sd_setImageWithURL(url, placeholderImage:UIImage(named:"defaultImg"))
    self.view.addSubview(imgVw)
    
    btnCourseDetail = UIButton(frame: CGRectMake(0,imgVw.frame.origin.y+imgVw.frame.height,(self.view.frame.width/3), 40))
    btnCourseDetail.setTitle("Class Detail", forState: UIControlState.Normal)
    btnCourseDetail.tag = 1
    btnCourseDetail.titleLabel?.font = btnCourseDetail.titleLabel?.font.fontWithSize(12)
    btnCourseDetail.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
    btnCourseDetail.addTarget(self, action: "btnCourseDetailtapped:", forControlEvents: UIControlEvents.TouchUpInside)
    //btnCourseDetail.backgroundColor = UIColor.greenColor()
    self.view.addSubview(btnCourseDetail)
    
     horiVw = UIView(frame: CGRectMake(btnCourseDetail.frame.origin.x,btnCourseDetail.frame.origin.y+btnCourseDetail.frame.height , btnCourseDetail.frame.width, 1))
    horiVw.backgroundColor = UIColor(red: 66.0/255.0, green: 150.0/255.0, blue: 173.0/255.0,alpha:1.0)
    self.view.addSubview(horiVw)
    
    var vertiVw: UIView! = UIView(frame: CGRectMake(btnCourseDetail.frame.origin.x+btnCourseDetail.frame.width,btnCourseDetail.frame.origin.y,1,btnCourseDetail.frame.height))
    vertiVw.backgroundColor = UIColor.grayColor()
    self.view.addSubview(vertiVw)
    
    btnCourselist = UIButton(frame: CGRectMake(vertiVw.frame.origin.x,btnCourseDetail.frame.origin.y, btnCourseDetail.frame.width, btnCourseDetail.frame.height))
    btnCourselist.setTitle("Outline", forState: UIControlState.Normal)
    btnCourselist.tag = 2
    btnCourselist.titleLabel?.font = btnCourselist.titleLabel?.font.fontWithSize(12)
    btnCourselist.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
    //btnCourselist.backgroundColor = UIColor.greenColor()
    btnCourselist.addTarget(self, action: "btnCourseListapped:", forControlEvents: UIControlEvents.TouchUpInside)
    self.view.addSubview(btnCourselist)
    
     horiVw1 = UIView(frame: CGRectMake(btnCourselist.frame.origin.x,btnCourselist.frame.origin.y+btnCourselist.frame.height , btnCourselist.frame.width, 1))
    horiVw1.backgroundColor = UIColor.lightGrayColor()
    
    self.view.addSubview(horiVw1)
    
    var vertiVw1: UIView! = UIView(frame: CGRectMake(btnCourselist.frame.origin.x+btnCourselist.frame.width,btnCourselist.frame.origin.y,1,btnCourselist.frame.height))
    vertiVw1.backgroundColor = UIColor.grayColor()
    self.view.addSubview(vertiVw1)
    
    btnCourseask = UIButton(frame: CGRectMake(vertiVw1.frame.origin.x,btnCourselist.frame.origin.y ,btnCourselist.frame.width, btnCourselist.frame.height))
    btnCourseask.setTitle("Class asking", forState: UIControlState.Normal)
    btnCourseask.tag = 3
    btnCourseask.titleLabel?.font = btnCourseask.titleLabel?.font.fontWithSize(12)
    btnCourseask.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
    //btnCourselist.backgroundColor = UIColor.greenColor()
    btnCourseask.addTarget(self, action: "btnCourseAskingTapped:", forControlEvents: UIControlEvents.TouchUpInside)
    self.view.addSubview(btnCourseask)
    
    horiVw2 = UIView(frame: CGRectMake(btnCourseask.frame.origin.x,btnCourseask.frame.origin.y+btnCourseask.frame.height , btnCourseask.frame.width, 1))
    horiVw2.backgroundColor = UIColor.lightGrayColor()
    self.view.addSubview(horiVw2)
    
    var vertiVw2: UIView! = UIView(frame: CGRectMake(btnCourseask.frame.origin.x+btnCourseask.frame.width,btnCourseask.frame.origin.y,1,btnCourseask.frame.height))
    vertiVw2.backgroundColor = UIColor.grayColor()
    self.view.addSubview(vertiVw2)
    
    if(callVw.isEqualToString("Pay")){
     self.setVwFooterBtnsCallPickupCourse()
    }else if(callVw.isEqualToString("Free")){
      self.setVwFooterBtnsCallTryClass()
      //btnCourselist.userInteractionEnabled = false
    }
    
    tableview.delegate = self
    tableview.dataSource = self
    //tableview.backgroundColor = UIColor.grayColor()
    tableview.separatorStyle = UITableViewCellSeparatorStyle.None
    tableview.showsVerticalScrollIndicator = false
    self.view.addSubview(tableview)
    tableview.registerClass(CourseDetailTableViewCell.self, forCellReuseIdentifier: "cell")
    tableview.registerClass(CourseListCell.self, forCellReuseIdentifier: "CourseList")
  }
  
  
  func setVwFooterBtnsCallPickupCourse(){
    btnServiceChat = UIButton(frame: CGRectMake(self.view.frame.origin.x,self.view.frame.height-40,(self.view.frame.width/3)-50,40))
    btnServiceChat.setImage(UIImage(named: "servicechat.png"), forState: UIControlState.Normal)
    btnServiceChat.addTarget(self, action: "btnServiceChatTapped:", forControlEvents: UIControlEvents.TouchUpInside)
    //btnServiceChat.backgroundColor = UIColor.redColor()
    self.view.addSubview(btnServiceChat)
    
    btnCall = UIButton(frame: CGRectMake(btnServiceChat.frame.origin.x+btnServiceChat.frame.width,btnServiceChat.frame.origin.y, btnServiceChat.frame.width,btnServiceChat.frame.height ))
    btnCall.setImage(UIImage(named: "call.png"), forState: UIControlState.Normal)
    //btnCall.backgroundColor = UIColor.redColor()
    btnCall.addTarget(self, action: "btnCallTapped:", forControlEvents: UIControlEvents.TouchUpInside)
    self.view.addSubview(btnCall)
    
    btnbuy = UIButton(frame: CGRectMake(btnCall.frame.origin.x+btnCall.frame.width, btnCall.frame.origin.y,self.view.frame.width - (btnCall.frame.origin.x+btnCall.frame.width), 40))
    btnbuy.setTitle("Buy", forState: UIControlState.Normal)
    btnbuy.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
    btnbuy.titleLabel?.font = btnbuy.titleLabel?.font.fontWithSize(15)
    btnbuy.backgroundColor = UIColor(red: 237.0/255.0, green: 62.0/255.0, blue: 61.0/255.0,alpha:1.0)
    btnbuy.addTarget(self, action: "btnBuyTapped:", forControlEvents: UIControlEvents.TouchUpInside)
    self.view.addSubview(btnbuy)
    
   tableview = UITableView(frame: CGRectMake(self.view.frame.origin.x,horiVw.frame.origin.y+5,self.view.frame.width, btnbuy.frame.origin.y-horiVw2.frame.origin.y-10))
    
  }
  
  func setVwFooterBtnsCallTryClass(){
    
    btnHaveClass = UIButton(frame: CGRectMake(self.view.frame.origin.x+20, self.view.frame.height-50, self.view.frame.width-40, 40))
    btnHaveClass.setTitle("Have class videos", forState: UIControlState.Normal)
    btnHaveClass.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
    btnHaveClass.titleLabel?.font = btnHaveClass.titleLabel?.font.fontWithSize(15)
    btnHaveClass.backgroundColor = UIColor(red: 237.0/255.0, green: 62.0/255.0, blue: 61.0/255.0,alpha:1.0)
    btnHaveClass.addTarget(self, action: "btnHaveClasstapped", forControlEvents: UIControlEvents.TouchUpInside)
    self.view.addSubview(btnHaveClass)

    
    tableview = UITableView(frame: CGRectMake(self.view.frame.origin.x,horiVw.frame.origin.y+5,self.view.frame.width, btnHaveClass.frame.origin.y-horiVw2.frame.origin.y-10))
    
  }
  
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    var count: NSInteger = 0
    if(btnTag == 1){
      count = dataArr.count
    }else if(btnTag == 2){
      if(arrOutline.count != 0){
       let dict = arrOutline.objectAtIndex(section) as! NSDictionary
      let arry = dict.valueForKey("array") as! NSArray
      print(arry.count)
      count = arry.count
      }
    }
    return count
  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    var count: NSInteger = 0
    if(btnTag == 1){
      count = 1
    }else if(btnTag == 2){
      count = arrOutline.count
    }
    return count
  }
  
//  func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
////    let dict = arrOutline.objectAtIndex(section) as NSDictionary
////    let obj = dict.valueForKey("module") as ClsOutLineModule
//    
//    
//    return 30
//  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    
    var height: CGFloat!
    if(btnTag == 1){
      if(indexPath.row==0){
         height = 70
      }else{
        let dictData = dataArr.objectAtIndex(indexPath.row) as! NSDictionary
        let str = dictData.valueForKey("data") as! NSString
       
        var rect: CGRect! = str.boundingRectWithSize(CGSize(width:self.view.frame.size.width-60,height:300), options:NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(16)], context: nil)

        height = 50+rect.height
      }
      
    }else if(btnTag == 2){
      let dict = arrOutline.objectAtIndex(indexPath.section) as! NSDictionary
      let arry = dict.valueForKey("array") as! NSArray
      let obj = arry.objectAtIndex(indexPath.row) as! ClsModElement
      var str = obj.mod_element_content
      var rect: CGRect! = str.boundingRectWithSize(CGSize(width:self.view.frame.size.width-60,height:300), options:NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(16)], context: nil)
      height = 50+rect.height
    }else if(btnTag == 3){
      let dict = arrOutline.objectAtIndex(indexPath.section) as! NSDictionary
      let arry = dict.valueForKey("array") as! NSArray
      let obj = arry.objectAtIndex(indexPath.row) as! ClsModElement
      var str = obj.mod_element_content
      var rect: CGRect! = str.boundingRectWithSize(CGSize(width:self.view.frame.size.width-60,height:300), options:NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(16)], context: nil)
      height = 50+rect.height

    }
    
    return height
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell:UITableViewCell!
    var dictDetail:NSDictionary!
    if(btnTag == 1){
      var cell: CourseDetailTableViewCell  = tableview.dequeueReusableCellWithIdentifier("cell") as! CourseDetailTableViewCell
      cell.selectionStyle = UITableViewCellSelectionStyle.None
      dictDetail = dataArr.objectAtIndex(indexPath.row) as! NSDictionary
      cell.defaultCellContentForCourseDetail(dictDetail, btnIndex: btnTag,frame: self.view.frame)
      return cell

    } else if(btnTag == 2){
      var cell: CourseListCell!  = tableview.dequeueReusableCellWithIdentifier("CourseList") as! CourseListCell
      cell.selectionStyle = UITableViewCellSelectionStyle.None
      if(arrOutline.count>0){
        let dict = arrOutline.objectAtIndex(indexPath.section) as! NSDictionary
        let arry = dict.valueForKey("array") as! NSArray
        let obj = arry.objectAtIndex(indexPath.row) as! ClsModElement
        cell.textLabel!.text = obj.mod_element_content
        cell.textLabel!.numberOfLines = 0
      }else{
        cell.textLabel!.text = ""
      }
      cell.textLabel!.textColor = UIColor.grayColor()
      cell.textLabel!.frame = CGRectMake(2, 2, self.view.frame.width-20,30)
      return cell
    }else if(btnTag == 3){
      var cell: CourseListCell!  = tableview.dequeueReusableCellWithIdentifier("CourseList") as! CourseListCell
      cell.selectionStyle = UITableViewCellSelectionStyle.None
      if(arrOutline.count>0){
        let dict = arrOutline.objectAtIndex(indexPath.section) as! NSDictionary
        let arry = dict.valueForKey("array") as! NSArray
        let obj = arry.objectAtIndex(indexPath.row) as! ClsModElement
        cell.textLabel!.text = obj.mod_element_content
        cell.textLabel!.numberOfLines = 0
      }else{
        cell.textLabel!.text = ""
      }
      cell.textLabel!.textColor = UIColor.grayColor()
      cell.textLabel!.frame = CGRectMake(2, 2, self.view.frame.width-20,30)
      return cell
    }
    return cell
  }
  
  
  func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    var vWheader: UIView!
    if(btnTag == 1){
      return vWheader
    }else if(btnTag == 2){
      vWheader = UIView(frame: CGRectMake(5,5,self.view.frame.width, 40))
      vWheader.backgroundColor = UIColor.whiteColor()
      vWheader.layer.borderWidth = 0.5
      vWheader.layer.borderColor = UIColor.lightGrayColor().CGColor
      vWheader.backgroundColor = UIColor(red: 71.0/255.0, green: 168.0/255.0, blue: 184.0/255.0,alpha:1.0)
  
      var lbltilte: UILabel! = UILabel(frame: CGRectMake(10,2,vWheader.frame.width-10,20))
      lbltilte.font = lbltilte.font.fontWithSize(12)
      lbltilte.textColor = UIColor.whiteColor()
      lbltilte.text = " "
      lbltilte.numberOfLines = 0
      vWheader.addSubview(lbltilte)
      
      if(arrOutline.count>0){
        let dict = arrOutline.objectAtIndex(section) as! NSDictionary
        let obj = dict.valueForKey("module") as! ClsOutLineModule
        lbltilte.text = obj.mod_content
      }
      
      return vWheader
    }
    return vWheader
    
  }
  
  func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if(btnTag == 1){
      return ""
    }else if(btnTag == 2){
      return "Module"
    }
    return nil
  }

  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func btnBuyTapped(sender:AnyObject){
    let vc = self.storyboard?.instantiateViewControllerWithIdentifier("OrderConfID") as! OrderConfViewController
    vc.clsDict = clsDictDe
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  func btnHaveClasstapped(){
    let vc = self.storyboard?.instantiateViewControllerWithIdentifier("VideoID") as! VideoViewControler
        vc.classID = self.clsDictDe.valueForKey("id") as! NSInteger
        vc.isActive = "Free"
        self.navigationController?.pushViewController(vc, animated: true)
  }
  
  
  func btnBackTapped(){
    self.navigationController?.popViewControllerAnimated(true)
  }
  
  func btnforwardTapped(){
    let vc = self.storyboard?.instantiateViewControllerWithIdentifier("FeedbackID") as! FeedbackViewController
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  func btnCourseDetailtapped(sender:AnyObject){
    var btn = sender as! UIButton
    btnTag = btn.tag
    horiVw.backgroundColor = UIColor(red: 66.0/255.0, green: 150.0/255.0, blue: 173.0/255.0,alpha:1.0)
    horiVw1.backgroundColor = UIColor.lightGrayColor()
    horiVw2.backgroundColor = UIColor.lightGrayColor()
  
    tableview.reloadData()
  }
  
  func btnCourseListapped(sender:AnyObject){
    var btn = sender as! UIButton
    btnTag = btn.tag
    println(btnTag)
    
    horiVw.backgroundColor = UIColor.lightGrayColor()
    horiVw1.backgroundColor = UIColor(red: 66.0/255.0, green: 150.0/255.0, blue: 173.0/255.0,alpha:1.0)
    horiVw2.backgroundColor = UIColor.lightGrayColor()
    self.tableview.reloadData()
    
  }
  
  func btnCourseAskingTapped(sender:AnyObject){
    var btn = sender as! UIButton
    btnTag = btn.tag
    println(btnTag)
    
    horiVw.backgroundColor = UIColor.lightGrayColor()
    horiVw1.backgroundColor = UIColor(red: 66.0/255.0, green: 150.0/255.0, blue: 173.0/255.0,alpha:1.0)
    horiVw2.backgroundColor = UIColor.lightGrayColor()
    skypeIntegrationMethode()
  }
  
  func btnServiceChatTapped(sender:UIButton){
    skypeIntegrationMethode()
  }
  
  
  func skypeIntegrationMethode(){
    let vc = self.storyboard?.instantiateViewControllerWithIdentifier("AdminChatID") as! AdminChatViewController
    self.navigationController?.pushViewController(vc, animated:true)

//    var installed = UIApplication.sharedApplication().canOpenURL(NSURL(string: "skype:")!)
//    if(installed){
//      UIApplication.sharedApplication().openURL(NSURL(string: "skype:echo123?call")!)
//    }else{
//      UIApplication.sharedApplication().openURL(NSURL(string: "http://itunes.com/apps/skype/skype")!)
//    }
    
  }
  
  func btnCallTapped(sender:UIButton){
    if let cellularProvider  = CTTelephonyNetworkInfo().subscriberCellularProvider {
      if let mnCode = cellularProvider.mobileNetworkCode {
        println(mnCode)
        
       let phoneString = NSString(format: "tel://%@",serviceCallNo) as String
       UIApplication.sharedApplication().openURL(NSURL(string: phoneString)!)
     }
    } else {
     var alert: UIAlertView! = UIAlertView(title: "Alert", message: "Please check your network.", delegate: self, cancelButtonTitle: "Ok")
     alert.show()
    }
  }
  
  //********* Class Outline Api Calling Method *********
  
  func classOutlineApiCall(){
    
    var cls_id:NSInteger = self.clsDictDe.valueForKey("id") as! NSInteger
    var aParams: NSDictionary = NSDictionary(objects: [self.auth_token[0],cls_id], forKeys: ["auth-token","cls_id"])
    
    self.api.clsOutline(aParams as [NSObject : AnyObject], success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
      println(responseObject)
      let arry = responseObject as! NSArray
      if(arry.count != 0){
        self.arrOutline = responseObject as! NSArray
//        let dict = arry.objectAtIndex(0) as NSDictionary
//        let arry = dict.valueForKey("array") as NSArray
//        print(arry.count)
      }
      },
      failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
        println(error)
        if(self.btnTag == 2){
          var alert: UIAlertView! = UIAlertView(title: "Alert", message: "Sorry No data found.", delegate: self, cancelButtonTitle: "Ok")
          alert.show()
        }
    })
  }
  
  func adminContactApi(){
    
    var aParams: NSDictionary = NSDictionary(objects: self.auth_token, forKeys: ["auth-token"])
    
    self.api.getAdminContact(aParams as [NSObject : AnyObject], success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
      println(responseObject)
      self.dataFetchAdminContact()
      },
      failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
        println(error)
        
    })
  }
  
  func dataFetchAdminContact(){
    var arry = AdminContact .MR_findAll() as NSArray
    if(arry.count>0){
    var obj = arry.objectAtIndex(0) as! AdminContact
    serviceCallNo = obj.admin_contact_no
      print(serviceCallNo)
    }
  
  }


  
  
}
