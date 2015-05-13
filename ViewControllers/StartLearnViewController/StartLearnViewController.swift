//
//  StartLearnViewController.swift
//  Tonguer
//
//  Created by GrepRuby on 07/04/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import UIKit

class StartLearnViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate {
  
  var api: AppApi!
  
  var dictClasses: NSDictionary! = NSDictionary()
  var authToken: NSString!
  var sartlTableview :UITableView!
  var barBackBtn :UIBarButtonItem!
  var barforwordBtn :UIBarButtonItem!
  var imgVwAlpha :UIImageView!
  var imgVwblur :UIImageView!
  var circVw :UIView!
  var lblprogress :UILabel!
  var lblProNum :UILabel!
  var lblPerZ :UILabel!
  var btnStartLearn :UIButton!
  var btnFreeOpen :UIButton!
  
  var lblClassScore :UILabel!
  var lblClassScoreDigit :UILabel!
  
  var lblDayLeft :UILabel!
  var lblDayLeftDigit :UILabel!
  var dataArr: NSArray!
  var dict1:NSMutableDictionary!
  var dict2:NSMutableDictionary!
  var dict3:NSMutableDictionary!
  var dict4:NSMutableDictionary!
  var arrAdmin:NSMutableArray! = NSMutableArray()
  var arrUser:NSMutableArray! = NSMutableArray()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    api = AppApi.sharedClient()
    dict1 = NSMutableDictionary()
    dict1.setObject("Courselist.png", forKey: "image")
    dict1.setObject("Class Video list", forKey: "name")
    
    dict2 = NSMutableDictionary()
    dict2.setObject("homework.png", forKey: "image")
    dict2.setObject("Home Work", forKey: "name")
    
    dict3 = NSMutableDictionary()
    dict3.setObject("discuss.png", forKey: "image")
    dict3.setObject("Discus", forKey: "name")
   
    
    dict4 = NSMutableDictionary()
    dict4.setObject("notes.png", forKey: "image")
    dict4.setObject("Notes", forKey: "name")
    
