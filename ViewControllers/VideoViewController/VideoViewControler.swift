//
//  VideoViewControler.swift
//  Tonguer
//
//  Created by GrepRuby on 20/04/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import UIKit
import MediaPlayer


class VideoViewControler: BaseViewController,UITableViewDataSource,UITableViewDelegate {
  
  var classID:NSInteger!
  var api: AppApi!
  var isActive: NSString!
  var barBackBtn :UIBarButtonItem!
  var barforwordBtn :UIBarButtonItem!
  var tableview: UITableView!
  var arrClassVideo: NSMutableArray! = NSMutableArray()
  var actiIndecatorVw: ActivityIndicatorView!
  var moviePlayerController:MPMoviePlayerController!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    api = AppApi.sharedClient()
    
    self.title = "Videos"
    self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
    
    self.navigationItem.setHidesBackButton(true, animated:false)
    
    var backbtn:UIButton = UIButton(frame: CGRectMake(0, 0,25,25))
    backbtn.setImage(UIImage(named: "back.png"), forState: UIControlState.Normal)
    backbtn.addTarget(self, action: "btnBackTapped", forControlEvents: UIControlEvents.TouchUpInside)
    
    barBackBtn = UIBarButtonItem(customView: backbtn)
    
    self.navigationItem.setLeftBarButtonItem(barBackBtn, animated: true)
    actiIndecatorVw = ActivityIndicatorView(frame: self.view.frame)
    self.view.addSubview(actiIndecatorVw)
    
    if(isActive.isEqualToString("Paied")){
      self.userClsVideoApiCalling()
      
    }else if (isActive.isEqualToString("Free")){
      self.freeClsVideoApiCalling()
      
    }
    
    self.delay(3) { () -> () in
      
      if(self.isActive.isEqualToString("Paied")){
      self.dataFetchUserClsDB()
        
      }else if (self.isActive.isEqualToString("Free")){
       
        self.dataFetchFreeClsDB()
      }
      self.actiIndecatorVw.loadingIndicator.stopAnimating()
      self.actiIndecatorVw.removeFromSuperview()

      self.defaultUIDesign()
    }
    
  }
  
  func defaultUIDesign(){
    
    tableview = UITableView(frame: CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y+64, self.view.frame.width,self.view.frame.height-64))
    tableview.delegate = self
    tableview.dataSource = self
    tableview.separatorStyle = UITableViewCellSeparatorStyle.None
    self.view.addSubview(tableview)
    
    tableview.registerClass(VideoTableViewCell.self, forCellReuseIdentifier: "cell")
    
  }
  func btnBackTapped(){
    self.navigationController?.popViewControllerAnimated(true)
  }
  
  func delay(delay:Double, closure:()->()) {
    dispatch_after(
      dispatch_time(
        DISPATCH_TIME_NOW,
        Int64(delay * Double(NSEC_PER_SEC))
      ),
      dispatch_get_main_queue(), closure)
  }
  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return arrClassVideo.count
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 200
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell = tableview.dequeueReusableCellWithIdentifier("cell") as VideoTableViewCell
    cell.selectionStyle = UITableViewCellSelectionStyle.None
    cell.defaultUIDesign(arrClassVideo.objectAtIndex(indexPath.row) as NSDictionary)
    cell.btnplay.tag = indexPath.row
    cell.btnplay.addTarget(self, action: "btnPalyTapped:", forControlEvents: UIControlEvents.TouchUpInside)
    
    var dict: NSDictionary = arrClassVideo.objectAtIndex(indexPath.row) as NSDictionary
    var fileName: NSString = dict.valueForKey("name") as NSString + ".mp4"
    let documentsPath: NSArray = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
       let url: NSString = documentsPath.objectAtIndex(0) as NSString
       let path: NSString! = url+"/"+fileName
    
    let manager = NSFileManager.defaultManager()
    if (manager.fileExistsAtPath(path)){
      cell.btnplay.hidden = true
    }
    
    return cell
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    var dict: NSDictionary = arrClassVideo.objectAtIndex(indexPath.row) as NSDictionary

    var str: NSString = dict.valueForKey("name") as NSString
    
    var fileName: NSString! = str.stringByAppendingString(".mp4")
    let aParams : NSDictionary = ["fileName":fileName]
    let viedoUrl: NSURL = api.getDocumentDirectoryFileURL(aParams)
    
    moviePlayerController = MPMoviePlayerController(contentURL:viedoUrl)
    moviePlayerController.view.frame = CGRectMake(self.view.frame.origin.x+20, self.view.frame.origin.y+74, self.view.frame.width-40,200)
    self.view.addSubview(moviePlayerController.view)
    moviePlayerController.fullscreen = false
    moviePlayerController.controlStyle = MPMovieControlStyle.Embedded
    moviePlayerController.shouldAutoplay = false
    moviePlayerController.play()
    
  }
  
  
  func btnPalyTapped(sender:AnyObject){
    var btn = sender as UIButton
    btn.hidden = false
    btn.setImage(UIImage(named:"download.png"), forState: UIControlState.Normal)
    var dict: NSDictionary! = arrClassVideo.objectAtIndex(btn.tag) as NSDictionary
    var video_url: NSString! = dict.valueForKey("video_url") as NSString
    var str: NSString = dict.valueForKey("name") as NSString
    
    var fileName: NSString! = str.stringByAppendingString(".mp4")
    let aPara : NSDictionary = ["fileName":fileName]
    
    var aParams: NSDictionary = NSDictionary(objects: [video_url,fileName], forKeys: ["url","fileName"])
    
    self.api.downloadMediaData(aParams, success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
      println(responseObject)
      btn.hidden = true
      },
      failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
        println(error)
        
    })

    
  }
  
  
  //*********** Api Calling Methods**********
  
  func freeClsVideoApiCalling(){
    var aParam: NSDictionary = NSDictionary(objects: [auth_token[0],classID], forKeys: ["auth_token","class_id"])
    
    self.api.freeClsVideoList(aParam, success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
      println(responseObject)
      var aParam: NSDictionary! = responseObject?.objectForKey("data") as NSDictionary
      
      },
      failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
        println(error)
        
    })

  }
  
  func userClsVideoApiCalling(){
    var aParam: NSDictionary = NSDictionary(objects: [auth_token[0],classID], forKeys: ["auth_token","class_id"])
    
    self.api.userClassVideo(aParam, success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
      println(responseObject)
      var aParam: NSDictionary! = responseObject?.objectForKey("data") as NSDictionary
      
      },
      failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
        println(error)
        
    })
    
  }
  
  
