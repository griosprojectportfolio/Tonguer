//
//  ClassViewController.swift
//  Tonguer
//
//  Created by GrepRuby on 27/04/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import UIKit

class ClassViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate {
  
   var flgClass:NSString!
  var flag: NSString = "PicupCourse"
   var barBackBtn :UIBarButtonItem!
   var tblClass :UITableView!
   var dict: NSDictionary!
   var arrClasses: NSMutableArray! = NSMutableArray()
   var sub_cat_id: NSInteger!
   var actiIndecatorVw: ActivityIndicatorView!
  
  var api: AppApi!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    api = AppApi.sharedClient()
    print(sub_cat_id)
    dict = NSDictionary(objects: ["ClassName","000.0","date","defaultImg.png"], forKeys: ["class_name","priz","date","image"])
    
    self.title = "Classes"
        
    self.navigationItem.setHidesBackButton(true, animated:false)
    
    var backbtn:UIButton = UIButton(frame: CGRectMake(0, 0,25,25))
    backbtn.setImage(UIImage(named: "whiteback.png"), forState: UIControlState.Normal)
    backbtn.addTarget(self, action: "btnBackTapped", forControlEvents: UIControlEvents.TouchUpInside)
    
    barBackBtn = UIBarButtonItem(customView: backbtn)
    
    self.navigationItem.setLeftBarButtonItem(barBackBtn, animated: true)
    
    self.actiIndecatorVw = ActivityIndicatorView(frame: self.view.frame)
    self.view.addSubview(actiIndecatorVw)

    var predicate:NSPredicate = NSPredicate (format: "cls_subcategory_Id CONTAINS %i", sub_cat_id)!;
    var arrFetchCat:NSArray;
    if (flgClass.isEqualToString("Free")){
      arrFetchCat  = FreeCls.MR_findAllWithPredicate(predicate);
      self.dataFetchFromDatabaseFreeCls(arrFetchCat)

    } else if (flgClass.isEqualToString("Pay")) {
      arrFetchCat  = PayCls.MR_findAllWithPredicate(predicate);
      self.dataFetchFromDatabasePayCls(arrFetchCat)

    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  override func viewWillAppear(animated: Bool) {

    super.viewWillAppear(animated)
    self.view.bringSubviewToFront(self.actiIndecatorVw)
    self.defaultUIDesign()

    if(flgClass .isEqualToString("Pay")){
      self.payClassListApiCall()
    }else if (flgClass.isEqualToString("Free")){
      self.freeClassListApiCall()
    }
  }

  func defaultUIDesign(){
    
    
    tblClass = UITableView(frame: CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+64, self.view.frame.width, self.view.frame.height-64))
    tblClass.delegate = self
    tblClass.dataSource = self
    tblClass.separatorStyle = UITableViewCellSeparatorStyle.None
    self.view.addSubview(tblClass)
    tblClass.registerClass(ClassTableViewCell.self, forCellReuseIdentifier: "cell")
  
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return arrClasses.count
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 100
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell: ClassTableViewCell!
     cell = tblClass.dequeueReusableCellWithIdentifier("cell") as ClassTableViewCell
     cell.selectionStyle = UITableViewCellSelectionStyle.None
     cell.defaultCellContents(arrClasses.objectAtIndex(indexPath.row) as NSDictionary,frame: self.view.frame)
    return cell
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    if(flgClass .isEqualToString("Pay")){
      var vc = self.storyboard?.instantiateViewControllerWithIdentifier("CourseDetailID") as CourseDetailViewController
      vc.callVw = flgClass
      vc.clsDictDe = self.arrClasses.objectAtIndex(indexPath.row) as NSDictionary
      self.navigationController?.pushViewController(vc, animated: true)
    }else if (flgClass.isEqualToString("Free")){
//      let vc = self.storyboard?.instantiateViewControllerWithIdentifier("VideoID") as VideoViewControler
//      var dict: NSDictionary! = arrClasses.objectAtIndex(indexPath.row) as NSDictionary
//      vc.classID = dict.valueForKey("id") as NSInteger
//      self.navigationController?.pushViewController(vc, animated: true)
      
      var vc = self.storyboard?.instantiateViewControllerWithIdentifier("CourseDetailID") as CourseDetailViewController
      vc.callVw = flgClass
      vc.clsDictDe = self.arrClasses.objectAtIndex(indexPath.row) as NSDictionary
      self.navigationController?.pushViewController(vc, animated: true)
    }
    
  }
  
  //********* Class List Api Calling Method *********
  