    dataArr = NSArray(objects:dict1,dict2,dict3,dict4)
    self.defaultUIDesign()
    self.getClsTopicApiCall()
    self.dataFetchFromDatabaseDiscus()
    }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func defaultUIDesign(){
    
    print(dictClasses)
    
    self.title = "Start To Learn"
    
    self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
    
    self.navigationItem.setHidesBackButton(true, animated:false)
    
    var backbtn:UIButton = UIButton(frame: CGRectMake(0, 0,25,25))
    backbtn.setImage(UIImage(named: "whiteback.png"), forState: UIControlState.Normal)
    backbtn.addTarget(self, action: "btnBackTapped", forControlEvents: UIControlEvents.TouchUpInside)
    
    barBackBtn = UIBarButtonItem(customView: backbtn)
    
    self.navigationItem.setLeftBarButtonItem(barBackBtn, animated: true)
    
    
    imgVwblur = UIImageView(frame: CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+64,self.view.frame.width,180))
    imgVwblur.image = UIImage(named: "imgblur.png")
    self.view.addSubview(imgVwblur)
    
    imgVwAlpha = UIImageView()
    imgVwAlpha.frame = imgVwblur.bounds
    imgVwAlpha.backgroundColor = UIColor(white: 1.0, alpha:0.91)
    imgVwblur.addSubview(imgVwAlpha)
    
    lblClassScore = UILabel(frame: CGRectMake(imgVwAlpha.frame.origin.x+10,imgVwAlpha.frame.origin.y+60, 100,20))
    lblClassScore.text = "Class Score"
    lblClassScore.textAlignment = NSTextAlignment.Center
    //lblClassScore.backgroundColor = UIColor.redColor()
    lblClassScore.textColor = UIColor.darkGrayColor()
    lblClassScore.font = lblClassScore.font.fontWithSize(12)
    imgVwAlpha.addSubview(lblClassScore)
    
    lblClassScoreDigit = UILabel(frame: CGRectMake((lblClassScore.frame.width-40)/2+10,lblClassScore.frame.origin.y+lblClassScore.frame.height, 40, 40))
    print(dictClasses.objectForKey("class_score")?.integerValue)
   // var str: NSString! =
    lblClassScoreDigit.text = NSString(format: "%i",(dictClasses.objectForKey("score")?.integerValue)!)
    //lblClassScoreDigit.backgroundColor = UIColor.greenColor()
    lblClassScoreDigit.textAlignment = NSTextAlignment.Center
    lblClassScoreDigit.textColor = UIColor(red: 241.0/255.0, green: 132.0/255.0, blue: 131.0/255.0,alpha:1.0)
    lblClassScoreDigit.font = lblClassScoreDigit.font.fontWithSize(30)
    imgVwAlpha.addSubview(lblClassScoreDigit)
    
    circVw = UIView(frame: CGRectMake((imgVwAlpha.frame.width-120)/2, (imgVwAlpha.frame.height-120)/2, 120, 120))
    circVw.backgroundColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1)
    circVw.layer.cornerRadius = 60
    circVw.layer.borderWidth=5
    circVw.layer.borderColor = UIColor.whiteColor().CGColor
    imgVwAlpha.addSubview(circVw)
    
    lblprogress = UILabel(frame: CGRectMake(25,22, 80,20))
    lblprogress.text = "My Progress"
    //lblprogress.backgroundColor = UIColor.redColor()
    lblprogress.textColor = UIColor.darkGrayColor()
    lblprogress.font = lblprogress.font.fontWithSize(12)
    circVw.addSubview(lblprogress)
    
    lblDayLeft = UILabel(frame: CGRectMake(imgVwAlpha.frame.width-100, lblClassScore.frame.origin.y, 100,20))
    lblDayLeft.text = "Day Left"
    lblDayLeft.textAlignment = NSTextAlignment.Center
    //lblDayLeft.backgroundColor = UIColor.redColor()
    lblDayLeft.textColor = UIColor.darkGrayColor()
    lblDayLeft.font = lblDayLeft.font.fontWithSize(12)
    imgVwAlpha.addSubview(lblDayLeft)
    
    lblDayLeftDigit = UILabel(frame: CGRectMake(lblDayLeft.frame.origin.x,lblDayLeft.frame.origin.y+lblDayLeft.frame.size.height,100, 40))
    lblDayLeftDigit.text =  NSString(format: "%i",(dictClasses.objectForKey("days")?.integerValue)!)
    //lblDayLeftDigit.backgroundColor = UIColor.greenColor()
    lblDayLeftDigit.textAlignment = NSTextAlignment.Center
    lblDayLeftDigit.textColor = UIColor(red: 241.0/255.0, green: 132.0/255.0, blue: 131.0/255.0,alpha:1.0)
    lblDayLeftDigit.font = lblDayLeftDigit.font.fontWithSize(30)
    imgVwAlpha.addSubview(lblDayLeftDigit)

    
    
    btnStartLearn = UIButton(frame: CGRectMake(self.view.frame.origin.x,imgVwblur.frame.origin.y+imgVwblur.frame.size.height, self.view.frame.width, 40))
    btnStartLearn.setTitle("Start To Learn", forState: UIControlState.Normal)
    btnStartLearn.backgroundColor = UIColor(red: 237.0/255.0, green: 62.0/255.0, blue: 61.0/255.0,alpha:1.0)
    btnStartLearn.tintColor = UIColor.whiteColor()
    btnStartLearn.addTarget(self, action: "btnStartLearnTapped", forControlEvents: UIControlEvents.TouchUpInside)
    self.view.addSubview(btnStartLearn)
    
    
    lblProNum = UILabel(frame: CGRectMake(lblprogress.frame.origin.x+5,lblprogress.frame.origin.y+20,50,50))
    lblProNum.text = NSString(format: "%i",(dictClasses.objectForKey("progress")?.integerValue)!)
    //lblProNum.backgroundColor = UIColor.greenColor()
    lblProNum.textAlignment = NSTextAlignment.Center
    lblProNum.textColor = UIColor(red: 241.0/255.0, green: 132.0/255.0, blue: 131.0/255.0,alpha:1.0)
    lblProNum.font = lblProNum.font.fontWithSize(30)
    circVw.addSubview(lblProNum)
    
    lblPerZ = UILabel(frame: CGRectMake(lblProNum.frame.origin.x+50,lblProNum.frame.origin.y+10,20, 20))
    lblPerZ.text = "%"
    //lblProNum.backgroundColor = UIColor.greenColor()
    lblPerZ.textAlignment = NSTextAlignment.Center
    lblPerZ.textColor = UIColor(red: 241.0/255.0, green: 132.0/255.0, blue: 131.0/255.0,alpha:1.0)
    lblPerZ.font = lblPerZ.font.fontWithSize(13)
    circVw.addSubview(lblPerZ)
    
    btnFreeOpen = UIButton(frame: CGRectMake(self.view.frame.origin.x+20, self.view.frame.height-50,self.view.frame.width-40, 40))
    
    btnFreeOpen.setTitle("Free Open try Class", forState: UIControlState.Normal)
    btnFreeOpen.backgroundColor = UIColor(red: 71.0/255.0, green: 168.0/255.0, blue: 184.0/255.0,alpha:1.0)
    btnFreeOpen.tintColor = UIColor.whiteColor()
    btnFreeOpen.addTarget(self, action:"btnFreeOpenTapped", forControlEvents: UIControlEvents.TouchUpInside)
    self.view.addSubview(btnFreeOpen)
    
    sartlTableview = UITableView(frame:CGRectMake(btnFreeOpen.frame.origin.x,btnStartLearn.frame.origin.y+btnFreeOpen.frame.height+5, btnFreeOpen.frame.width,btnFreeOpen.frame.origin.y-btnFreeOpen.frame.height-imgVwAlpha.frame.height-80))
    sartlTableview.delegate = self
    sartlTableview.dataSource = self
    sartlTableview.scrollEnabled = true
    //sartlTableview.backgroundColor = UIColor.grayColor()
    self.view.addSubview(sartlTableview)
    sartlTableview.registerClass(StartLearnTableViewCell.self, forCellReuseIdentifier: "cell")
    
  }
  
  func btnBackTapped(){
    self.navigationController?.popViewControllerAnimated(true)
  }
  
  func btnFreeOpenTapped(){
    var vc = self.storyboard?.instantiateViewControllerWithIdentifier("ClassCenterID") as ClassCenterViewController
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  func btnStartLearnTapped(){
    var vc = self.storyboard?.instantiateViewControllerWithIdentifier("VideoID") as VideoViewControler
    vc.classID = dictClasses.objectForKey("id") as NSInteger
    vc.isActive = "Paied"
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
//  func btnforwardTapped(){
//    let vc = self.storyboard?.instantiateViewControllerWithIdentifier("ClassCenterID") as ClassCenterViewController
//    self.navigationController?.pushViewController(vc, animated: true)
//  }
//  
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataArr.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell: StartLearnTableViewCell!
    cell = sartlTableview.dequeueReusableCellWithIdentifier("cell") as StartLearnTableViewCell
    cell.selectionStyle = UITableViewCellSelectionStyle.None
    cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
    
    
    if(cell == nil){
      
      var arr: NSArray! = NSBundle.mainBundle().loadNibNamed("cell", owner: self, options: nil)
      
    }
    
    cell.defaultCellContent(dataArr.objectAtIndex(indexPath.row) as NSDictionary,index:indexPath.row)
    
    
    return cell
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 60
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    switch (indexPath.row){
    case 0:
      var vc = self.storyboard?.instantiateViewControllerWithIdentifier("VideoID") as VideoViewControler
       vc.classID = dictClasses.objectForKey("id") as NSInteger
       vc.isActive = "Paied"
      self.navigationController?.pushViewController(vc, animated: true)
    case 1:
      var vc = self.storyboard?.instantiateViewControllerWithIdentifier("QuesAnsID") as QesAndAnsViewController
      vc.classID =  dictClasses.objectForKey("id") as NSInteger
      self.navigationController?.pushViewController(vc, animated: true)
    case 2:
      var vc = self.storyboard?.instantiateViewControllerWithIdentifier("DiscussID") as DiscussViewController
      vc.classID = dictClasses.objectForKey("id") as NSInteger
      self.navigationController?.pushViewController(vc, animated: true)
    case 3:
      var vc = self.storyboard?.instantiateViewControllerWithIdentifier("NotesID") as NotesViewController
      self.navigationController?.pushViewController(vc, animated: true)

    default:
      print("*********Error********")
    }
  }
  
  //**************Discus topic Api Calling***********
  
  func getClsTopicApiCall(){
    
    var aParams: NSMutableDictionary! = NSMutableDictionary()
     aParams.setValue(auth_token[0], forKey: "auth_token")
     aParams.setValue(/*dictClasses.valueForKey("id")*/4, forKey: "class_id")
    self.api.discusAllTopic(aParams, success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
      println(responseObject)
      },
      failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
        println(error)
        
    })
    
  }

  //***************Fetching Data From Database Discus *********
  
  func dataFetchFromDatabaseDiscus(){
    let arrFetchAdmin: NSArray = DisAdminTopic.MR_findAll()
    let arrFetchUser: NSArray = DisUserToic.MR_findAll()
    var count: NSInteger = arrFetchAdmin.count + arrFetchUser.count
    print(count)
    dict3.setObject(count, forKey: "count")
    
    for var index = 0; index < arrFetchAdmin.count; ++index{
      let clsObject: DisAdminTopic = arrFetchAdmin.objectAtIndex(index) as DisAdminTopic
      var dict: NSMutableDictionary! = NSMutableDictionary()
      dict.setValue(clsObject.topic_id, forKey: "id")
      dict.setValue(clsObject.topic_name, forKey: "name")
      dict.setValue(clsObject.topic_content, forKey: "content")
      arrAdmin.addObject(dict)
    }
    
    for var index = 0; index < arrFetchUser.count; ++index{
      let clsObject: DisUserToic = arrFetchUser.objectAtIndex(index) as DisUserToic
      var dict: NSMutableDictionary! = NSMutableDictionary()
      dict.setValue(clsObject.topic_id, forKey: "id")
      dict.setValue(clsObject.topic_name, forKey: "name")
      dict.setValue(clsObject.topic_content, forKey: "content")
      arrUser.addObject(dict)
    }

    
  }

  
  
}
