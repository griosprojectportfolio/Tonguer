//
//  HomeViewController.swift
//  Tonguer
//
//  Created by GrepRuby on 06/04/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import UIKit
import Foundation

class HomeViewController:BaseViewController,UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource {
  
  let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
  
  var authToken: NSString!
  
  var hometableVw : UITableView!
  
  var barBackBtn :UIBarButtonItem!
  var barforwordBtn :UIBarButtonItem!
  var btnMiddleNavi :UIButton!
  
  var imgVwblur :UIImageView!
  var blur:UIBlurEffect!
  var effectView:UIVisualEffectView!
  var imgVwAlpha :UIImageView!
  var lblblurVwtextTitle :UILabel!
  var imgVwProfilrPic :UIImageView!
  var lblMoney :UILabel!
  var lblScore :UILabel!
  var lblAleday :UILabel!
  
  var lblMoneytext :UILabel!
  var lblScoretext :UILabel!
  var lblAledaytext :UILabel!
  
  var btnsView :UIView!
  
  var btn1 :UIButton!
  var btn2 :UIButton!
  var btn3 :UIButton!
  
  var btnFreeOpentryCls :UIButton!
  var leftswip: UISwipeGestureRecognizer!
  
  var api: AppApi!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    print(authToken)
    leftswip = UISwipeGestureRecognizer()
    leftswip.addTarget(self, action: "leftswipeGestureRecognizer")
    leftswip.direction = UISwipeGestureRecognizerDirection.Left
    //leftswip.delegate = self
    self.appDelegate.objSideBar.addGestureRecognizer(leftswip)
    api = AppApi.sharedClient()
   self.defaultUIDesign()
   self.userClassApiCall()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  override func viewWillAppear(animated: Bool) {
    
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
    self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
    
    self.navigationItem.setHidesBackButton(true, animated:false)
    
    
    btnMiddleNavi = UIButton(frame: CGRectMake(0, 0, 50, 25))
    btnMiddleNavi.setTitle("Chake in", forState: UIControlState.Normal)
    btnMiddleNavi.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
    btnMiddleNavi.titleLabel?.font = btnMiddleNavi.titleLabel?.font.fontWithSize(10)
    btnMiddleNavi.layer.cornerRadius = 5
    btnMiddleNavi.layer.borderWidth = 1
    btnMiddleNavi.layer.borderColor = UIColor.whiteColor().CGColor
    btnMiddleNavi.addTarget(self, action: "btnNaviMiddleTapped", forControlEvents: UIControlEvents.TouchUpInside)
    
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
    imgVwblur.image = UIImage(named: "imgblur.png")
    self.view.addSubview(imgVwblur)
    
    imgVwAlpha = UIImageView()
    imgVwAlpha.frame = imgVwblur.bounds
    imgVwAlpha.backgroundColor = UIColor(white: 1.0, alpha:0.91)
    imgVwblur.addSubview(imgVwAlpha)
    
    
    lblblurVwtextTitle = UILabel(frame: CGRectMake((imgVwAlpha.frame.size.width-200)/2+10, imgVwAlpha.frame.origin.y+30,200, 30))
    lblblurVwtextTitle.text = "User Name"
    lblblurVwtextTitle.textAlignment = NSTextAlignment.Center
    //lblblurVwtextTitle.backgroundColor = UIColor.redColor()
     imgVwAlpha.addSubview(lblblurVwtextTitle)
    
    imgVwProfilrPic = UIImageView(frame: CGRectMake(imgVwAlpha.frame.origin.x+10,lblblurVwtextTitle.frame.origin.y+50,90,70))
    imgVwProfilrPic.image = UIImage(named: "imgblur.png")
    //imgVwProfilrPic.backgroundColor = UIColor.grayColor()
    imgVwProfilrPic.layer.borderWidth = 5
    imgVwProfilrPic.layer.borderColor = UIColor.whiteColor().CGColor
    imgVwAlpha.addSubview(imgVwProfilrPic)
    
    lblMoney = UILabel(frame: CGRectMake(imgVwProfilrPic.frame.origin.x+imgVwProfilrPic.frame.size.width+10, imgVwProfilrPic.frame.origin.y+13,40,30))
    lblMoney.text = "0.2"
    //lblMoney.textAlignment = NSTextAlignment.Center
    lblMoney.font = lblMoney.font.fontWithSize(20)
    lblMoney.textColor = UIColor.grayColor()
    //lblMoney.backgroundColor = UIColor.redColor()
    imgVwAlpha.addSubview(lblMoney)
    
    lblMoneytext = UILabel(frame: CGRectMake(lblMoney.frame.origin.x,lblMoney.frame.size.height+lblMoney.frame.origin.y,40,15))
    lblMoneytext.text = "Money"
    //lblMoneytext.textAlignment = NSTextAlignment.Center
    lblMoneytext.font = lblMoney.font.fontWithSize(12)
    lblMoneytext.textColor = UIColor.grayColor()
    //lblMoneytext.backgroundColor = UIColor.greenColor()
     imgVwAlpha.addSubview(lblMoneytext)
    
    lblScore = UILabel(frame: CGRectMake(lblMoney.frame.origin.x+lblMoney.frame.size.width+20, lblMoney.frame.origin.y,40,30))
    lblScore.text = "10"
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
    
    lblAleday = UILabel(frame: CGRectMake(lblScore.frame.origin.x+lblScore.frame.size.width+20, lblScore.frame.origin.y,40,30))
    lblAleday.text = "2"
    //lblAleday.textAlignment = NSTextAlignment.Center
    lblAleday.font = lblMoney.font.fontWithSize(20)
    lblAleday.textColor = UIColor.grayColor()
    //lblAleday.backgroundColor = UIColor.redColor()
    imgVwAlpha.addSubview(lblAleday)
    
    lblAledaytext = UILabel(frame: CGRectMake(lblAleday.frame.origin.x, lblAleday.frame.origin.y+lblAleday.frame.size.height, 40,15))
    lblAledaytext.text = "Aleday"
    //lblMoneytext.textAlignment = NSTextAlignment.Center
    lblAledaytext.font = lblMoney.font.fontWithSize(12)
    lblAledaytext.textColor = UIColor.grayColor()
    //lblAledaytext.backgroundColor = UIColor.greenColor()
    imgVwAlpha.addSubview(lblAledaytext)
   
    btnsView = UIView(frame: CGRectMake(self.view.frame.origin.x,imgVwblur.frame.origin.y+imgVwblur.frame.size.height+5,self.view.frame.width,50))
    //btnsView.backgroundColor = UIColor.greenColor()
    self.view.addSubview(btnsView)
    
    
    btn1 = UIButton(frame: CGRectMake(10,5,(self.view.frame.width-40)/3, 40))
    //btn1.backgroundColor = UIColor.grayColor()
    btn1.setTitle("Default list", forState: UIControlState.Normal)
    btn1.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
    btnsView.addSubview(btn1)
    
    var HorizVw : UIView!
    HorizVw = UIView(frame: CGRectMake(btn1.frame.origin.x,btn1.frame.origin.y+btn1.frame.size.height , btn1.frame.size.width, 1))
    HorizVw.backgroundColor = UIColor(red: 66.0/255.0, green: 150.0/255.0, blue: 173.0/255.0,alpha:1.0)
    btnsView.addSubview(HorizVw)
    
    var vertiVw :UIView!
    vertiVw = UIView(frame: CGRectMake(btn1.frame.origin.x+btn1.frame.size.width,btn1.frame.origin.y,1, btn1.frame.height))
    vertiVw.backgroundColor = UIColor.grayColor()
    btnsView.addSubview(vertiVw)
    
    btn2 = UIButton(frame: CGRectMake(btn1.frame.origin.x+btn1.frame.size.width+10,btn1.frame.origin.y,btn1.frame.width, 40))
    //btn2.backgroundColor = UIColor.grayColor()
    btn2.setTitle("Learn list", forState: UIControlState.Normal)
    btn2.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
    btnsView.addSubview(btn2)
    
    var HorizVw2 : UIView!
    HorizVw2 = UIView(frame: CGRectMake(btn2.frame.origin.x,btn2.frame.origin.y+btn2.frame.size.height , btn2.frame.size.width, 1))
    HorizVw2.backgroundColor = UIColor(red: 66.0/255.0, green: 150.0/255.0, blue: 173.0/255.0,alpha:1.0)
    btnsView.addSubview(HorizVw2)
    
    var vertiVw2 :UIView!
    vertiVw2 = UIView(frame: CGRectMake(btn2.frame.origin.x+btn2.frame.size.width,btn2.frame.origin.y,1, btn2.frame.height))
    vertiVw2.backgroundColor = UIColor.grayColor()
    btnsView.addSubview(vertiVw2)
    
    btn3 = UIButton(frame: CGRectMake(btn2.frame.origin.x+btn2.frame.size.width+10,btn2.frame.origin.y,btn2.frame.width, 40))
   // btn3.backgroundColor = UIColor.grayColor()
    btn3.setTitle("Learend", forState: UIControlState.Normal)
    btn3.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
    btnsView.addSubview(btn3)
    
    var HorizVw3 : UIView!
    HorizVw3 = UIView(frame: CGRectMake(btn3.frame.origin.x,btn3.frame.origin.y+btn3.frame.size.height, btn3.frame.size.width, 1))
    HorizVw3.backgroundColor = UIColor(red: 66.0/255.0, green: 150.0/255.0, blue: 173.0/255.0,alpha:1.0)
    btnsView.addSubview(HorizVw3)
    
    btnFreeOpentryCls = UIButton(frame: CGRectMake(self.view.frame.origin.x+10,self.view.frame.height-50, self.view.frame.width-20, 40))
    btnFreeOpentryCls.setTitle("Free Open Try class", forState: UIControlState.Normal)
    btnFreeOpentryCls.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
    btnFreeOpentryCls.backgroundColor = UIColor(red: 66.0/255.0, green: 150.0/255.0, blue: 173.0/255.0,alpha:1.0)
    btnFreeOpentryCls.addTarget(self, action: "btnFreeOpenTryClasstapped", forControlEvents: UIControlEvents.TouchUpInside)
    
    self.view.addSubview(btnFreeOpentryCls)
    
    hometableVw = UITableView(frame:CGRectMake(btnsView.frame.origin.x+5,btnsView.frame.origin.y+btnsView.frame.size.height,self.view.frame.width-10,btnFreeOpentryCls.frame.origin.y-btnsView.frame.origin.y+btnsView.frame.size.height-110))
    hometableVw.delegate = self
    hometableVw.dataSource = self
    hometableVw.backgroundColor = UIColor.grayColor()
    
    self.view.addSubview(hometableVw)
    
    hometableVw.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")

  }
  
