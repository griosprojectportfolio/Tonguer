//
//  HomeViewController.swift
//  Tonguer
//
//  Created by GrepRuby on 06/04/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import UIKit
import Foundation

class HomeViewController:BaseViewController,UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

  let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate


  var hometableVw : UITableView!
  var imagePicker = UIImagePickerController()

  var btnTag: NSInteger! = 1

  var barBackBtn :UIBarButtonItem!
  var barforwordBtn :UIBarButtonItem!
  var blur:UIBlurEffect!
  var effectView:UIVisualEffectView!
  var imgVwAlpha,imgVwProfilrPic,imgVwblur :UIImageView!
  var lblMoney,lblScore,lblAleday,lblMoneytext,lblScoretext,lblAledaytext,lblblurVwtextTitle :UILabel!
  
  var btnsView :UIView!
  var useImgUrl: NSString!
  var btn1,btn2,btn3,btnMiddleNavi:UIButton!
  var HorizVw3,HorizVw,HorizVw2,alredayVW: UIView!
 
  var tapGuesture:UITapGestureRecognizer!

  var btnFreeOpentryCls :UIButton!
  var leftswip: UISwipeGestureRecognizer!

  var arrclass: NSMutableArray!
  var arrClsLearn: NSMutableArray! = NSMutableArray()
  var arrClsLearned: NSMutableArray! = NSMutableArray()

  var api: AppApi!

  override func viewDidLoad() {
    super.viewDidLoad()
    arrclass = NSMutableArray()
    print(auth_token)
    leftswip = UISwipeGestureRecognizer()
    leftswip.addTarget(self, action: "leftswipeGestureRecognizer")
    leftswip.direction = UISwipeGestureRecognizerDirection.Left
    //leftswip.delegate = self
    self.appDelegate.objSideBar.addGestureRecognizer(leftswip)
    api = AppApi.sharedClient()
    self.defaultUIDesign()
    var date: NSDate! = NSDate()

    //updateDeviceTokenCall()
    self.fetchDataFromDBforDefaultCls()
    self.fetchDataFromDBforLearnCls()
    self.fetchDataFromDBforLearnedCls()
    self.hometableVw.reloadData()
    

    if (NSUserDefaults.standardUserDefaults().valueForKey("checkIns") == nil) {
      return;
    }
    findDifferenceIndates() //difference in date
  }

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  override func viewWillAppear(animated: Bool) {
    //self.userClassApiCall()
    self.fetchDataFromdataBase()
      self.userClassApiCall()
      self.userLearnClsApiCall()
      self.userLearnedClsApiCall()
      self.userScoreApiCall()
  }

  func rightswipeGestureRecognizer(){

    UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
      self.appDelegate.objSideBar.frame = self.view.bounds
      self.appDelegate.objSideBar.sideNavigation = self.navigationController
      }, completion: nil)

  }

  func leftswipeGestureRecognizer(){

    UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
      self.appDelegate.objSideBar.frame = CGRectMake(-(self.view.frame.width),self.view.frame.origin.y, self.view.frame.width, self.view.frame.height)
      }, completion: nil)

  }


  func defaultUIDesign(){
    self.title = "Home"
    
    self.navigationItem.setHidesBackButton(true, animated:false)


    btnMiddleNavi = UIButton(frame: CGRectMake(0, 0, 50, 25))
    btnMiddleNavi.setTitle("Check in", forState: UIControlState.Normal)
    btnMiddleNavi.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
    btnMiddleNavi.titleLabel?.font = btnMiddleNavi.titleLabel?.font.fontWithSize(10)
    btnMiddleNavi.layer.cornerRadius = 5
    btnMiddleNavi.layer.borderWidth = 1
    btnMiddleNavi.layer.borderColor = UIColor.whiteColor().CGColor
    btnMiddleNavi.addTarget(self, action: "btnNaviCheckInTapped:", forControlEvents: UIControlEvents.TouchUpInside)

    self.navigationItem.titleView = btnMiddleNavi


    var backbtn:UIButton = UIButton(frame: CGRectMake(0, 0,25,25))
    backbtn.setImage(UIImage(named: "sideIcon.png"), forState: UIControlState.Normal)
    backbtn.addTarget(self, action: "rightswipeGestureRecognizer", forControlEvents: UIControlEvents.TouchUpInside)

    barBackBtn = UIBarButtonItem(customView: backbtn)
    self.navigationItem.setLeftBarButtonItem(barBackBtn, animated: true)

    var btnforword:UIButton = UIButton(frame: CGRectMake(0, 0,25,25))
    btnforword.setImage(UIImage(named: "Alert.png"), forState: UIControlState.Normal)
    btnforword.addTarget(self, action: "btnAlertTapped", forControlEvents: UIControlEvents.TouchUpInside)

    barforwordBtn = UIBarButtonItem(customView: btnforword)

    self.navigationItem.setRightBarButtonItem(barforwordBtn, animated: true)

    imgVwblur = UIImageView(frame: CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+64,self.view.frame.width,180))
    imgVwblur.image = UIImage(named: "User.png")
    imgVwblur.userInteractionEnabled = true
    self.view.addSubview(imgVwblur)

    imgVwAlpha = UIImageView()
    imgVwAlpha.frame = imgVwblur.bounds
    imgVwAlpha.userInteractionEnabled = true
    imgVwAlpha.backgroundColor = UIColor(white: 1.0, alpha:0.91)
    imgVwblur.addSubview(imgVwAlpha)


    lblblurVwtextTitle = UILabel(frame: CGRectMake((imgVwAlpha.frame.size.width-200)/2+10, imgVwAlpha.frame.origin.y+30,200, 30))
    lblblurVwtextTitle.text = "User Name"
    lblblurVwtextTitle.textAlignment = NSTextAlignment.Center
    //lblblurVwtextTitle.backgroundColor = UIColor.redColor()
    imgVwAlpha.addSubview(lblblurVwtextTitle)

    imgVwProfilrPic = UIImageView(frame: CGRectMake(imgVwAlpha.frame.origin.x+10,lblblurVwtextTitle.frame.origin.y+50,90,80))
    imgVwProfilrPic.image = UIImage(named: "User.png")
    //imgVwProfilrPic.backgroundColor = UIColor.grayColor()
    imgVwProfilrPic.layer.borderWidth = 5
    imgVwProfilrPic.layer.borderColor = UIColor.whiteColor().CGColor
    imgVwAlpha.addSubview(imgVwProfilrPic)

    var btnProfilePic: UIButton! = UIButton(frame:CGRectMake(imgVwProfilrPic.frame.origin.x,imgVwProfilrPic.frame.origin.y + imgVwProfilrPic.frame.height, imgVwProfilrPic.frame.width,imgVwProfilrPic.frame.height))
    //btnProfilePic.backgroundColor = UIColor.redColor()
    btnProfilePic.addTarget(self, action: "btnProfileTapped", forControlEvents: UIControlEvents.TouchUpInside)
    self.view.addSubview(btnProfilePic)
    self.view.bringSubviewToFront(btnProfilePic)

    lblMoney = UILabel(frame: CGRectMake(imgVwProfilrPic.frame.origin.x+imgVwProfilrPic.frame.size.width+10, imgVwProfilrPic.frame.origin.y+13,50,30))
    lblMoney.text = "0.0"
    //lblMoney.textAlignment = NSTextAlignment.Center
    lblMoney.font = lblMoney.font.fontWithSize(20)
    lblMoney.textColor = UIColor.grayColor()
    //lblMoney.backgroundColor = UIColor.redColor()
    imgVwAlpha.addSubview(lblMoney)

    lblMoneytext = UILabel(frame: CGRectMake(lblMoney.frame.origin.x,lblMoney.frame.size.height+lblMoney.frame.origin.y,50,15))
    lblMoneytext.text = "Money"
    //lblMoneytext.textAlignment = NSTextAlignment.Center
    lblMoneytext.font = lblMoney.font.fontWithSize(12)
    lblMoneytext.textColor = UIColor.grayColor()
    //lblMoneytext.backgroundColor = UIColor.greenColor()
    imgVwAlpha.addSubview(lblMoneytext)

    lblScore = UILabel(frame: CGRectMake(lblMoney.frame.origin.x+lblMoney.frame.size.width+20, lblMoney.frame.origin.y,40,30))
    lblScore.text = "0"
    //lblScore.textAlignment = NSTextAlignment.Center
    lblScore.font = lblMoney.font.fontWithSize(20)
    lblScore.textColor = UIColor.grayColor()
    //lblScore.backgroundColor = UIColor.redColor()
    imgVwAlpha.addSubview(lblScore)

    lblScoretext = UILabel(frame: CGRectMake(lblScore.frame.origin.x,lblScore.frame.origin.y+lblScore.frame.size.height, 40, 15))
    lblScoretext.text = "Score"
    //lblMoneytext.textAlignment = NSTextAlignment.Center
    lblScoretext.font = lblMoney.font.fontWithSize(12)
    lblScoretext.textColor = UIColor.grayColor()
    //lblScoretext.backgroundColor = UIColor.greenColor()
    imgVwAlpha.addSubview(lblScoretext)
    
    

    lblAleday = UILabel(frame: CGRectMake(lblScore.frame.origin.x+lblScore.frame.size.width+20, lblScore.frame.origin.y,80,30))
    lblAleday.text = "0      >"
    //lblAleday.textAlignment = NSTextAlignment.Center
    lblAleday.font = lblMoney.font.fontWithSize(20)
    lblAleday.textColor = UIColor.grayColor()
    lblAleday.userInteractionEnabled = true
    //lblAleday.backgroundColor = UIColor.redColor()
    imgVwAlpha.addSubview(lblAleday)

    lblAledaytext = UILabel(frame: CGRectMake(lblAleday.frame.origin.x, lblAleday.frame.origin.y+lblAleday.frame.size.height,60,15))
    lblAledaytext.text = "Already"
    //lblMoneytext.textAlignment = NSTextAlignment.Center
    lblAledaytext.font = lblMoney.font.fontWithSize(12)
    lblAledaytext.textColor = UIColor.grayColor()
    //lblAledaytext.backgroundColor = UIColor.greenColor()
    imgVwAlpha.addSubview(lblAledaytext)
    
    tapGuesture = UITapGestureRecognizer(target:self, action:"alredayTapGuesture")
    
    alredayVW = UIView(frame: CGRectMake(lblAleday.frame.origin.x,lblAleday.frame.origin.y,60,50))
    //alredayVW.backgroundColor = UIColor.lightGrayColor()
    alredayVW.userInteractionEnabled = true
    alredayVW.addGestureRecognizer(tapGuesture)
    imgVwAlpha.addSubview(alredayVW)

    btn1 = UIButton(frame: CGRectMake(self.view.frame.origin.x,imgVwblur.frame.origin.y+imgVwblur.frame.size.height+5,self.view.frame.width/3,40))
    //btn1.backgroundColor = UIColor.grayColor()
    btn1.tag = 1
    btn1.setTitle("Default list", forState: UIControlState.Normal)
    btn1.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
    btn1.addTarget(self, action: "btnDefaultTapped:", forControlEvents: UIControlEvents.TouchUpInside)
    self.view.addSubview(btn1)


    HorizVw = UIView(frame: CGRectMake(btn1.frame.origin.x,btn1.frame.origin.y+btn1.frame.size.height , btn1.frame.size.width, 1))
    HorizVw.backgroundColor = UIColor(red: 66.0/255.0, green: 150.0/255.0, blue: 173.0/255.0,alpha:1.0)
    self.view.addSubview(HorizVw)

    var vertiVw :UIView!
    vertiVw = UIView(frame: CGRectMake(btn1.frame.origin.x+btn1.frame.size.width,btn1.frame.origin.y,1, btn1.frame.height))
    vertiVw.backgroundColor = UIColor.grayColor()
    self.view.addSubview(vertiVw)

    btn2 = UIButton(frame: CGRectMake(btn1.frame.origin.x+btn1.frame.size.width,btn1.frame.origin.y,btn1.frame.width, 40))
    //btn2.backgroundColor = UIColor.grayColor()
    btn2.tag = 2
    btn2.setTitle("Learn list", forState: UIControlState.Normal)
    btn2.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
    btn2.addTarget(self, action: "btnLearnlistTapped:", forControlEvents: UIControlEvents.TouchUpInside)
    self.view.addSubview(btn2)


    HorizVw2 = UIView(frame: CGRectMake(btn2.frame.origin.x,btn2.frame.origin.y+btn2.frame.size.height , btn2.frame.size.width, 1))
    HorizVw2.backgroundColor = UIColor.grayColor()
    self.view.addSubview(HorizVw2)

    var vertiVw2 :UIView!
    vertiVw2 = UIView(frame: CGRectMake(btn2.frame.origin.x+btn2.frame.size.width,btn2.frame.origin.y,1, btn2.frame.height))
    vertiVw2.backgroundColor = UIColor.lightGrayColor()
    self.view.addSubview(vertiVw2)

    btn3 = UIButton(frame: CGRectMake(btn2.frame.origin.x+btn2.frame.size.width,btn2.frame.origin.y,btn2.frame.width, 40))
    // btn3.backgroundColor = UIColor.grayColor()
    btn3.tag = 3
    btn3.setTitle("Learend", forState: UIControlState.Normal)
    btn3.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
    btn3.addTarget(self, action: "btnLearnedTapped:", forControlEvents: UIControlEvents.TouchUpInside)
    self.view.addSubview(btn3)


    HorizVw3 = UIView(frame: CGRectMake(btn3.frame.origin.x,btn3.frame.origin.y+btn3.frame.size.height, btn3.frame.size.width, 1))
    HorizVw3.backgroundColor =  UIColor.lightGrayColor()
    self.view.addSubview(HorizVw3)

    btnFreeOpentryCls = UIButton(frame: CGRectMake(self.view.frame.origin.x+10,self.view.frame.height-50, self.view.frame.width-20, 40))
    btnFreeOpentryCls.setTitle("Free Open Try class", forState: UIControlState.Normal)
    btnFreeOpentryCls.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
    btnFreeOpentryCls.backgroundColor = UIColor(red: 66.0/255.0, green: 150.0/255.0, blue: 173.0/255.0,alpha:1.0)
    btnFreeOpentryCls.addTarget(self, action: "btnFreeOpenTryClasstapped", forControlEvents: UIControlEvents.TouchUpInside)

    self.view.addSubview(btnFreeOpentryCls)

    hometableVw = UITableView(frame:CGRectMake(btn1.frame.origin.x,btn1.frame.origin.y+btn1.frame.size.height+1,self.view.frame.width-10,btnFreeOpentryCls.frame.origin.y-btn1.frame.origin.y+btn1.frame.size.height-80))
    hometableVw.delegate = self
    hometableVw.dataSource = self
    // hometableVw.backgroundColor = UIColor.grayColor()
    hometableVw.separatorStyle = UITableViewCellSeparatorStyle.None
    self.view.addSubview(hometableVw)
    hometableVw.registerClass(HomeTableViewCell.self, forCellReuseIdentifier: "cell")
    hometableVw.registerClass(LearnTableViewCell.self, forCellReuseIdentifier: "LearnCell")
    hometableVw.registerClass(LearnedTableViewCell.self, forCellReuseIdentifier: "LearnedCell")
  }
  
  
  func alredayTapGuesture(){
    var vc = self.storyboard?.instantiateViewControllerWithIdentifier("LearnStatusID") as LearnStatusViewController
    self.navigationController?.pushViewController(vc, animated: true)
  }

  func btnNaviCheckInTapped(sender:AnyObject){
    btnMiddleNavi.backgroundColor = UIColor.grayColor()
    print("Check In")
    btnMiddleNavi.enabled = false

    self.findDifferenceIndates()
  }

  func findDifferenceIndates() {

    let currentDate = NSDate()

    if (NSUserDefaults.standardUserDefaults().valueForKey("checkIns") == nil) {

      NSUserDefaults.standardUserDefaults().setValue(currentDate, forKey: "checkIns")
      NSUserDefaults.standardUserDefaults().synchronize()
      btnMiddleNavi.enabled = false
      btnMiddleNavi.backgroundColor = UIColor.grayColor()
      return;
    }
    let previousCheckDate = NSUserDefaults.standardUserDefaults().valueForKey("checkIns") as NSDate

    var calendar: NSCalendar = NSCalendar.currentCalendar()
    let dateCheckIn = calendar.startOfDayForDate(previousCheckDate)
    let dateCurrent = calendar.startOfDayForDate(currentDate)

    let flags = NSCalendarUnit.DayCalendarUnit
    let components = calendar.components(flags, fromDate: dateCheckIn, toDate: dateCurrent, options: nil)

    if components.day > 0 {

      NSUserDefaults.standardUserDefaults().setValue(currentDate, forKey: "checkIns")
      NSUserDefaults.standardUserDefaults().synchronize()
      btnMiddleNavi.backgroundColor = UIColor.grayColor()
      // btnMiddleNavi.enabled = false
    }
    if components.day == 0 {
      btnMiddleNavi.backgroundColor = UIColor.grayColor()
      // btnMiddleNavi.enabled = false
    }
    print( NSUserDefaults.standardUserDefaults().valueForKey("checkIns"))
  }

  func btnFreeOpenTryClasstapped(){
    let vc = self.storyboard?.instantiateViewControllerWithIdentifier("ClassCenterID") as ClassCenterViewController
    self.navigationController?.pushViewController(vc, animated: true)
  }

  func btnDefaultTapped(sender:AnyObject){
    var btn = sender as UIButton
    btnTag = btn.tag
    print("Default List")
    HorizVw.backgroundColor  = UIColor(red: 66.0/255.0, green: 150.0/255.0, blue: 173.0/255.0,alpha:1.0)
    HorizVw2.backgroundColor = UIColor.lightGrayColor()
    HorizVw3.backgroundColor = UIColor.lightGrayColor()
    hometableVw.reloadData()
  }

  func btnLearnlistTapped(sender:AnyObject){
    var btn = sender as UIButton
    btnTag = btn.tag
    print("Learn List")
    HorizVw.backgroundColor  = UIColor.lightGrayColor()
    HorizVw2.backgroundColor = UIColor(red: 66.0/255.0, green: 150.0/255.0, blue: 173.0/255.0,alpha:1.0)
    HorizVw3.backgroundColor = UIColor.lightGrayColor()

    hometableVw.reloadData()
  }

  func btnLearnedTapped(sender:AnyObject){
    var btn = sender as UIButton
    btnTag = btn.tag
    print("Learn List")

    HorizVw.backgroundColor  = UIColor.lightGrayColor()
    HorizVw2.backgroundColor = UIColor.lightGrayColor()
    HorizVw3.backgroundColor = UIColor(red: 66.0/255.0, green: 150.0/255.0, blue: 173.0/255.0,alpha:1.0)

    hometableVw.reloadData()
  }

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    var count:NSInteger!
    if(btnTag == 1){
      count = arrclass.count
    }else if(btnTag == 2){
      count = arrClsLearn.count
    }else if(btnTag == 3){
      count = arrClsLearned.count
    }

    return count
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell: UITableViewCell!

    if(btnTag == 1){
      var  cell = tableView.dequeueReusableCellWithIdentifier("cell") as HomeTableViewCell
      cell.selectionStyle = UITableViewCellSelectionStyle.None
      cell.defaultCellContent(arrclass.objectAtIndex(indexPath.row)as NSDictionary,Frame: self.view.frame)
      return cell
    } else if (btnTag == 2){
      var  cell = tableView.dequeueReusableCellWithIdentifier("LearnCell") as LearnTableViewCell
      cell.selectionStyle = UITableViewCellSelectionStyle.None
      cell.defaultCellContent(arrClsLearn.objectAtIndex(indexPath.row)as NSDictionary,Frame: self.view.frame)
      return cell
    } else if (btnTag == 3){
      var  cell = tableView.dequeueReusableCellWithIdentifier("LearnedCell") as LearnedTableViewCell
      cell.selectionStyle = UITableViewCellSelectionStyle.None
      cell.defaultCellContent(arrClsLearned.objectAtIndex(indexPath.row)as NSDictionary,Frame: self.view.frame)
      return cell
    }

    return cell
  }

  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 110
  }


  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

    var dict: NSDictionary!

    if(btnTag == 1){
      dict = arrclass.objectAtIndex(indexPath.row) as NSDictionary
    }else if(btnTag == 2){
      dict = arrClsLearn.objectAtIndex(indexPath.row) as NSDictionary
    }else if(btnTag == 3){
      dict = arrClsLearned.objectAtIndex(indexPath.row) as NSDictionary
    }

    let vc = self.storyboard?.instantiateViewControllerWithIdentifier("LearnID") as StartLearnViewController
    vc.dictClasses = dict
    vc.useImgUrl = useImgUrl
    self.navigationController?.pushViewController(vc, animated: true)

  }
  //****** Update User Profile Pic ************
  func btnProfileTapped(){
    print("212112")
    if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum){

      imagePicker.delegate = self
      imagePicker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum;
      imagePicker.allowsEditing = false

      self.presentViewController(imagePicker, animated: true, completion: nil)
    }

  }

  func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
    self.dismissViewControllerAnimated(true, completion: { () -> Void in

    })
    imgVwProfilrPic.image = image
    imgVwblur.image = image
    self.UserUpadteApiCall(image)
  }

  func btnAlertTapped(){
    let vc = self.storyboard?.instantiateViewControllerWithIdentifier("AlertID") as AlertViewController
    self.navigationController?.pushViewController(vc, animated: true)
  }

  //****** Update User Recodes ans Api call ************

  func UserUpadteApiCall(image:UIImage){
    var imageData = UIImagePNGRepresentation(image)
    let base64String = imageData.base64EncodedStringWithOptions(.allZeros)
    //println(base64String)

    var aParam:NSMutableDictionary = NSMutableDictionary()
    aParam.setValue(self.auth_token[0], forKey: "auth_token")
    aParam.setValue(base64String, forKey: "user[image]")

    self.api.updateUser(aParam, success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
      println(responseObject)
      self.fetchDataFromdataBase()

      },
      failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
        println(error)

    })

  }
  
  
