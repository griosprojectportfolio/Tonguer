//
//  AppFlowViewController.swift
//  Tonguer
//
//  Created by GrepRuby on 07/04/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import UIKit

class AppFlowViewController: BaseViewController {
  
  var barBackBtn :UIBarButtonItem!
  var barforwordBtn :UIBarButtonItem!
  var imgVwVedio,imgVwAlpha: UIImageView!
  var VwimgBG :UIView!
  var lblDescrip : UILabel!
  var btnplay : UIButton!
  var video_url: NSString!
  var scrollVW: UIScrollView!
  var api: AppApi!
  var strMessage: NSString = ""
  
  override func viewDidLoad() {
    super.viewDidLoad()
    api = AppApi.sharedClient()
    
    self.title = "About App"
  
    self.navigationItem.setHidesBackButton(true, animated:false)
    
    var backbtn:UIButton = UIButton(frame: CGRectMake(0, 0,25,25))
    backbtn.setImage(UIImage(named: "whiteback.png"), forState: UIControlState.Normal)
    backbtn.addTarget(self, action: "btnBackTapped", forControlEvents: UIControlEvents.TouchUpInside)
    
    barBackBtn = UIBarButtonItem(customView: backbtn)
    
    self.navigationItem.setLeftBarButtonItem(barBackBtn, animated: true)
   
    let arry = Aboutus.MR_findAll()
     dataFetchFromDatabase(arry)
     self.defaultUIDesign()
    
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    abouUSApiCall()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func defaultUIDesign(){
    
    scrollVW = UIScrollView(frame: CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height))
    
    scrollVW.showsHorizontalScrollIndicator = true
    scrollVW.scrollEnabled = true
    scrollVW.userInteractionEnabled = true
    //  scrollVW.backgroundColor = UIColor.redColor()
    scrollVW.contentOffset = CGPoint(x: 0, y: 0)
    scrollVW.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)
    
   self.view.addSubview(scrollVW)
    
     var rect: CGRect! = strMessage.boundingRectWithSize(CGSize(width:self.view.frame.size.width-60,height:300), options:NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(12)], context: nil)
    
    VwimgBG = UIView(frame: CGRectMake(scrollVW.frame.origin.x+20,scrollVW.frame.origin.y+20, scrollVW.frame.size.width - 40,300))
    //VwimgBG.backgroundColor = UIColor.blackColor()
    scrollVW.addSubview(VwimgBG)
    
    imgVwVedio = UIImageView(frame: CGRectMake((VwimgBG.frame.width-140)/2, (VwimgBG.frame.height-140)/2, 140,150))
    imgVwVedio.image = UIImage(named: "Splash.png")
    VwimgBG.addSubview(imgVwVedio)
    
    var tapGuesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tapForVideoPaly")
    
    imgVwAlpha = UIImageView()
    imgVwAlpha.frame = VwimgBG.bounds
    imgVwAlpha.userInteractionEnabled = true
    imgVwAlpha.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
    imgVwAlpha.addGestureRecognizer(tapGuesture)
    VwimgBG.addSubview(imgVwAlpha)
    
    btnplay = UIButton(frame: CGRectMake((imgVwAlpha.frame.width-50)/2,(imgVwAlpha.frame.height-50)/2,50,50))
    btnplay.backgroundColor = UIColor.clearColor()
    btnplay.setImage(UIImage(named: "playicon.png"), forState: UIControlState.Normal)
    btnplay.tintColor = UIColor.redColor()
    btnplay.layer.cornerRadius = 25
    btnplay.layer.borderWidth = 1
    btnplay.layer.borderColor = UIColor.clearColor().CGColor
    btnplay.addTarget(self, action: "btnPlayTapped:", forControlEvents: UIControlEvents.TouchUpInside)
    imgVwAlpha.addSubview(btnplay)
    self.view.bringSubviewToFront(btnplay)
    
    lblDescrip = UILabel(frame: CGRectMake(scrollVW.frame.origin.x+20,VwimgBG.frame.origin.y+VwimgBG.frame.size.height+10,scrollVW.frame.width-40,rect.height))
    lblDescrip.text = strMessage
    lblDescrip.numberOfLines = 0
    lblDescrip.textAlignment = NSTextAlignment.Justified
    lblDescrip.font = lblDescrip.font.fontWithSize(12)
    lblDescrip.textColor = UIColor.grayColor()
    //lblDescrip.backgroundColor = UIColor.greenColor()
    scrollVW.addSubview(lblDescrip)
    
    var str: NSString = "Video"
    
    var fileName: NSString! = str.stringByAppendingString(".mp4")
    
    let documentsPath: NSArray = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
    let url: NSString = documentsPath.objectAtIndex(0) as NSString
    let path: NSString! = url+"/"+fileName
    
    let manager = NSFileManager.defaultManager()
    if (manager.fileExistsAtPath(path)){
      btnplay.hidden = true
    }

    
  }
  
  func btnBackTapped(){
    self.navigationController?.popViewControllerAnimated(true)
  }
  
  func tapForVideoPaly(){
    
    var str: NSString = "Video"
    
    var fileName: NSString! = str.stringByAppendingString(".mp4")
    let aParams : NSDictionary = ["fileName":fileName]
    let viedoUrl: NSURL = api.getDocumentDirectoryFileURL(aParams)
    
    let documentsPath: NSArray = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
    let url: NSString = documentsPath.objectAtIndex(0) as NSString
    let path: NSString! = url.stringByAppendingString("/Video.mp4")
    
    let manager = NSFileManager.defaultManager()
    if (manager.fileExistsAtPath(path)){
      let vc = self.storyboard?.instantiateViewControllerWithIdentifier("PalyVideoVW") as VideoPalyViewController
      vc.viedoUrl = viedoUrl
      self.navigationController?.pushViewController(vc, animated: true)
    }else {
      
    }
    
  }
  
  
  
  func btnPlayTapped(sender:AnyObject){
    print("Tapped")
    btnplay.setImage(UIImage(named:"download.png"), forState: UIControlState.Normal)
    var str: NSString = "Video"
    
    var fileName: NSString! = str.stringByAppendingString(".mp4")
    let aPara : NSDictionary = ["fileName":fileName]
    
    var aParams: NSDictionary = NSDictionary(objects: [video_url,fileName], forKeys: ["url","fileName"])
    
    self.api.downloadMediaData(aParams, success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
      println(responseObject)
      self.btnplay.hidden = true
      },
      failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
        println(error)
        
    })

  }
  
  //************Api methode Call Post Comments*********
  
  func abouUSApiCall(){
    
     var aParams: NSDictionary = NSDictionary(objects: self.auth_token, forKeys: ["auth_token"])
    
    self.api.aboutUS(nil, success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
      println(responseObject)
      var arry = responseObject as NSArray
      self.dataFetchFromDatabase(arry)
      
      
      },
      failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
        println(error)
        
    })
    
  }
  
  func dataFetchFromDatabase(arry:NSArray){
    let obj = arry.objectAtIndex(0) as Aboutus
    let data = obj.ab_content
    self.strMessage = data
    self.video_url = obj.ab_videourl as NSString
    
  }

  
  
}
