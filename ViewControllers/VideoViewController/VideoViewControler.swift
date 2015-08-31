//
//  VideoViewControler.swift
//  Tonguer
//
//  Created by GrepRuby on 20/04/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import UIKit
import MediaPlayer


class VideoViewControler: BaseViewController,UITableViewDataSource,UITableViewDelegate{
  
  var classID:NSInteger!
  var api: AppApi!
  var isActive: NSString!
  var btnDelete: UIButton!
  var barBackBtn :UIBarButtonItem!
  var barDeleteBtn :UIBarButtonItem!
  var barforwordBtn :UIBarButtonItem!
@IBOutlet  var tblView: UITableView!
  var arrClassVideo: NSMutableArray = NSMutableArray()
  var actiIndecatorVw: ActivityIndicatorView!
  var moviePlayerController:MPMoviePlayerController!
  var doenloadedData:NSInteger = 0
  var videoDone:NSArray! = NSArray()
  var imagViewNoData:UIImageView!
  var lblNoData: UILabel!
  var vdoDownloadFlag:Bool = false
  var btnpalyflag:Bool = false
  var arrDeleteObject:NSMutableArray = NSMutableArray()
  var arrVideoSelect:NSMutableArray = NSMutableArray()
  var longPress: UILongPressGestureRecognizer!
  let notificationCenter = NSNotificationCenter.defaultCenter()
  var player:MPMoviePlayerViewController!
  
  var arrVdoDownIndex:NSMutableArray = NSMutableArray()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    api = AppApi.sharedClient()
    api.progressVW = UIProgressView()
    arrClassVideo.removeAllObjects()
    self.title = "Videos"
    
    
    self.navigationItem.setHidesBackButton(true, animated:false)
    
    var backbtn:UIButton = UIButton(frame: CGRectMake(0, 0,25,25))
    backbtn.setImage(UIImage(named: "whiteback.png"), forState: UIControlState.Normal)
    backbtn.addTarget(self, action: "btnBackTapped", forControlEvents: UIControlEvents.TouchUpInside)
    barBackBtn = UIBarButtonItem(customView: backbtn)
    self.navigationItem.setLeftBarButtonItem(barBackBtn, animated: true)
    
    
    btnDelete = UIButton(frame: CGRectMake(0, 0, 25, 25))
    btnDelete.setImage(UIImage(named: "deleteicon.png"), forState: UIControlState.Normal)
    btnDelete.addTarget(self, action: "btnDeleteTapped:", forControlEvents: UIControlEvents.TouchUpInside)
    barDeleteBtn = UIBarButtonItem(customView: btnDelete)
    self.navigationItem.setRightBarButtonItem(barDeleteBtn, animated:true)
    
    actiIndecatorVw = ActivityIndicatorView(frame: self.view.frame)
    self.view.addSubview(actiIndecatorVw)
    
//    var predicate:NSPredicate = NSPredicate (format: "cls_id CONTAINS %i", classID);
//    
//   
//    if(isActive.isEqualToString("Paied")){
//      let arryVideo:NSArray = UserClsVideo.MR_findAllWithPredicate(predicate)
//      self.dataFetchUserClsDB(arryVideo)
//      
//    } else if (isActive.isEqualToString("Free")){
//     let arryVideo:NSArray = FreeClssVideo.MR_findAllWithPredicate(predicate)
//      self.dataFetchFreeClsDB(arryVideo)
//  
//    }
    self.datafetching()
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    userDefaults.setValue(doenloadedData, forKey: "downloadedData")
    userDefaults.synchronize()
    
    self.defaultUIDesign()
  