//  func updateDeviceTokenCall(){
//    
//    var aParam:NSMutableDictionary = NSMutableDictionary()
//    
//    let strDeviceToken = appDelegate.deviceTokenString
//    
//    aParam.setValue(self.auth_token[0], forKey: "auth_token")
//    aParam.setValue(strDeviceToken, forKey: "user[device_token]")
//    
//    self.api.updateUser(aParam, success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
//      println(responseObject)
//      
//      },
//      failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
//        println(error)
//        
//    })
//    
//  }



  //****** User Data fetch from database ************

  func fetchDataFromdataBase(){
    let arrFetchedData : NSArray = User.MR_findAll()
    if(arrFetchedData.count>0){
      let userObject : User = arrFetchedData.objectAtIndex(0) as User
      print(userObject.fname)
      let fname = userObject.fname
      let lname = userObject.lname
      var name: NSString!
      if((fname != nil && lname  != nil)){
        name = fname+" "+lname
      }else{
        name = ""
      }
      lblblurVwtextTitle.text = name
      
      if((userObject.money) != nil){
        lblMoney.text = userObject.money.stringValue
      }else{
        lblMoney.text = "0.0"
      }
      
      if((userObject.score) != nil){
        lblScore.text = userObject.score.stringValue
      }else{
        lblScore.text = "0.0"
      }
      
      if((userObject.pro_img) != nil){
        useImgUrl = userObject.pro_img as NSString
        let url = NSURL(string: userObject.pro_img as NSString)
        imgVwProfilrPic.sd_setImageWithURL(url, placeholderImage:UIImage(named: "User.png"))
        imgVwblur.sd_setImageWithURL(url, placeholderImage:UIImage(named: "User.png"))
      }else{
        useImgUrl = "http://idebate.org/sites/live/files/imagecache/150x150/default_profile.png"
        let url = NSURL(string: "http://idebate.org/sites/live/files/imagecache/150x150/default_profile.png" as NSString)
        imgVwProfilrPic.sd_setImageWithURL(url)
      }
    }
    
  }


  //****** User Data fetch from database for user default class ************

  func fetchDataFromDBforDefaultCls(){
    let arrFetchedData : NSArray = UserDefaultClsList.MR_findAll()

    arrclass.removeAllObjects()

    for var index = 0; index < arrFetchedData.count; ++index {
      let userClsObj : UserDefaultClsList = arrFetchedData.objectAtIndex(index) as UserDefaultClsList
      var dict: NSMutableDictionary! = NSMutableDictionary()

      dict.setObject(userClsObj.cls_id, forKey: "id")

      if((userClsObj.cls_name) != nil){
        dict.setObject(userClsObj.cls_name, forKey:"name")
      }else{
        dict.setObject("No Class Name", forKey:"name")
      }

      if((userClsObj.cls_img_url) != nil){
        var str_url: NSString = userClsObj.cls_img_url
        dict.setObject(str_url, forKey:"image")

      }else{
        var str_url: NSString = "http://www.popular.com.my/images/no_image.gif"
        dict.setObject(str_url, forKey:"image")
      }

      if((userClsObj.cls_vaild_days) != nil){
        dict.setObject(userClsObj.cls_vaild_days,forKey:"days")

      }else{
        dict.setObject("No Day",forKey:"days")
      }

      if((userClsObj.cls_score) != nil){
        dict.setObject(userClsObj.cls_score, forKey: "score")

      }else{
        dict.setObject("0.0", forKey: "score")
      }

      if((userClsObj.cls_price) != nil){
        dict.setObject(userClsObj.cls_price, forKey: "price")

      }else{
        dict.setObject("0.0", forKey: "price")
      }

      if((userClsObj.cls_progress) != nil){
        dict.setObject(userClsObj.cls_progress, forKey:"progress")

      }else{
        dict.setObject("0", forKey:"progress")
      }
      arrclass.addObject(dict)
    }

    print(arrclass.count)

  }

  //****** User Data fetch from database for user Learn class ************

  func fetchDataFromDBforLearnCls(){
    let arrFetchedData : NSArray = UserLearnClsList.MR_findAll()

    arrClsLearn.removeAllObjects()

    for var index = 0; index < arrFetchedData.count; ++index {
      let userClsObj : UserLearnClsList = arrFetchedData.objectAtIndex(index) as UserLearnClsList
      var dict: NSMutableDictionary! = NSMutableDictionary()

      dict.setObject(userClsObj.cls_id, forKey: "id")

      if((userClsObj.cls_name) != nil){
        dict.setObject(userClsObj.cls_name, forKey:"name")
      }else{
        dict.setObject("No Class Name", forKey:"name")
      }

      if((userClsObj.cls_img_url) != nil){
        var str_url: NSString = userClsObj.cls_img_url
        dict.setObject(str_url, forKey:"image")

      }else{
        var str_url: NSString = "http://www.popular.com.my/images/no_image.gif"
        dict.setObject(str_url, forKey:"image")
      }

      if((userClsObj.cls_vaild_days) != nil){
        dict.setObject(userClsObj.cls_vaild_days,forKey:"days")

      }else{
        dict.setObject("No Day",forKey:"days")
      }

      if((userClsObj.cls_score) != nil){
        dict.setObject(userClsObj.cls_score, forKey: "score")

      }else{
        dict.setObject("0.0", forKey: "score")
      }

      if((userClsObj.cls_price) != nil){
        dict.setObject(userClsObj.cls_price, forKey: "price")

      }else{
        dict.setObject("0.0", forKey: "price")
      }

      if((userClsObj.cls_progress) != nil){
        dict.setObject(userClsObj.cls_progress, forKey:"progress")

      }else{
        dict.setObject("0", forKey:"progress")
      }
      arrClsLearn.addObject(dict)
    }

    print(arrClsLearn.count)
    lblAleday.text = NSString(format: "%i",arrClsLearn.count)

  }

  //****** User Data fetch from database for user Learned class ************

  func fetchDataFromDBforLearnedCls(){
    let arrFetchedData : NSArray = UserLearnedClsList.MR_findAll()
    arrClsLearned.removeAllObjects()

    for var index = 0; index < arrFetchedData.count; ++index {
      let userClsObj : UserLearnedClsList = arrFetchedData.objectAtIndex(index) as UserLearnedClsList
      var dict: NSMutableDictionary! = NSMutableDictionary()

      dict.setObject(userClsObj.cls_id, forKey: "id")

      if((userClsObj.cls_name) != nil){
        dict.setObject(userClsObj.cls_name, forKey:"name")
      }else{
        dict.setObject("No Class Name", forKey:"name")
      }

      if((userClsObj.cls_img_url) != nil){
        var str_url: NSString = userClsObj.cls_img_url
        dict.setObject(str_url, forKey:"image")

      }else{
        var str_url: NSString = "http://www.popular.com.my/images/no_image.gif"
        dict.setObject(str_url, forKey:"image")
      }

      if((userClsObj.cls_vaild_days) != nil){
        dict.setObject(userClsObj.cls_vaild_days,forKey:"days")

      }else{
        dict.setObject("No Day",forKey:"days")
      }

      if((userClsObj.cls_score) != nil){
        dict.setObject(userClsObj.cls_score, forKey: "score")

      }else{
        dict.setObject("0.0", forKey: "score")
      }

      if((userClsObj.cls_price) != nil){
        dict.setObject(userClsObj.cls_price, forKey: "price")

      }else{
        dict.setObject("0.0", forKey: "price")
      }

      if((userClsObj.cls_progress) != nil){
        dict.setObject(userClsObj.cls_progress, forKey:"progress")

      }else{
        dict.setObject("0", forKey:"progress")
      }
      arrClsLearned.addObject(dict)
    }
    print(arrClsLearned.count)
  }

  func userLearnClsApiCall(){

    var aParams: NSDictionary = NSDictionary(objects: [self.auth_token[0]], forKeys: ["auth_token"])

    self.api.userLearnCls(aParams, success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
      println(responseObject)
        self.fetchDataFromDBforLearnCls()
      },
      failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
        println(error)
    })

  }

  func userLearnedClsApiCall(){

    var aParams: NSDictionary = NSDictionary(objects: [self.auth_token[0]], forKeys: ["auth_token"])

    self.api.userLearnedCls(aParams, success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
      println(responseObject)
        self.fetchDataFromDBforLearnedCls()
      },
      failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
        println(error)

    })
  }

  func userClassApiCall(){

    var aParams: NSDictionary = NSDictionary(objects: [self.auth_token[0]], forKeys: ["auth_token"])

    self.api.userDefaultCls(aParams, success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
      println(responseObject)
        self.fetchDataFromDBforDefaultCls()
      },
      failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
        println(error)
        
    })
  }
  
  func userScoreApiCall(){
    
    var aParams: NSDictionary = NSDictionary(objects: [self.auth_token[0]], forKeys: ["auth_token"])
    
    self.api.getUserScore(aParams, success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
      println(responseObject)
      var dict  = responseObject?.valueForKey("data") as NSDictionary
      if((dict.valueForKey("score")) != nil){
        self.lblScore.text = NSString(format: "%i",dict.valueForKey("score") as NSInteger)
      }else{
        self.lblScore.text = "0"
      }
      
      
      },
      failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
        println(error)
    })
    
  }

  
}

