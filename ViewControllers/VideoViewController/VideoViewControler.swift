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
@IBOutlet  var tableview: UITableView!
  var arrClassVideo: NSMutableArray = NSMutableArray()
  var actiIndecatorVw: ActivityIndicatorView!
  var moviePlayerController:MPMoviePlayerController!
  var doenloadedData:NSInteger = 0
  var videoDone:NSArray! = NSArray()
  var imagViewNoData:UIImageView!
  var lblNoData: UILabel!
  override func viewDidLoad() {
    super.viewDidLoad()
    api = AppApi.sharedClient()

    arrClassVideo.removeAllObjects()
    self.title = "Videos"
    
  
    self.navigationItem.setHidesBackButton(true, animated:false)
    
    var backbtn:UIButton = UIButton(frame: CGRectMake(0, 0,25,25))
    backbtn.setImage(UIImage(named: "whiteback.png"), forState: UIControlState.Normal)
    backbtn.addTarget(self, action: "btnBackTapped", forControlEvents: UIControlEvents.TouchUpInside)
    
    barBackBtn = UIBarButtonItem(customView: backbtn)
    
    self.navigationItem.setLeftBarButtonItem(barBackBtn, animated: true)
    actiIndecatorVw = ActivityIndicatorView(frame: self.view.frame)
    self.view.addSubview(actiIndecatorVw)
    
    var predicate:NSPredicate = NSPredicate (format: "cls_id CONTAINS %i", classID)!;
    
   
    if(isActive.isEqualToString("Paied")){
      let arryVideo:NSArray = UserClsVideo.MR_findAllWithPredicate(predicate)
      self.dataFetchUserClsDB(arryVideo)
      
    } else if (isActive.isEqualToString("Free")){
     let arryVideo:NSArray = FreeClssVideo.MR_findAllWithPredicate(predicate)
      self.dataFetchFreeClsDB(arryVideo)
  
    }
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    userDefaults.setValue(doenloadedData, forKey: "downloadedData")
    userDefaults.synchronize()
    dataFetchVedioDone()
    self.defaultUIDesign()
  
  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    self.view.bringSubviewToFront(self.actiIndecatorVw)
    //self.defaultUIDesign()
    
      if(isActive.isEqualToString("Paied")){
        self.userClsVideoApiCalling()
        startLearningApiCall()
      }else if (isActive.isEqualToString("Free")){
        self.freeClsVideoApiCalling()
      }
  }

  func defaultUIDesign(){
    
    tableview.frame =  CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y, self.view.frame.width,self.view.frame.height)
    tableview.delegate = self
    tableview.dataSource = self
    tableview.separatorStyle = UITableViewCellSeparatorStyle.None
    
  }

  func btnBackTapped(){
    self.navigationController?.popViewControllerAnimated(true)
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
    if(arrClassVideo.count>0){
    cell.defaultUIDesign(arrClassVideo.objectAtIndex(indexPath.row) as NSDictionary,frame: self.view.frame)
    var dict: NSDictionary = arrClassVideo.objectAtIndex(indexPath.row) as NSDictionary
    cell.btnplay.tag = indexPath.row
    cell.btnplay.addTarget(self, action: "btnPalyTapped:", forControlEvents: UIControlEvents.TouchUpInside)
    cell.btnComplete.tag = dict.valueForKey("id") as NSInteger
    cell.btnComplete.addTarget(self, action: "btnCompleteTapped:", forControlEvents: UIControlEvents.TouchUpInside)
   
    //cell.downloadProgress.setProgress(0, animated:false)
    if (isActive.isEqualToString("Free")){
       cell.btnComplete.hidden = true
    }
    
    if(videoDone.count>0){
      for var index = 0; index < videoDone.count; ++index{
        let obj = videoDone.objectAtIndex(index) as VideoDone
        if(obj.video_id.integerValue == cell.btnComplete.tag){
          cell.btnComplete.userInteractionEnabled = false
          cell.btnComplete.backgroundColor = UIColor(red: 237.0/255.0, green: 62.0/255.0, blue: 61.0/255.0,alpha:1.0)
        }
      }
      
    }
   
      var fileName: NSString = dict.valueForKey("name") as NSString + ".mp4"
      let documentsPath: NSArray = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
      let url: NSString = documentsPath.objectAtIndex(0) as NSString
      let path: NSString! = url+"/"+fileName
      
      let manager = NSFileManager.defaultManager()
      if (manager.fileExistsAtPath(path)){
        cell.btnplay.hidden = true
        self.calculateVideofileSize(path)
      }
    }
    return cell
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
   
    var dict: NSDictionary = arrClassVideo.objectAtIndex(indexPath.row) as NSDictionary
    
    var fileName: NSString = dict.valueForKey("name") as NSString + ".mp4"
    let documentsPath: NSArray = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
    let url: NSString = documentsPath.objectAtIndex(0) as NSString
    let path: NSString! = url+"/"+fileName
    let manager = NSFileManager.defaultManager()
    if (manager.fileExistsAtPath(path)){
      
      var str: NSString = dict.valueForKey("name") as NSString
      
      var fileName: NSString! = str.stringByAppendingString(".mp4")
      let aParams : NSDictionary = ["fileName":fileName]
      let viedoUrl: NSURL = api.getDocumentDirectoryFileURL(aParams)
      let vc = self.storyboard?.instantiateViewControllerWithIdentifier("PalyVideoVW") as VideoPalyViewController
       vc.viedoUrl = viedoUrl
       self.navigationController?.pushViewController(vc, animated: true)
    }
    
  }
  
  
  func btnCompleteTapped(sender:AnyObject){
    var btn = sender as UIButton
    print(btn.tag)
    var userId:Int = CommonUtilities.sharedDelegate().dictUserInfo.objectForKey("id") as Int
    var aParam: NSDictionary = NSDictionary(objects: [auth_token[0],classID,btn.tag,userId], forKeys: ["auth_token","cls_id","video_id", "userId"])

    self.api.videoComplete(aParam, success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
      println(responseObject)
         btn.backgroundColor = UIColor(red: 237.0/255.0, green: 62.0/255.0, blue: 61.0/255.0,alpha:1.0)

      if(responseObject?.count>0){
        self.videoDone = responseObject as NSArray
        self.tableview.reloadData()
      }
      },
      failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
        println(error)
        var alert: UIAlertView = UIAlertView(title: "Alert", message:operation?.responseString, delegate:self, cancelButtonTitle:"OK")
        alert.show()
    })
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
        var alert: UIAlertView = UIAlertView(title: "Alert", message: "Downloaded successfully.", delegate:self, cancelButtonTitle:"OK")
        alert.show()
        },
        failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
          println(error)
          var alert: UIAlertView = UIAlertView(title: "Alert", message: "Downloading failed.", delegate:self, cancelButtonTitle:"OK")
          alert.show()
          
      })
    
  }
  
  func calculateVideofileSize(filePath:NSString){
    var fileAttributes: NSDictionary = NSFileManager.defaultManager().attributesOfItemAtPath(filePath, error:nil)!
    var fileSizeNumber: AnyObject? = fileAttributes.objectForKey(NSFileSize)
    var fileSize = fileSizeNumber?.doubleValue
    
    let arry = DownloadedData.MR_findAll() as NSArray
    
    if(arry.count>0){
    
    var obj = arry.objectAtIndex(0) as DownloadedData
    var prevData = obj.download_data.doubleValue
    
    var currtData = prevData + fileSize!
      var aParam:NSMutableDictionary! = NSMutableDictionary()
      aParam.setValue(1, forKey: "id")
      aParam.setValue(currtData, forKey: "data")
      api.saveDownloadedData(aParam)

    }else{
      var aParam:NSMutableDictionary! = NSMutableDictionary()
      aParam.setValue(1, forKey: "id")
      aParam.setValue(0, forKey: "data")
      api.saveDownloadedData(aParam)
      
    }
    
    
//    var defaults=NSUserDefaults()
//    var preData=defaults.integerForKey("downloadedData")
//    
//    var currtData = preData+fileSize!
//    
//    let userDefaults = NSUserDefaults.standardUserDefaults()
//    userDefaults.setValue(currtData, forKey: "downloadedData")
//    userDefaults.synchronize()

    
  }
  
  //*********** Api Calling Methods**********
  
  func freeClsVideoApiCalling(){
    var aParam: NSDictionary = NSDictionary(objects: [auth_token[0],classID], forKeys: ["auth_token","class_id"])
    
    self.api.freeClsVideoList(aParam, success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
      println(responseObject)
      self.actiIndecatorVw.loadingIndicator.stopAnimating()
      self.actiIndecatorVw.removeFromSuperview()
      let arryVideo:NSArray = responseObject as NSArray
      self.dataFetchFreeClsDB(arryVideo)
      self.tableview.reloadData()
      if(arryVideo.count==0){
//        var alert: UIAlertView = UIAlertView(title: "Alert", message: "Sorry no video found.", delegate:self, cancelButtonTitle:"OK")
//        alert.show()
        self.setDataNofoundImg()
      }
      },
      failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
        println(error)
    })

  }
  
  func userClsVideoApiCalling(){
    var aParam: NSDictionary = NSDictionary(objects: [auth_token[0],classID], forKeys: ["auth_token","class_id"])
    
    self.api.userClassVideo(aParam, success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
      println(responseObject)
      self.actiIndecatorVw.loadingIndicator.stopAnimating()
      self.actiIndecatorVw.removeFromSuperview()
      let arryVideo:NSArray = responseObject as NSArray
      if(arryVideo.count>0){
        self.dataFetchUserClsDB(arryVideo)
        self.tableview.reloadData()
      }else{
//        var alert: UIAlertView = UIAlertView(title: "Alert", message: "Sorry no video found.", delegate:self, cancelButtonTitle:"OK")
//        alert.show()
        self.setDataNofoundImg()
      }
      
      },
      failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
        println(error)
        
    })
    
  }
  
  
  //**************Start Learning Api Calling***********
  
  func startLearningApiCall(){
    
    var aParams: NSMutableDictionary! = NSMutableDictionary()
    aParams.setValue(auth_token[0], forKey: "auth_token")
    aParams.setValue(classID, forKey: "cls_id")
    
    self.api.startLearning(aParams, success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
      println(responseObject)
      
      },
      failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
        println(error)
        var alert: UIAlertView = UIAlertView(title: "Alert", message: "Sorry Somethig Worng", delegate:self, cancelButtonTitle:"OK")
        alert.show()
    })
  }

  
  func dataFetchVedioDone(){
    var predicate:NSPredicate = NSPredicate (format: "video_cls_id CONTAINS %i", classID)!
    self.videoDone = VideoDone.MR_findAllWithPredicate(predicate)
  }
  
  
  func dataFetchFreeClsDB(arrFetchCat: NSArray){
    if(arrFetchCat.count>0){
    arrClassVideo.removeAllObjects()
     print(arrFetchCat.count)
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
    }else{
      //setDataNofoundImg()
    }
    }
  
  func dataFetchUserClsDB(arrFetchCat: NSArray){
    if(arrFetchCat.count>0){
    arrClassVideo.removeAllObjects()
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
    }else{
      //setDataNofoundImg()
    }

  }
  
  func setDataNofoundImg(){
    lblNoData = UILabel(frame: CGRectMake(self.view.frame.origin.x+20,self.view.frame.origin.y+120,self.view.frame.width-40, 30))
    lblNoData.text = "Sorry no data found."
    lblNoData.textAlignment = NSTextAlignment.Center
    self.view.addSubview(lblNoData)
    self.view.bringSubviewToFront(lblNoData)
    imagViewNoData = UIImageView(frame: CGRectMake((self.view.frame.width-100)/2,(self.view.frame.height-100)/2,100,100))
    imagViewNoData.image = UIImage(named:"smile")
    self.view.addSubview(imagViewNoData)
    self.view.bringSubviewToFront(imagViewNoData)
  }


}
