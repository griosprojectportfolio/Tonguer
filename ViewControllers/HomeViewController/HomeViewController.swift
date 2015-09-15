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

  let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate


 @IBOutlet var hometableVw : UITableView!
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
  var lblNoData:UILabel!
  var imagViewNoData:UIImageView!
  var totalLearnCls:NSInteger!

  var isLearnd:Bool = false
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
    setDataNofoundImg()
//    var date: NSDate! = NSDate()

    //updateDeviceTokenCall()
    self.fetchDataFromDBforDefaultCls()
    self.fetchDataFromDBforLearnCls()
    self.fetchDataFromDBforLearnedCls()
   //self.hometableVw.reloadData()
    
    

    if (NSUserDefaults.standardUserDefaults().valueForKey("checkIns") == nil) {
      return;
    }
    NSNotificationCenter.defaultCenter().addObserver(
      self,
      selector: "checkInButton:",
      name: UIApplicationDidBecomeActiveNotification,
      object: nil)
    
    findDifferenceIndates() //difference in date
    
  }

  func restrictRotation(restriction:Bool) {
    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    appDelegate.restrictRotation = restriction;
  }
  
//  override func supportedInterfaceOrientations() -> Int {
//    return Int(UIInterfaceOrientation.PortraitUpsideDown.rawValue)
//  }
//  
//  override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
//    return UIInterfaceOrientation.PortraitUpsideDown
//  }
  
  override func shouldAutorotate() -> Bool {
    return true
  }


  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    self.userScoreApiCall()
    self.hometableVw.reloadData()
    if(arrClsLearn.count > 0 || arrClsLearned.count > 0){
      totalLearnCls = arrClsLearned.count + arrClsLearn.count
      lblAleday.text = NSString(format: "%i",totalLearnCls) as String
    }
    
    if(arrclass.count == 0){
      if(btnTag == 1){
        showSetDataNofoundImg()
        lblNoData.text = "Please buy the classes."
      }
    }else{
      resetShowSetDataNofoundImg()
    }
    
    if(arrClsLearn.count == 0){
      if(btnTag == 2){
        showSetDataNofoundImg()
        lblNoData.text = "Please start to learning."
      }
    }else{
      resetShowSetDataNofoundImg()
    }
    
    if(arrClsLearned.count == 0){
      if(btnTag == 3){
        showSetDataNofoundImg()
        lblNoData.text = ""
      }
    }else{
      resetShowSetDataNofoundImg()
    }
    
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  override func viewWillAppear(animated: Bool) {
    //self.userClassApiCall()

    super.viewWillAppear(animated)
    self.navigationController?.navigationBar.translucent = true

    self.fetchDataFromdataBase()
    self.userClassApiCall()
    self.userLearnClsApiCall()
    self.userLearnedClsApiCall()
  }
  
  //When App come into forground from background
   func checkInButton(notification: NSNotification){
    
    let previousCheckDate = NSUserDefaults.standardUserDefaults().valueForKey("checkIns") as! NSDate
    var calendar: NSCalendar = NSCalendar.currentCalendar()
    let dateCheckIn = calendar.startOfDayForDate(previousCheckDate)
    let dateCurrent = calendar.startOfDayForDate(NSDate())
    
    let flags = NSCalendarUnit.DayCalendarUnit
    let components = calendar.components(flags, fromDate: dateCheckIn, toDate: dateCurrent, options: nil)
    
    if components.day > 0 {
      btnMiddleNavi.enabled = true
      btnMiddleNavi.backgroundColor = UIColor.clearColor()
    }
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

    lblMoney = UILabel(frame: CGRectMake(imgVwProfilrPic.frame.origin.x+imgVwProfilrPic.frame.size.width, imgVwProfilrPic.frame.origin.y+13,self.view.frame.width/4.5,30))
    lblMoney.text = "0.0"
    lblMoney.textAlignment = NSTextAlignment.Center
    lblMoney.font = lblMoney.font.fontWithSize(20)
    lblMoney.textColor = UIColor.grayColor()
    //lblMoney.backgroundColor = UIColor.redColor()
    imgVwAlpha.addSubview(lblMoney)

    lblMoneytext = UILabel(frame: CGRectMake(lblMoney.frame.origin.x,lblMoney.frame.size.height+lblMoney.frame.origin.y,lblMoney.frame.width,15))
    lblMoneytext.text = "Money"
    lblMoneytext.textAlignment = NSTextAlignment.Center
    lblMoneytext.font = lblMoney.font.fontWithSize(12)
    lblMoneytext.textColor = UIColor.grayColor()
    //lblMoneytext.backgroundColor = UIColor.greenColor()
    imgVwAlpha.addSubview(lblMoneytext)

    lblScore = UILabel(frame: CGRectMake(lblMoney.frame.origin.x+lblMoney.frame.size.width, lblMoney.frame.origin.y,lblMoney.frame.width,30))
    lblScore.text = "0"
    lblScore.textAlignment = NSTextAlignment.Center
    lblScore.font = lblMoney.font.fontWithSize(20)
    lblScore.textColor = UIColor.grayColor()
    //lblScore.backgroundColor = UIColor.redColor()
    imgVwAlpha.addSubview(lblScore)

    lblScoretext = UILabel(frame: CGRectMake(lblScore.frame.origin.x,lblScore.frame.origin.y+lblScore.frame.size.height,lblScore.frame.width, 15))
    lblScoretext.text = "Score"
    lblScoretext.textAlignment = NSTextAlignment.Center
    lblScoretext.font = lblMoney.font.fontWithSize(12)
    lblScoretext.textColor = UIColor.grayColor()
    //lblScoretext.backgroundColor = UIColor.greenColor()
    imgVwAlpha.addSubview(lblScoretext)
    
    

    lblAleday = UILabel(frame: CGRectMake(lblScore.frame.origin.x+lblScore.frame.size.width, lblScore.frame.origin.y,lblScore.frame.width,30))
    lblAleday.text = "0"
    lblAleday.textAlignment = NSTextAlignment.Center
    lblAleday.font = lblMoney.font.fontWithSize(20)
    lblAleday.textColor = UIColor.grayColor()
    lblAleday.userInteractionEnabled = true
    //lblAleday.backgroundColor = UIColor.redColor()
    imgVwAlpha.addSubview(lblAleday)

    lblAledaytext = UILabel(frame: CGRectMake(lblAleday.frame.origin.x, lblAleday.frame.origin.y+lblAleday.frame.size.height,lblAleday.frame.width,15))
    lblAledaytext.text = "Finished"
    lblAledaytext.textAlignment = NSTextAlignment.Center
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
    btnFreeOpentryCls.setTitle("Try lesson", forState: UIControlState.Normal)
    btnFreeOpentryCls.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
    btnFreeOpentryCls.backgroundColor = UIColor(red: 66.0/255.0, green: 150.0/255.0, blue: 173.0/255.0,alpha:1.0)
    btnFreeOpentryCls.addTarget(self, action: "btnFreeOpenTryClasstapped", forControlEvents: UIControlEvents.TouchUpInside)

    self.view.addSubview(btnFreeOpentryCls)

    hometableVw.frame = CGRectMake(btn1.frame.origin.x,btn1.frame.origin.y+btn1.frame.size.height+1,self.view.frame.width-10,btnFreeOpentryCls.frame.origin.y-btn1.frame.origin.y+btn1.frame.size.height-80)
    hometableVw.delegate = self
    hometableVw.dataSource = self
   // hometableVw.backgroundColor = UIColor.grayColor()
    hometableVw.separatorStyle = UITableViewCellSeparatorStyle.None
    hometableVw.contentInset = UIEdgeInsetsMake(-64,0,0,0)

  }
  
  
  func alredayTapGuesture(){
    var vc = self.storyboard?.instantiateViewControllerWithIdentifier("LearnStatusID") as! LearnStatusViewController
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
    let previousCheckDate = NSUserDefaults.standardUserDefaults().valueForKey("checkIns") as! NSDate

    var calendar: NSCalendar = NSCalendar.currentCalendar()
    let dateCheckIn = calendar.startOfDayForDate(previousCheckDate)
    let dateCurrent = calendar.startOfDayForDate(currentDate)

    let flags = NSCalendarUnit.DayCalendarUnit
    let components = calendar.components(flags, fromDate: dateCheckIn, toDate: dateCurrent, options: nil)

    if components.day > 0 {

      if(btnMiddleNavi.enabled == false) {
        NSUserDefaults.standardUserDefaults().setValue(currentDate, forKey: "checkIns")
        NSUserDefaults.standardUserDefaults().synchronize()
        btnMiddleNavi.backgroundColor = UIColor.grayColor()
      } else {
        btnMiddleNavi.enabled = true
        btnMiddleNavi.backgroundColor = UIColor.clearColor()
      }
      // btnMiddleNavi.enabled = false
    }
    if components.day == 0 {
      btnMiddleNavi.backgroundColor = UIColor.grayColor()
      // btnMiddleNavi.enabled = false
    }
    print( NSUserDefaults.standardUserDefaults().valueForKey("checkIns"))
  }

  func btnFreeOpenTryClasstapped(){
    let vc = self.storyboard?.instantiateViewControllerWithIdentifier("ClassCenterID") as! ClassCenterViewController
    self.navigationController?.pushViewController(vc, animated: true)
  }

  func btnDefaultTapped(sender:AnyObject){
    var btn = sender as! UIButton
    btnTag = btn.tag
    print("Default List")
    HorizVw.backgroundColor  = UIColor(red: 66.0/255.0, green: 150.0/255.0, blue: 173.0/255.0,alpha:1.0)
    HorizVw2.backgroundColor = UIColor.lightGrayColor()
    HorizVw3.backgroundColor = UIColor.lightGrayColor()
    hometableVw.reloadData()
    if(arrclass.count == 0){
      if(btnTag == 1){
        showSetDataNofoundImg()
        lblNoData.text = "Please buy the classes."
      }
    }else{
      resetShowSetDataNofoundImg()
    }

  }

  func btnLearnlistTapped(sender:AnyObject){
    var btn = sender as! UIButton
    btnTag = btn.tag
    print("Learn List")
    HorizVw.backgroundColor  = UIColor.lightGrayColor()
    HorizVw2.backgroundColor = UIColor(red: 66.0/255.0, green: 150.0/255.0, blue: 173.0/255.0,alpha:1.0)
    HorizVw3.backgroundColor = UIColor.lightGrayColor()
    hometableVw.reloadData()
    if(arrClsLearn.count == 0){
      if(btnTag == 2){
        showSetDataNofoundImg()
        lblNoData.text = "Please start to learning."
      }
    }else{
      resetShowSetDataNofoundImg()
    }
  }

  func btnLearnedTapped(sender:AnyObject){
    var btn = sender as! UIButton
    btnTag = btn.tag
    print("Learn List")

    HorizVw.backgroundColor  = UIColor.lightGrayColor()
    HorizVw2.backgroundColor = UIColor.lightGrayColor()
    HorizVw3.backgroundColor = UIColor(red: 66.0/255.0, green: 150.0/255.0, blue: 173.0/255.0,alpha:1.0)
    hometableVw.reloadData()
    if(arrClsLearned.count == 0){
      if(btnTag == 3){
        showSetDataNofoundImg()
        lblNoData.text = ""
      }
    }else{
      resetShowSetDataNofoundImg()
    }
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
      var cell:HomeTableViewCell! = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath:indexPath) as! HomeTableViewCell
      cell.selectionStyle = UITableViewCellSelectionStyle.None
      cell.configureCellView(self.view.frame)
      cell.defaultCellContent(arrclass.objectAtIndex(indexPath.row)as! NSDictionary)
      print(arrclass.objectAtIndex(indexPath.row))
      return cell
    } else if (btnTag == 2){
      var cell:LearnTableViewCell!
      cell = tableView.dequeueReusableCellWithIdentifier("LearnCell") as! LearnTableViewCell
      cell.selectionStyle = UITableViewCellSelectionStyle.None
      cell.configureCellView(self.view.frame)
      cell.defaultCellContent(arrClsLearn.objectAtIndex(indexPath.row)as! NSDictionary)
      return cell
    } else if (btnTag == 3){
      var  cell = tableView.dequeueReusableCellWithIdentifier("LearnedCell") as! LearnedTableViewCell
      cell.selectionStyle = UITableViewCellSelectionStyle.None
      cell.configureCellView(self.view.frame)
      cell.defaultCellContent(arrClsLearned.objectAtIndex(indexPath.row)as! NSDictionary)
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
      dict = arrclass.objectAtIndex(indexPath.row) as! NSDictionary
    }else if(btnTag == 2){
      dict = arrClsLearn.objectAtIndex(indexPath.row) as! NSDictionary
    }else if(btnTag == 3){
      dict = arrClsLearned.objectAtIndex(indexPath.row) as! NSDictionary
        isLearnd = true
    }

    let vc = self.storyboard?.instantiateViewControllerWithIdentifier("LearnID") as! StartLearnViewController
    vc.isLearnd = isLearnd
    vc.dictClasses = dict
    vc.useImgUrl = useImgUrl

    self.navigationController?.pushViewController(vc, animated: true)

  }
  //****** Update User Profile Pic ************
  func btnProfileTapped(){
    if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum){

      imagePicker.delegate = self
      imagePicker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum;
      imagePicker.allowsEditing = false

      self.presentViewController(imagePicker, animated: true, completion: nil)
    }

  }

  func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
    self.dismissViewControllerAnimated(true, completion: { () -> Void in

    })
    imgVwProfilrPic.image = image
    imgVwblur.image = image
    self.UserUpadteApiCall(image)
  }

  func btnAlertTapped(){
    let vc = self.storyboard?.instantiateViewControllerWithIdentifier("AlertID") as! AlertViewController
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  
  
  
  
  

  //****** Update User Recodes ans Api call ************

  func UserUpadteApiCall(image:UIImage){
    
    var imag:UIImage = self.compressForUpload(image, withHeightLimit:40, andWidthLimit:40) as UIImage
    var imageData : NSData = UIImageJPEGRepresentation(image,4.0)
    let base64String = imageData.base64EncodedStringWithOptions(.allZeros)
    println(base64String)
    var auth_token = self.auth_token[0]
    
    var aParams: NSDictionary! = ["auth-token" :auth_token, "user[image]" : base64String]
    
    self.api.updateUser(aParams as [NSObject : AnyObject], success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
      println(responseObject)
      var aParam: NSDictionary = responseObject?.objectForKey("user") as! NSDictionary
      CommonUtilities.addUserInformation(aParam)
      self.fetchDataFromdataBase()
      },
      failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
        println(operation?.responseString)
    })
  }
  
  
  func compressForUpload(original:UIImage, withHeightLimit heightLimit:CGFloat, andWidthLimit widthLimit:CGFloat)->UIImage{
    
    let originalSize = original.size
    var newSize = originalSize
    
    if originalSize.width > widthLimit && originalSize.width > originalSize.height {
      
      newSize.width = widthLimit
      newSize.height = originalSize.height*(widthLimit/originalSize.width)
    }else if originalSize.height > heightLimit && originalSize.height > originalSize.width {
      
      newSize.height = heightLimit
      newSize.width = originalSize.width*(heightLimit/originalSize.height)
    }
    
    // Scale the original image to match the new size.
    UIGraphicsBeginImageContext(newSize)
    original.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
    let compressedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return compressedImage
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
    var userDefault:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    var data:NSData = userDefault.objectForKey("user") as! NSData
    var dictFetchedData:NSDictionary = NSKeyedUnarchiver.unarchiveObjectWithData(data)as! NSDictionary

    CommonUtilities.sharedDelegate().dictUserInfo = dictFetchedData
    print(dictFetchedData)

    if(dictFetchedData.count>0){
      print(dictFetchedData)
      let fname = dictFetchedData.valueForKey("first_name") as! String
      let lname = dictFetchedData.valueForKey("last_name")as! String

      var name: String!
      if((fname.isEmpty == false && lname.isEmpty == false )){
        name = fname+" "+lname
      }else{
        name = ""
      }
      lblblurVwtextTitle.text = name

      if((dictFetchedData.valueForKey("money") as! String).isEmpty == false){
        lblMoney.text = dictFetchedData.valueForKey("money") as? String
      } else{
        lblMoney.text = "0.0"
      }
      
      var img = dictFetchedData.valueForKey("image") as! NSObject
      if(img.isKindOfClass(NSDictionary)){
     var dict = dictFetchedData.valueForKey("image") as! NSDictionary
      var strim:NSObject = dict.valueForKey("url") as! NSObject
      
      if (strim.isKindOfClass(NSNull)){
        useImgUrl = "http://idebate.org/sites/live/files/imagecache/150x150/default_profile.png"
        let url = NSURL(string: "http://idebate.org/sites/live/files/imagecache/150x150/default_profile.png" as NSString as String)
        imgVwProfilrPic.sd_setImageWithURL(url)
      }else if((strim.isKindOfClass(NSString))){
        let url = NSURL(string:strim as! String)
        imgVwProfilrPic.sd_setImageWithURL(url, placeholderImage:UIImage(named: "User.png"))
        imgVwblur.sd_setImageWithURL(url, placeholderImage:UIImage(named: "User.png"))
      }
      }else if(img.isKindOfClass(NSString)){
        let url = NSURL(string:img as! String)
        imgVwProfilrPic.sd_setImageWithURL(url, placeholderImage:UIImage(named: "User.png"))
        imgVwblur.sd_setImageWithURL(url, placeholderImage:UIImage(named: "User.png"))

      }
    }
  }

  //****** User Data fetch from database for user default class ************

  func fetchDataFromDBforDefaultCls(){
    let arrFetchedData : NSArray = UserDefaultClsList.MR_findAllSortedBy("cls_name", ascending:true)

    arrclass.removeAllObjects()

    for var index = 0; index < arrFetchedData.count; ++index {
      let userClsObj : UserDefaultClsList = arrFetchedData.objectAtIndex(index) as! UserDefaultClsList
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
    self.hometableVw.reloadData()
  }

  //****** User Data fetch from database for user Learn class ************

  func fetchDataFromDBforLearnCls(){
    let arrFetchedData : NSArray = UserLearnClsList.MR_findAllSortedBy("cls_name", ascending:true)

    arrClsLearn.removeAllObjects()

    for var index = 0; index < arrFetchedData.count; ++index {
      let userClsObj : UserLearnClsList = arrFetchedData.objectAtIndex(index) as! UserLearnClsList
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
      self.hometableVw.reloadData()
    }

    print(arrClsLearn.count)
   
    

  }

  //****** User Data fetch from database for user Learned class ************

  func fetchDataFromDBforLearnedCls(){
    let arrFetchedData : NSArray = UserLearnedClsList.MR_findAllSortedBy("cls_name", ascending: true)
    arrClsLearned.removeAllObjects()

    for var index = 0; index < arrFetchedData.count; ++index {
      let userClsObj : UserLearnedClsList = arrFetchedData.objectAtIndex(index) as! UserLearnedClsList
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
    self.hometableVw.reloadData()
  }

  func userLearnClsApiCall(){

    var aParams: NSDictionary = NSDictionary(objects: [self.auth_token[0]], forKeys: ["auth-token"])
    self.api.userLearnCls(aParams as [NSObject : AnyObject], success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
      println(responseObject)
      let data = responseObject as! NSArray
      if data.count != 0 {
        self.resetShowSetDataNofoundImg()
      }
        self.fetchDataFromDBforLearnCls()
      },
      failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
        println(error)
    })

  }

  func userLearnedClsApiCall(){

    var aParams: NSDictionary = NSDictionary(objects: [self.auth_token[0]], forKeys: ["auth-token"])

    self.api.userLearnedCls(aParams as [NSObject : AnyObject], success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
      println(responseObject)
      let data = responseObject as! NSArray
      if data.count != 0 {
        self.resetShowSetDataNofoundImg()
      }
        self.fetchDataFromDBforLearnedCls()
      },
      failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
        println(error)

    })
  }

  func userClassApiCall(){

    var aParams: NSDictionary = NSDictionary(objects: [self.auth_token[0]], forKeys: ["auth-token"])

    self.api.userDefaultCls(aParams as [NSObject : AnyObject], success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
      println(responseObject)
//      let data = responseObject as NSDictionary
//      if data  {
//        self.resetShowSetDataNofoundImg()
//      }
        self.fetchDataFromDBforDefaultCls()
      },
      failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
        println(error)
        
    })
  }
  
  func userScoreApiCall(){
    
    var aParams: NSDictionary = NSDictionary(objects: [self.auth_token[0]], forKeys: ["auth-token"])
    
    self.api.getUserScore(aParams as [NSObject : AnyObject], success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
      println(responseObject)
      var dict  = responseObject?.valueForKey("data") as! NSDictionary
      if((dict.valueForKey("score")) != nil){
        var strscore = dict.valueForKey("score")?.integerValue
        self.lblScore.text = NSString(format: "%i",strscore!) as String
      }else{
        self.lblScore.text = ""
      }
      
      
      },
      failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
        println(error)
    })
    
  }
  
  func setDataNofoundImg(){
    lblNoData = UILabel(frame: CGRectMake(hometableVw.frame.origin.x+20,hometableVw.frame.origin.y-((hometableVw.frame.height+150)/2),hometableVw.frame.width-40, 30))
    lblNoData.text = "Sorry no data found."
    lblNoData.textAlignment = NSTextAlignment.Center
    lblNoData.hidden = true
    hometableVw.addSubview(lblNoData)
    self.view.bringSubviewToFront(lblNoData)
    imagViewNoData = UIImageView(frame: CGRectMake(hometableVw.frame.origin.x+((hometableVw.frame.width-100)/2),hometableVw.frame.origin.y-((hometableVw.frame.height+100)/2),100,100))
    imagViewNoData.image = UIImage(named:"smile")
    //imagViewNoData.backgroundColor = UIColor.blackColor()
    imagViewNoData.hidden = true
    hometableVw.addSubview(imagViewNoData)
    self.view.bringSubviewToFront(imagViewNoData)
  }
  
  func showSetDataNofoundImg(){
     lblNoData.hidden = false
    imagViewNoData.hidden = false
  }
  
  func resetShowSetDataNofoundImg(){
    lblNoData.hidden = true
    imagViewNoData.hidden = true
  }

  
}