  func freeClassListApiCall(){
    
    
    var aParams: NSDictionary = NSDictionary(objects: [self.auth_token[0],sub_cat_id], forKeys: ["auth_token","sub_category_id"])
    
    self.api.freeClsList(aParams, success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
      println(responseObject)
      self.actiIndecatorVw.loadingIndicator.stopAnimating()
      self.actiIndecatorVw.removeFromSuperview()
      let arry:NSArray = responseObject as NSArray
      self.dataFetchFromDatabaseFreeCls(arry)
      if self.arrClasses.count == 0{
        var alert: UIAlertView = UIAlertView(title: "Alert", message: "Sorry no class found.", delegate:self, cancelButtonTitle:"OK")
        alert.show()
      }
      self.tblClass.reloadData()
      println("\( self.arrClasses)")

      },
      failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
        println(error)
        var alert: UIAlertView! = UIAlertView(title: "Alert", message: "Sorry some technical problem.", delegate: self, cancelButtonTitle: "Ok")
        alert.show()
        self.actiIndecatorVw.loadingIndicator.stopAnimating()
        self.actiIndecatorVw.removeFromSuperview()
    })
  }

  func payClassListApiCall(){
    
    var aParams: NSDictionary = NSDictionary(objects: [auth_token[0],sub_cat_id], forKeys: ["auth_token","sub_category_id"])
    
    self.api.payClsList(aParams, success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
      println(responseObject)
      self.actiIndecatorVw.loadingIndicator.stopAnimating()
      self.actiIndecatorVw.removeFromSuperview()
      let arry:NSArray = responseObject as NSArray
      self.dataFetchFromDatabasePayCls(arry)
      if(self.arrClasses.count == 0){
        var alert: UIAlertView = UIAlertView(title: "Alert", message: "Sorry no class found.", delegate:self, cancelButtonTitle:"OK")
        alert.show()
      }
      self.tblClass.reloadData()
      println(self.arrClasses)
      },
      failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
        println(error)
        
    })
    
  }

  //************ Fetch Data From DataBase ***********
  func dataFetchFromDatabaseFreeCls(arryClass:NSArray){
    arrClasses.removeAllObjects()

    for var index = 0; index < arryClass.count; ++index {

      var clsObject:FreeCls = arryClass.objectAtIndex(index) as FreeCls
      println(clsObject.cls_arrange)
      var dictClass: NSMutableDictionary! = NSMutableDictionary()
      if((clsObject.cls_name) != nil){
        var strName: NSString = clsObject.cls_name
        dictClass.setValue(strName, forKey: "name")

      }else{
        var strName: NSString = ""
        dictClass.setValue(strName, forKey: "name")

      }
      if((clsObject.cls_day) != nil){
        var strDay: NSString = NSString(format: "%i",clsObject.cls_day.integerValue)
        dictClass.setValue(strDay, forKey: "valid_days")
      }else {
        dictClass.setValue("", forKey: "valid_days")
      }
      if((clsObject.img_url) != nil){
        var strImgUrl: NSString = clsObject.img_url
        dictClass.setValue(strImgUrl, forKey: "image")
        dictClass.setValue("Free", forKey: "price")
      }else{
        var strImgUrl: NSString = "http://www.popular.com.my/images/no_image.gif"
        dictClass.setValue(strImgUrl, forKey: "image")
        dictClass.setValue("", forKey: "price")
      }
      
      if ((clsObject.cls_arrange) != nil) {
        dictClass.setValue(clsObject.cls_arrange, forKey:"arrange")
      }else{
        var arrange: NSString = ""
        dictClass.setValue(arrange, forKey:"arrange")
      }
      
      if((clsObject.cls_suitable) != nil){
        dictClass.setValue(clsObject.cls_suitable, forKey:"suitable")
      }else{
        var suitable: NSString = " "
        dictClass.setValue(suitable, forKey:"suitable")
      }
      
      if ((clsObject.cls_target) != nil){
        dictClass.setValue(clsObject.cls_target, forKey:"target")
      }else{
        var target: NSString = " "
        dictClass.setValue(target, forKey:"target")
      }
      
      var clsID: NSNumber = clsObject.cls_id
      dictClass.setValue(clsID, forKey: "id")
      arrClasses.addObject(dictClass)
    }
  
  }

  //************ Fetch Data From DataBase ***********
  func dataFetchFromDatabasePayCls(arryClass:NSArray){
    arrClasses.removeAllObjects()

    for var index = 0; index < arryClass.count; ++index {

      var clsObject:PayCls = arryClass.objectAtIndex(index) as PayCls

      println(clsObject.cls_arrange)
      var dictClass: NSMutableDictionary! = NSMutableDictionary()
      if((clsObject.cls_name) != nil){
        var strName: NSString = clsObject.cls_name
        dictClass.setValue(strName, forKey: "name")

      }else{
        var strName: NSString = ""
        dictClass.setValue(strName, forKey: "name")

      }
      if((clsObject.cls_days) != nil){
        var strDay: NSString = NSString(format: "%i",clsObject.cls_days.integerValue)
        dictClass.setValue(strDay, forKey: "valid_days")
      }else {
        dictClass.setValue("0", forKey: "valid_days")
      }
      if((clsObject.cls_img_url) != nil){
        var strImgUrl: NSString = clsObject.cls_img_url
        dictClass.setValue(strImgUrl, forKey: "image")
      }else{
        var strImgUrl: NSString = "http://www.popular.com.my/images/no_image.gif"
        dictClass.setValue(strImgUrl, forKey: "image")
      }
      if((clsObject.cls_price) != nil){
        var strPrice = NSString(format: "%i",clsObject.cls_price.integerValue)
         dictClass.setValue(strPrice, forKey: "price")
      }else{
        dictClass.setValue("0", forKey: "price")
      }

      if ((clsObject.cls_arrange) != nil) {
        dictClass.setValue(clsObject.cls_arrange, forKey:"arrange")
      }else{
        var arrange: NSString = ""
        dictClass.setValue(arrange, forKey:"arrange")
      }

      if((clsObject.cls_suitable) != nil){
        dictClass.setValue(clsObject.cls_suitable, forKey:"suitable")
      }else{
        var suitable: NSString = " "
        dictClass.setValue(suitable, forKey:"suitable")
      }

      if ((clsObject.cls_target) != nil){
        dictClass.setValue(clsObject.cls_target, forKey:"target")
      }else{
        var target: NSString = " "
        dictClass.setValue(target, forKey:"target")
      }

      var clsID: NSNumber = clsObject.cls_id
      dictClass.setValue(clsID, forKey: "id")
      arrClasses.addObject(dictClass)
    }
    
  }

  func btnBackTapped(){
    self.navigationController?.popViewControllerAnimated(true)
  }
    
}