//**********Data Fetching Methods************
  
  func dataFetchFreeClsDB(){
    let arrFetchCat: NSArray = FreeClssVideo.MR_findAll()
    for var index = 0; index < arrFetchCat.count; ++index{
      let clsObject: FreeClssVideo = arrFetchCat.objectAtIndex(index) as FreeClssVideo
      var dictClass: NSMutableDictionary! = NSMutableDictionary()
      var vdoId: NSNumber =  clsObject.video_id
      dictClass.setValue(vdoId, forKey:"id")
      if((clsObject.video_name) != nil){
        var strName: NSString = clsObject.video_name
        dictClass.setValue(strName, forKey: "name")
      }else {
        var strName: NSString = ""
        dictClass.setValue(strName, forKey: "name")
      }
      
      if((clsObject.video_img_url) != nil){
        var strImgUrl: NSString = clsObject.video_img_url
        dictClass.setValue(strImgUrl, forKey: "image")
        
      }else{
        var strImgUrl: NSString = "http://www.popular.com.my/images/no_image.gif"
        dictClass.setValue(strImgUrl, forKey: "image")
      }
      
      if((clsObject.video_url) != nil){
        var videoUrl: NSString = clsObject.video_url
        dictClass.setValue(videoUrl, forKey: "video_url")
      }else{
        var videoUrl: NSString = ""
        dictClass.setValue(videoUrl, forKey: "video_url")
      }

      arrClassVideo.addObject(dictClass)
      
    }
    
    if(arrClassVideo.count == 0){
      var alert: UIAlertView! = UIAlertView(title: "Alert", message: "Sorry No Videos", delegate: self, cancelButtonTitle: "Ok")
      alert.show()
    }

  }
  
  func dataFetchUserClsDB(){
    let arrFetchCat: NSArray = UserClsVideo.MR_findAll()
    for var index = 0; index < arrFetchCat.count; ++index{
      let clsObject: UserClsVideo = arrFetchCat.objectAtIndex(index) as UserClsVideo
      var dictClass: NSMutableDictionary! = NSMutableDictionary()
      var vdoId: NSNumber =  clsObject.vdo_id
      dictClass.setValue(vdoId, forKey:"id")
      if((clsObject.vdo_name) != nil){
        var strName: NSString = clsObject.vdo_name
         dictClass.setValue(strName, forKey: "name")
      }else {
        var strName: NSString = ""
        dictClass.setValue(strName, forKey: "name")
      }
      
      if((clsObject.vdo_img) != nil){
        var strImgUrl: NSString = clsObject.vdo_img
        dictClass.setValue(strImgUrl, forKey: "image")

      }else{
        var strImgUrl: NSString = "http://www.popular.com.my/images/no_image.gif"
        dictClass.setValue(strImgUrl, forKey: "image")
      }
      
      if((clsObject.vdo_url) != nil){
        var videoUrl: NSString = clsObject.vdo_url
        dictClass.setValue(videoUrl, forKey: "video_url")
      }else{
        var videoUrl: NSString = ""
        dictClass.setValue(videoUrl, forKey: "video_url")
      }
      arrClassVideo.addObject(dictClass)
     
    }
    
    if(arrClassVideo.count == 0){
      var alert: UIAlertView! = UIAlertView(title: "Alert", message: "Sorry No Videos", delegate: self, cancelButtonTitle: "Ok")
      alert.show()
    }

  }


}