    if(isActive.isEqualToString("Paied")){
      self.userClsVideoApiCalling()
      startLearningApiCall()
    }else if (isActive.isEqualToString("Free")){
      self.freeClsVideoApiCalling()
    }
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    //tblView.reloadData()
  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    restrictRotation(true)
    self.view.bringSubviewToFront(self.actiIndecatorVw)
    //self.defaultUIDesign()
    /*
      if(isActive.isEqualToString("Paied")){
        self.userClsVideoApiCalling()
        startLearningApiCall()
      }else if (isActive.isEqualToString("Free")){
        self.freeClsVideoApiCalling()
      }
*/
    
  }
  
  func datafetching(){
    var predicate:NSPredicate = NSPredicate (format: "cls_id CONTAINS %i", classID);
    
    
    if(isActive.isEqualToString("Paied")){
      let arryVideo:NSArray = UserClsVideo.MR_findAllWithPredicate(predicate)
      self.dataFetchUserClsDB(arryVideo)
      
    } else if (isActive.isEqualToString("Free")){
      let arryVideo:NSArray = FreeClssVideo.MR_findAllWithPredicate(predicate)
      self.dataFetchFreeClsDB(arryVideo)
      
    }

  }
  

  func defaultUIDesign(){
    
    tblView.frame =  CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y, self.view.frame.width,self.view.frame.height)
    tblView.delegate = self
    tblView.dataSource = self
    tblView.separatorStyle = UITableViewCellSeparatorStyle.None
    
  }
  
  func restrictRotation(restriction:Bool) {
    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    appDelegate.restrictRotation = restriction;
  }

  func btnBackTapped(){
    NSNotificationCenter.defaultCenter().removeObserver(self)
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
    
    var cell = tblView.dequeueReusableCellWithIdentifier("cell") as! VideoTableViewCell!
    if cell == nil {
      cell = VideoTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
    }
    
    if cell.circle != nil{
     cell.circle.removeFromSuperview()
    }
    
    
    cell.cellIndex = indexPath.row
    print(cell.cellIndex)
    
    if (arrVideoSelect.containsObject(indexPath.row)){
      cell.backgroundColor = UIColor(red: 237.0/255.0, green: 62.0/255.0, blue: 61.0/255.0,alpha:0.5)
    }else{
      cell.backgroundColor = UIColor.clearColor()
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyle.None
    if(arrClassVideo.count>0){
    cell.defaultUIDesign(arrClassVideo.objectAtIndex(indexPath.row) as! NSDictionary,frame: self.view.frame)
    var dict: NSDictionary = arrClassVideo.objectAtIndex(indexPath.row) as! NSDictionary
    cell.btnplay.tag = indexPath.row
    cell.btnplay.addTarget(self, action: "btnPalyTapped:", forControlEvents: UIControlEvents.TouchUpInside)
    cell.btnComplete.tag = dict.valueForKey("id") as! NSInteger
    cell.btnComplete.addTarget(self, action: "btnCompleteTapped:", forControlEvents: UIControlEvents.TouchUpInside)
    cell.setVideoDownloadingProgessbar(self.view.frame, stokend:0)
      
      if(isActive.isEqualToString("Paied")){
        var finished_status = dict.valueForKey("finished_status") as! NSNumber
        if(finished_status == 1){
          cell.btnComplete.userInteractionEnabled = false
          cell.btnComplete.backgroundColor = UIColor(red: 237.0/255.0, green: 62.0/255.0, blue: 61.0/255.0,alpha:1.0)
        }
      }
    
    if (isActive.isEqualToString("Free")){
       cell.btnComplete.hidden = true
    }
     
      var documentsPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory,NSSearchPathDomainMask.UserDomainMask,true) as NSArray
    //************video downloading  check*********
      var str: NSString = dict.valueForKey("name") as! NSString
      var strName: String = "/"+"temp" + (str as String)
      var filen: String! = strName.stringByAppendingString(".mp4")
      var strPathD = documentsPath.objectAtIndex(0) as! String
      var fileD = strPathD.stringByAppendingString(filen) as String
      
      let managerD = NSFileManager.defaultManager()
      if (managerD.fileExistsAtPath(fileD)){
        //cell.btnplay.setImage(UIImage(named: "playicon.png"), forState: UIControlState.Normal)
        //let notificationCenter = NSNotificationCenter.defaultCenter()
       NSNotificationCenter.defaultCenter().addObserver(self, selector:"updateCellProgrssbarStatus:", name:"DOWNLOAD_PROGRESS", object:nil)
      }
      
      
      
      
      if arrVdoDownIndex.count != 0 {
        print(arrVdoDownIndex)
        if arrVdoDownIndex.containsObject(indexPath.row) {
          cell.circle.removeFromSuperview()
          
          cell.dwonCompleteImgView.hidden = false
          cell.lbldwonComplete.hidden = false
          
        }
      }
      
     //************Original Video Path check*********
      var fileName:String = "/"+(dict.valueForKey("name")  as! String) + ".mp4"
      var strPath = documentsPath.objectAtIndex(0) as! String
      var file = strPath.stringByAppendingString(fileName) as String
       cell.btnplay.hidden = false
      let manager = NSFileManager.defaultManager()
      if (manager.fileExistsAtPath(file)){
        cell.btnplay.hidden = true
        cell.dwonCompleteImgView.hidden = false
        cell.lbldwonComplete.hidden = false
        cell.circle.removeFromSuperview()
        //NSNotificationCenter.defaultCenter().removeObserver(self)
        self.calculateVideofileSize(file)
      }
    }
    
    longPress = UILongPressGestureRecognizer(target: self, action: "cellLongPressed:")
    longPress.minimumPressDuration = 0.5
    cell.addGestureRecognizer(longPress)

    return cell
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
    
    var dict: NSDictionary = arrClassVideo.objectAtIndex(indexPath.row) as! NSDictionary
    
    var fileName: NSString = (dict.valueForKey("name") as! NSString as String) + ".mp4"
    let documentsPath: NSArray = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
    let url: NSString = documentsPath.objectAtIndex(0) as! NSString
    let path = (url as String)+"/"+(fileName as String)
    let manager = NSFileManager.defaultManager()
    if (manager.fileExistsAtPath(path)){
      restrictRotation(false)
      var str: NSString = dict.valueForKey("name") as! NSString
      
      var fileName: NSString! = str.stringByAppendingString(".mp4")
      let aParams : NSDictionary = ["fileName":fileName]
      let viedoUrl: NSURL = api.getDocumentDirectoryFileURL(aParams as[NSObject : AnyObject])
      
      player = MPMoviePlayerViewController(contentURL: viedoUrl)
      player.moviePlayer.scalingMode = MPMovieScalingMode.Fill
      self.presentMoviePlayerViewControllerAnimated(player)
      
      NSNotificationCenter.defaultCenter().addObserver(self, selector:"doneButtonClick:", name:MPMoviePlayerPlaybackDidFinishNotification, object:nil)
      
//      let vc = self.storyboard?.instantiateViewControllerWithIdentifier("PalyVideoVW") as! VideoPalyViewController
//       vc.viedoUrl = viedoUrl
//       self.navigationController?.pushViewController(vc, animated: true)
  
    }else{
      var alert: UIAlertView = UIAlertView(title: "Alert", message:"Pleae download this video after that you will able to play this video.", delegate:self, cancelButtonTitle:"OK")
      alert.show()
    }
}
  
  func doneButtonClick(aNotification:NSNotification){
    
    var reason = aNotification.userInfo![MPMoviePlayerPlaybackDidFinishReasonUserInfoKey] as! NSNumber
    
    let reasonValue = MPMovieFinishReason(rawValue: reason.integerValue)
     restrictRotation(true)
     NSNotificationCenter.defaultCenter().removeObserver(self)
    self.dismissMoviePlayerViewControllerAnimated()
    
  }
  
  
  func updateCellProgrssbarStatus(notification: NSNotification){
    
    var dict:NSDictionary! = notification.userInfo
    var obj = notification.object as! NSDictionary
    print("%@*******",dict.valueForKey("progress"))
    print(obj)
    var cellIndex = obj.valueForKey("video_index") as! NSInteger
    var  selectedIndexPath = NSIndexPath(forRow: cellIndex, inSection: 0) as NSIndexPath
   
      var row = selectedIndexPath.row
   
    if(self.tblView.cellForRowAtIndexPath(selectedIndexPath) != nil)
    {
      if(cellIndex == row){
      var cell = self.tblView.cellForRowAtIndexPath(selectedIndexPath) as! VideoTableViewCell
      cell.circle.hidden = false
      var cgf  = dict.valueForKey("progress")?.floatValue
      var cgflo:CGFloat = CGFloat(cgf!)
      //cell.setVideoDownloadingProgessbar(self.view.frame, stokend: cgflo)
        cell.progressCircle.strokeEnd = cgflo
      if(cgflo==1.0){
        arrVdoDownIndex.addObject(row)
        print(arrVdoDownIndex)
        cell.btnplay.hidden = true
        cell.circle.hidden = true
        cell.dwonCompleteImgView.hidden = false
        cell.lbldwonComplete.hidden = false
      }else{
       //cell.circle.hidden = false
       cell.dwonCompleteImgView.hidden = true
      }
    }
    }
}
  
  
  func cellLongPressed(gestureRecognizer:UILongPressGestureRecognizer) {
   
    var objVideoCell : VideoTableViewCell = gestureRecognizer.view as! VideoTableViewCell
    let cellIndex : Int = objVideoCell.cellIndex as Int
    var dict: NSDictionary! = arrClassVideo.objectAtIndex(cellIndex) as! NSDictionary
    var video_id: NSInteger! = dict.valueForKey("id") as! NSInteger
    
    if(gestureRecognizer.state == UIGestureRecognizerState.Ended) {
      if (arrDeleteObject.containsObject(video_id)){
        arrDeleteObject.removeObject(video_id)
        arrVideoSelect.removeObject(cellIndex)
      }else{
        arrVideoSelect.addObject(cellIndex)
        arrDeleteObject.addObject(video_id)
      }
      println(arrDeleteObject)
      println(arrVideoSelect)
      
    }else if(gestureRecognizer.state == UIGestureRecognizerState.Began) {
      
      if (arrDeleteObject.containsObject(video_id)){
        objVideoCell.backgroundColor = UIColor.clearColor()
      }else{
        objVideoCell.backgroundColor = UIColor(red: 237.0/255.0, green: 62.0/255.0, blue: 61.0/255.0,alpha:0.5)
      }
      
    }
  }
  
  
  func btnDeleteTapped(sender:AnyObject){
    print(arrDeleteObject)
     println(self.arrClassVideo)
    
    if(arrDeleteObject.count != 0){
      
      let arrIds : NSArray = arrDeleteObject
      var strIds : String = arrIds.componentsJoinedByString(",")
      
      var aParam: NSDictionary = NSDictionary(objects: [auth_token[0],strIds,isActive], forKeys: ["auth-token","video_ids","active"])
      
      self.api.videoDelete(aParam as [NSObject : AnyObject], success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
        println(responseObject)
        print(self.arrVideoSelect)
        for var index = 0; index < self.arrVideoSelect.count; ++index {
          var cellindex = self.arrVideoSelect.objectAtIndex(index) as! NSInteger
          self.arrClassVideo.removeObjectAtIndex(cellindex)
          self.tblView.reloadData()
        }
        var alert: UIAlertView = UIAlertView(title: "Alert", message:"Video Deleted successfully.", delegate:self, cancelButtonTitle:"OK")
        alert.show()
        },
        failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
          println(error)
          var alert: UIAlertView = UIAlertView(title: "Alert", message:"Video Delete fail.", delegate:self, cancelButtonTitle:"OK")
          alert.show()
      })

    }else{
      var alert: UIAlertView = UIAlertView(title: "Alert", message:"You do not select any video please select videos after that you able to perform this function.", delegate:self, cancelButtonTitle:"OK")
      alert.show()
    }
    
  }
  
  
  
  func btnCompleteTapped(sender:AnyObject){
    var btn = sender as! UIButton
    print(btn.tag)
    var userId:Int = CommonUtilities.sharedDelegate().dictUserInfo.objectForKey("id") as! Int
    var aParam: NSDictionary = NSDictionary(objects: [auth_token[0],classID,btn.tag,userId], forKeys: ["auth-token","cls_id","video_id", "userId"])

    self.api.videoComplete(aParam as [NSObject : AnyObject], success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
      println(responseObject)
         btn.backgroundColor = UIColor(red: 237.0/255.0, green: 62.0/255.0, blue: 61.0/255.0,alpha:1.0)

      },
      failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
        println(error)
        var alert: UIAlertView = UIAlertView(title: "Alert", message:operation?.responseString, delegate:self, cancelButtonTitle:"OK")
        alert.show()
    })
  }
  
   
  
  func btnPalyTapped(sender:AnyObject){
     var btn = sender as! UIButton

    NSNotificationCenter.defaultCenter().addObserver(self, selector:"updateCellProgrssbarStatus:", name:"DOWNLOAD_PROGRESS", object:nil)
    btn.hidden = true
    btn.userInteractionEnabled = false
    var  selectedIndexPath = NSIndexPath(forRow: btn.tag, inSection: 0) as NSIndexPath
    var cell = self.tblView.cellForRowAtIndexPath(selectedIndexPath) as! VideoTableViewCell
     //cell.setVideoDownloadingProgessbar(self.view.frame, stokend:0.00)
      //btn.setImage(UIImage(named:"download.png"), forState: UIControlState.Normal)
    
      var dict: NSDictionary! = arrClassVideo.objectAtIndex(btn.tag) as! NSDictionary
      var video_index: NSInteger! = btn.tag
      var video_id: NSInteger! = dict.valueForKey("id") as! NSInteger
      var video_url: NSString! = dict.valueForKey("video_url") as! NSString
      var str: NSString = dict.valueForKey("name") as! NSString
      var strName: String = "temp" + (str as String)
      var fileName: NSString! = strName.stringByAppendingString(".mp4")
      let aPara : NSDictionary = ["fileName":fileName]
      
      var aParams: NSDictionary = NSDictionary(objects: [video_url,fileName,video_id,video_index], forKeys: ["url","fileName","video_id","video_index"])
      
      self.api.downloadMediaData(aParams as [NSObject : AnyObject], success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
        println(responseObject)
        //NSNotificationCenter.defaultCenter().removeObserver(self)
        btn.hidden = true
        cell.circle.hidden = true
        var alert: UIAlertView = UIAlertView(title:str as String, message: "Downloaded successfully.", delegate:self, cancelButtonTitle:"OK")
        alert.show()
        },
        failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
          println(error)
          NSNotificationCenter.defaultCenter().removeObserver(self)
          btn.userInteractionEnabled = true
          cell.circle.removeFromSuperview()
          
          btn.hidden = false
          cell.circle.removeFromSuperview()
          btn.setImage(UIImage(named: "playicon.png"), forState: UIControlState.Normal)
          var alert: UIAlertView = UIAlertView(title: "Alert", message: "Downloading failed.", delegate:self, cancelButtonTitle:"OK")
          alert.show()
          
      })
    
  }
  
  func calculateVideofileSize(filePath:NSString){
    var fileAttributes: NSDictionary = NSFileManager.defaultManager().attributesOfItemAtPath(filePath as String, error:nil)!
    var fileSizeNumber: AnyObject? = fileAttributes.objectForKey(NSFileSize)
    var fileSize = fileSizeNumber?.doubleValue
    
    let arry = DownloadedData.MR_findAll() as NSArray
    
    if(arry.count>0){
    
    var obj = arry.objectAtIndex(0) as! DownloadedData
    var prevData = obj.download_data.doubleValue
    
    var currtData = prevData + fileSize!
      var aParam:NSMutableDictionary = NSMutableDictionary()
      aParam.setValue(1, forKey: "id")
      aParam.setValue(currtData, forKey: "data")
      api.saveDownloadedData(aParam as [NSObject : AnyObject])

    }else{
      var aParam:NSMutableDictionary = NSMutableDictionary()
      aParam.setValue(1, forKey: "id")
      aParam.setValue(0, forKey: "data")
      api.saveDownloadedData(aParam as [NSObject : AnyObject])
      
    }
  
  }
  
  //*********** Api Calling Methods**********
  
  func freeClsVideoApiCalling(){
    var aParam: NSDictionary = NSDictionary(objects: [auth_token[0],classID], forKeys: ["auth-token","class_id"])
    
    self.api.freeClsVideoList(aParam as [NSObject : AnyObject], success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
      println(responseObject)
      self.actiIndecatorVw.loadingIndicator.stopAnimating()
      self.actiIndecatorVw.removeFromSuperview()
      let arryVideo:NSArray = responseObject as! NSArray
      self.dataFetchFreeClsDB(arryVideo)
      self.tblView.reloadData()
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
    
    var userId:Int = CommonUtilities.sharedDelegate().dictUserInfo.objectForKey("id") as! Int
    
    var aParam: NSDictionary = NSDictionary(objects: [auth_token[0],classID,userId], forKeys: ["auth-token","class_id","userId"])
    
    self.api.userClassVideo(aParam as [NSObject : AnyObject], success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
      println(responseObject)
      self.actiIndecatorVw.loadingIndicator.stopAnimating()
      self.actiIndecatorVw.removeFromSuperview()
      let arryVideo:NSArray = responseObject as! NSArray
      if(arryVideo.count>0){
        self.dataFetchUserClsDB(arryVideo)
        self.tblView.reloadData()
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
    
    var aParams: NSMutableDictionary = NSMutableDictionary()
    aParams.setValue(auth_token[0], forKey: "auth-token")
    aParams.setValue(classID, forKey: "cls_id")
    
    self.api.startLearning(aParams as [NSObject : AnyObject], success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
      println(responseObject)
      
      },
      failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
        println(error)
//        var alert: UIAlertView = UIAlertView(title: "Alert", message: "Sorry Somethig Worng", delegate:self, cancelButtonTitle:"OK")
//        alert.show()
    })
  }

  func dataFetchFreeClsDB(arrFetchCat: NSArray){
    if(arrFetchCat.count>0){
    arrClassVideo.removeAllObjects()
     print(arrFetchCat.count)
    for var index = 0; index < arrFetchCat.count; ++index{
      let clsObject: FreeClssVideo = arrFetchCat.objectAtIndex(index) as! FreeClssVideo
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
      
      if((clsObject.cls_id) != nil){
        var videoClsID: NSNumber = clsObject.cls_id
        dictClass.setValue(videoClsID, forKey: "class_id")
      }
      arrClassVideo.addObject(dictClass)
    }
    }else{
      self.tblView.reloadData()
    }
    }
  
  func dataFetchUserClsDB(arrFetchCat: NSArray){
    if(arrFetchCat.count>0){
    arrClassVideo.removeAllObjects()
    for var index = 0; index < arrFetchCat.count; ++index{
      let clsObject: UserClsVideo = arrFetchCat.objectAtIndex(index) as! UserClsVideo
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
      
      if((clsObject.finished_video) != nil){
        var finished_status:NSNumber = clsObject.finished_video
        dictClass.setValue(finished_status, forKey: "finished_status")
      }else{
        var finished_status: NSInteger = 0
        dictClass.setValue(finished_status, forKey: "finished_status")
      }

      arrClassVideo.addObject(dictClass)
     
    }
    }else{
      self.tblView.reloadData()
    }

  }
  
  func setDataNofoundImg(){
    lblNoData = UILabel(frame: CGRectMake(self.view.frame.origin.x+20,self.view.frame.origin.y+120,self.view.frame.width-40, 30))
    lblNoData.text = "Sorry no videos found."
    lblNoData.textAlignment = NSTextAlignment.Center
    self.view.addSubview(lblNoData)
    self.view.bringSubviewToFront(lblNoData)
    imagViewNoData = UIImageView(frame: CGRectMake((self.view.frame.width-100)/2,(self.view.frame.height-100)/2,100,100))
    imagViewNoData.image = UIImage(named:"smile")
    self.view.addSubview(imagViewNoData)
    self.view.bringSubviewToFront(imagViewNoData)
  }


}