  func btnNaviMiddleTapped(){
    btnMiddleNavi.backgroundColor = UIColor.whiteColor()
  }
  
  func btnFreeOpenTryClasstapped(){
    let vc = self.storyboard?.instantiateViewControllerWithIdentifier("ClassCenterID") as ClassCenterViewController
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 3
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell: UITableViewCell!
    if(cell == nil){
      cell = tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
      var imgVw: UIImageView! = UIImageView(frame: CGRectMake(10,10, 100, 80))
      imgVw.image = UIImage(named: "imgblur.png")
      imgVw.layer.borderWidth = 0.5
      imgVw.layer.borderColor = UIColor.lightGrayColor().CGColor
      cell.contentView.addSubview(imgVw)
      
      var lblTitle: UILabel!=UILabel(frame: CGRectMake(imgVw.frame.origin.x+imgVw.frame.size.width+5,imgVw.frame.origin.y+10,150,30))
      lblTitle.text = "Class"
      //lblTitle.backgroundColor = UIColor.lightGrayColor()
      lblTitle.textColor = UIColor.blackColor()
      lblTitle.font = lblTitle.font.fontWithSize(15)
      cell.contentView.addSubview(lblTitle)
      
      var lblVaild: UILabel! = UILabel(frame: CGRectMake(lblTitle.frame.origin.x,lblTitle.frame.origin.y+30,100, 30))
      lblVaild.text = "Valid to-"
      //lblVaild.backgroundColor = UIColor.redColor()
      lblVaild.textColor = UIColor.lightGrayColor()
      lblVaild.font = lblVaild.font.fontWithSize(12)
      cell.contentView.addSubview(lblVaild)
      
      var lblDate: UILabel! = UILabel(frame: CGRectMake(lblVaild.frame.origin.x+lblVaild.frame.width-50,lblVaild.frame.origin.y,lblVaild.frame.width, 30))
      lblDate.text = "00-00-0000"
      //lblDate.backgroundColor = UIColor.redColor()
      lblDate.textColor = UIColor.darkGrayColor()
      lblDate.font = lblDate.font.fontWithSize(12)
      cell.contentView.addSubview(lblDate)

    }
    
    return cell
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 110
  }
  
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let vc = self.storyboard?.instantiateViewControllerWithIdentifier("LearnID") as StartLearnViewController
    self.navigationController?.pushViewController(vc, animated: true)
    
  }
  

  
  func btnAlertTapped(){
    let vc = self.storyboard?.instantiateViewControllerWithIdentifier("AlertID") as AlertViewController
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  
  func userClassApiCall(){
    
    var aParams: NSDictionary = NSDictionary(objects: [authToken], forKeys: ["auth_token"])
    
    self.api.userClass(aParams, success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
      println(responseObject)
      },
      failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
        println(error)
      
    })
    
  }
  
}






