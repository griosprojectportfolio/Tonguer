//
//  CourseDetailViewController.swift
//  Tonguer
//
//  Created by GrepRuby on 02/04/15.
//  Copyright (c) 2015 GrepRuby. All rights reserved.
//

import UIKit

class CourseDetailViewController: BaseViewController,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate {
  
  var callVw:NSString!
  
  var barBackBtn :UIBarButtonItem!
  var barforwordBtn :UIBarButtonItem!
  
  var tableview: UITableView!
  var imgVw: UIImageView!
  var btnCourseDetail: UIButton!
  var btnCourselist: UIButton!
  var btnCourseask: UIButton!
  var btnCDetail: UIButton!
  var horiVw: UIView!
  var horiVw1: UIView!
  var horiVw2: UIView!
  
  var btnHaveClass: UIButton!
  var btnServiceChat: UIButton!
  var btnCall: UIButton!
  var btnbuy: UIButton!
  var dataArr: NSArray!
  var dict1: NSDictionary!
  var dict2: NSDictionary!
  var dict3: NSDictionary!
  var dict4: NSDictionary!
  var dict5: NSDictionary!
  
  var clistarr: NSArray!
  var dictClist: NSDictionary!
  
  var clsDictDe: NSDictionary!
  
  var btnTag: NSInteger! = 1
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.defaultUIDesign()
    
    print(clsDictDe)
    
    var strName: NSString! = clsDictDe.objectForKey("name") as NSString
    //var price: NSInteger! = clsDictDe.objectForKey("price") as NSInteger
    
    dict1 = NSDictionary(objects: [clsDictDe.objectForKey("name") as NSString,"0","0"], forKeys: ["coursename","courserate","id"])
    dict2 = NSDictionary(objects: ["course.png","Arrange",clsDictDe.valueForKey("arrange") as NSString,"1"], forKeys: ["image","tilte","data","id"])
    dict3 = NSDictionary(objects: ["userred.png","Suitable for user",clsDictDe.valueForKey("suitable") as NSString,"2"], forKeys: ["image","tilte","data","id"])
    dict4 = NSDictionary(objects: ["target.png","Target for",clsDictDe.valueForKey("target") as NSString,"3"], forKeys: ["image","tilte","data","id"])
    
    dataArr = NSArray(objects: dict1,dict2,dict3,dict4)
    
    dictClist = NSDictionary(objects: ["img2.png","jdhdjdjdhsdjdsjsdhdjs"], forKeys: ["image","title"])
    clistarr = NSArray(object: dictClist)
  }
  
  func defaultUIDesign(){
    self.title = "Class Detail"
    self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
    
    self.navigationItem.setHidesBackButton(true, animated:false)
    
    var backbtn:UIButton = UIButton(frame: CGRectMake(0, 0,25,25))
    backbtn.setImage(UIImage(named: "whiteback.png"), forState: UIControlState.Normal)
    backbtn.addTarget(self, action: "btnBackTapped", forControlEvents: UIControlEvents.TouchUpInside)
    
    barBackBtn = UIBarButtonItem(customView: backbtn)
    
    self.navigationItem.setLeftBarButtonItem(barBackBtn, animated: true)
    
    imgVw = UIImageView(frame: CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y+64, self.view.frame.size.width, 200))
    let url = NSURL(string: clsDictDe.objectForKey("image") as NSString)
    let data = NSData(contentsOfURL: url!)
    imgVw.image = UIImage(data: data!)
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
    btnCourselist.setTitle("Class list", forState: UIControlState.Normal)
    btnCourselist.tag = 2
    btnCourselist.titleLabel?.font = btnCourselist.titleLabel?.font.fontWithSize(12)
    btnCourselist.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
    //btnCourselist.backgroundColor = UIColor.greenColor()
    btnCourselist.addTarget(self, action: "btnCourseListapped:", forControlEvents: UIControlEvents.TouchUpInside)
    self.view.addSubview(btnCourselist)
    
     horiVw1 = UIView(frame: CGRectMake(btnCourselist.frame.origin.x,btnCourselist.frame.origin.y+btnCourselist.frame.height , btnCourselist.frame.width, 1))
    horiVw1.backgroundColor = UIColor(red: 66.0/255.0, green: 150.0/255.0, blue: 173.0/255.0,alpha:1.0)
    horiVw1.hidden = true
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
    horiVw2.backgroundColor = UIColor(red: 66.0/255.0, green: 150.0/255.0, blue: 173.0/255.0,alpha:1.0)
    horiVw2.hidden = true
    self.view.addSubview(horiVw2)
    
    var vertiVw2: UIView! = UIView(frame: CGRectMake(btnCourseask.frame.origin.x+btnCourseask.frame.width,btnCourseask.frame.origin.y,1,btnCourseask.frame.height))
    vertiVw2.backgroundColor = UIColor.grayColor()
    self.view.addSubview(vertiVw2)
    
    if(callVw.isEqualToString("Pay")){
     self.setVwFooterBtnsCallPickupCourse()
    }else if(callVw.isEqualToString("Free")){
      self.setVwFooterBtnsCallTryClass()
      btnCourselist.userInteractionEnabled = false
    }
    
    tableview.delegate = self
    tableview.dataSource = self
    //tableview.backgroundColor = UIColor.grayColor()
    tableview.separatorStyle = UITableViewCellSeparatorStyle.None
    self.view.addSubview(tableview)
    tableview.registerClass(CourseDetailTableViewCell.self, forCellReuseIdentifier: "cell")
    tableview.registerClass(CourseListCell.self, forCellReuseIdentifier: "CourseList")
  }
  
  
  func setVwFooterBtnsCallPickupCourse(){
    btnServiceChat = UIButton(frame: CGRectMake(self.view.frame.origin.x,self.view.frame.height-40,(self.view.frame.width/3)-50,40))
    btnServiceChat.setImage(UIImage(named: "servicechat.png"), forState: UIControlState.Normal)
    //btnServiceChat.backgroundColor = UIColor.redColor()
    self.view.addSubview(btnServiceChat)
    
    btnCall = UIButton(frame: CGRectMake(btnServiceChat.frame.origin.x+btnServiceChat.frame.width,btnServiceChat.frame.origin.y, btnServiceChat.frame.width,btnServiceChat.frame.height ))
    btnCall.setImage(UIImage(named: "call.png"), forState: UIControlState.Normal)
    //btnCall.backgroundColor = UIColor.redColor()
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
    var count: NSInteger!
    if(btnTag == 1){
      count = dataArr.count
    }else if(btnTag == 2){
      count = clistarr.count
    }else{
      count = dataArr.count
    }
    
    return count
  }
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    
    var height: CGFloat!
    if(btnTag == 1){
      height = 70
    }else if(btnTag == 2){
      height = 100
    }else{
      height = 70
    }
    
    return height
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell:UITableViewCell!
    var dictDetail:NSDictionary!
    if(btnTag == 1){
      var cell: CourseDetailTableViewCell  = tableview.dequeueReusableCellWithIdentifier("cell") as CourseDetailTableViewCell
      cell.selectionStyle = UITableViewCellSelectionStyle.None
      dictDetail = dataArr.objectAtIndex(indexPath.row) as NSDictionary
      cell.defaultCellContentForCourseDetail(dictDetail, btnIndex: btnTag)
      return cell

    } else if(btnTag == 2){
      var cell: CourseListCell!  = tableview.dequeueReusableCellWithIdentifier("CourseList") as CourseListCell
      cell.selectionStyle = UITableViewCellSelectionStyle.None
      dictDetail = clistarr.objectAtIndex(indexPath.row) as NSDictionary
      cell.defaultCellContenforCourselist(dictDetail)
      return cell
    }
    return cell
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func btnBuyTapped(sender:AnyObject){
    let vc = self.storyboard?.instantiateViewControllerWithIdentifier("OrderConfID") as OrderConfViewController
    vc.clsDict = clsDictDe
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  func btnHaveClasstapped(){
    let vc = self.storyboard?.instantiateViewControllerWithIdentifier("VideoID") as VideoViewControler
        vc.classID = self.clsDictDe.valueForKey("id") as NSInteger
        vc.isActive = "Free"
        self.navigationController?.pushViewController(vc, animated: true)
  }
  
  
  func btnBackTapped(){
    self.navigationController?.popViewControllerAnimated(true)
  }
  
  func btnforwardTapped(){
    let vc = self.storyboard?.instantiateViewControllerWithIdentifier("FeedbackID") as FeedbackViewController
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  func btnCourseDetailtapped(sender:AnyObject){
    var btn = sender as UIButton
    btnTag = btn.tag
    println(btnTag)
    horiVw.hidden = false
    horiVw1.hidden = true
    horiVw2.hidden = true
    tableview.reloadData()
  }
  
  func btnCourseListapped(sender:AnyObject){
    var btn = sender as UIButton
    btnTag = btn.tag
    println(btnTag)
    horiVw1.hidden = false
    horiVw.hidden = true
    horiVw2.hidden = true
  
    tableview.reloadData()
  }
  
  func btnCourseAskingTapped(sender:AnyObject){
    var btn = sender as UIButton
    btnTag = btn.tag
    println(btnTag)
    horiVw1.hidden = true
    horiVw.hidden = true
    horiVw2.hidden = false
    
    
  }
  

  
}
