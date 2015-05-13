//
//  PickupCoursecenterViewController.swift
//  Tonguer
//
//  Created by GrepRuby on 11/04/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import UIKit

class PickupCoursecenterViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate {
  
  let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
  
  var btntag: NSInteger = 1
  
  var api:AppApi!
  
  var barBackBtn :UIBarButtonItem!
  var barforwordBtn :UIBarButtonItem!
  
  var pickupTableView: UITableView!
  var allTableView: UITableView!
  
  var dataArr: NSMutableArray! = NSMutableArray()
  
   var arrHost: NSMutableArray! = NSMutableArray()
  
  var btnsVw: UIView!
  var dict: NSDictionary!
  var allCatDict: NSDictionary!
  var allSubCatDict: NSDictionary!
  var btnHost: UIButton!
  var btnAll: UIButton!
  var arrclasses:NSArray!
  var arrCat:NSArray!
  var arrSubCat:NSArray!
  var horiVw: UIView!
  var horiVw1: UIView!
  override func viewDidLoad() {
    super.viewDidLoad()
    dict = NSDictionary(objects: ["ClassName","000.0","date","img2.png"], forKeys: ["class_name","priz","date","image"])
    arrclasses = NSArray(object: dict)
    allCatDict = NSDictionary(objects: ["lblCatregories"], forKeys: ["cat_id"])
    arrCat = NSArray(object: allCatDict)
    allSubCatDict = NSDictionary(objects: ["lblSubCategories"], forKeys: ["sub_id"])
    arrSubCat = NSArray(object: allSubCatDict)
    
    api = AppApi.sharedClient()
    
    self.defaultUIDesign()
    self.allDataFetchFromDataBase()
    self.hostDataFetchFromDataBase()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func defaultUIDesign(){
    self.title = "Pick Up Course Center"
    self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
    
    self.navigationItem.setHidesBackButton(true, animated:false)
    
    var backbtn:UIButton = UIButton(frame: CGRectMake(0, 0,25,25))
    backbtn.setImage(UIImage(named: "sideIcon.png"), forState: UIControlState.Normal)
    backbtn.addTarget(self, action: "rightswipeGestureRecognizer", forControlEvents: UIControlEvents.TouchUpInside)
    
    barBackBtn = UIBarButtonItem(customView: backbtn)
    self.navigationItem.setLeftBarButtonItem(barBackBtn, animated: true)
    
    var btnforword:UIButton = UIButton(frame: CGRectMake(0, 0,25,25))
    btnforword.setImage(UIImage(named: "searchicon.png"), forState: UIControlState.Normal)
    btnforword.addTarget(self, action: "btnforwardTapped", forControlEvents: UIControlEvents.TouchUpInside)
    
    barforwordBtn = UIBarButtonItem(customView: btnforword)
    
    self.navigationItem.setRightBarButtonItem(barforwordBtn, animated: true)
    
//    btnsVw = UIView(frame: CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+64,self.view.frame.width, 40))
//    btnsVw.layer.borderWidth = 0.5
//    btnsVw.layer.borderColor = UIColor.lightGrayColor().CGColor
//    self.view.addSubview(btnsVw)
    
    btnHost = UIButton(frame: CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y+64,(self.view.frame.width/2)-2, 40))
    btnHost.setTitle("Host", forState: UIControlState.Normal)
    btnHost.setTitleColor(UIColor.grayColor(),forState: UIControlState.Normal)
    btnHost.tag = 1
    //btnHost.backgroundColor = UIColor.redColor()
    btnHost.addTarget(self, action: "btnHostTapped:", forControlEvents: UIControlEvents.TouchUpInside)
    self.view.addSubview(btnHost)
    
    horiVw = UIView(frame: CGRectMake(btnHost.frame.origin.x,btnHost.frame.size.height+btnHost.frame.origin.y,btnHost.frame.size.width,1))
    horiVw.backgroundColor = UIColor(red: 66.0/255.0, green: 150.0/255.0, blue: 173.0/255.0,alpha:1.0)
    self.view.addSubview(horiVw)
    
    var vertiVw: UIView! = UIView(frame: CGRectMake(btnHost.frame.width,btnHost.frame.origin.y,1,btnHost.frame.height))
    vertiVw.backgroundColor = UIColor.grayColor()
    self.view.addSubview(vertiVw)
    
    btnAll = UIButton(frame: CGRectMake(vertiVw.frame.origin.x+2,btnHost.frame.origin.y,btnHost.frame.width,40))
    btnAll.setTitle("All", forState: UIControlState.Normal)
    btnAll.setTitleColor(UIColor.grayColor(),forState: UIControlState.Normal)
    btnAll.tag = 2
    btnAll.addTarget(self, action: "btnAllTapped:", forControlEvents: UIControlEvents.TouchUpInside)
    //btnAll.backgroundColor = UIColor.redColor()
    self.view.addSubview(btnAll)
    
    horiVw1 = UIView(frame: CGRectMake(btnAll.frame.origin.x,btnAll.frame.size.height+btnAll.frame.origin.y,btnAll.frame.size.width,1))
    horiVw1.backgroundColor = UIColor(red: 66.0/255.0, green: 150.0/255.0, blue: 173.0/255.0,alpha:1.0)
    horiVw1.hidden = true
    self.view.addSubview(horiVw1)
    
    pickupTableView = UITableView(frame: CGRectMake(self.view.frame.origin.x,horiVw1.frame.origin.y+horiVw1.frame.size.height+5,self.view.frame.width,self.view.frame.height))
    pickupTableView.delegate = self
    pickupTableView.dataSource = self
    pickupTableView.separatorStyle = UITableViewCellSeparatorStyle.None
    self.view.addSubview(pickupTableView)
    
    pickupTableView.registerClass(PickupTableViewCell.self, forCellReuseIdentifier: "cell")
    pickupTableView.registerClass(AllTableViewCell.self, forCellReuseIdentifier: "allcell")

  }
  
  
  func rightswipeGestureRecognizer(){
    
    UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
      self.appDelegate.objSideBar.frame = self.view.bounds
      self.appDelegate.objSideBar.sideNavigation = self.navigationController
      }, completion: nil)
    
  }
  
  
  func btnHostTapped(sender:AnyObject){
    horiVw1.hidden = true
    horiVw.hidden = false
    var btn = sender as UIButton
    btntag = btn.tag
    print(btntag)
    pickupTableView.reloadData()
  }
  
  func btnAllTapped(sender:AnyObject){
    horiVw1.hidden = false
    horiVw.hidden = true
    var btn = sender as UIButton
    btntag = btn.tag
    print(btntag)
    //self.getPayClassApiCall()
   pickupTableView.reloadData()
  }

  
  func btnforwardTapped(){
    let vc = self.storyboard?.instantiateViewControllerWithIdentifier("SearchID") as SearchViewController
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    var count: NSInteger!
    if(btntag == 1){
      count = arrHost.count
    }else if(btntag == 2){
       var dict: NSDictionary! = dataArr.objectAtIndex(section) as NSDictionary
      var arr: NSArray! = dict.objectForKey("array") as NSArray
      count = arr.count
    }
    return count
  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    var count: NSInteger!
    if(btntag == 1){
      count = 1
    }else if(btntag == 2){
      print(dataArr.count)
      count = dataArr.count
    }
    return count
  }
  
  func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    var vWheader: UIView!
    if(btntag == 1){
      return vWheader
    }else if(btntag == 2){
      vWheader = UIView(frame: CGRectMake(5, 5, 100, 40))
      vWheader.backgroundColor = UIColor.whiteColor()
      vWheader.layer.borderWidth = 0.5
      vWheader.layer.borderColor = UIColor.lightGrayColor().CGColor
      vWheader.backgroundColor = UIColor(red: 71.0/255.0, green: 168.0/255.0, blue: 184.0/255.0,alpha:1.0)
      var dict: NSDictionary! = dataArr.objectAtIndex(section) as NSDictionary
      var lbltilte: UILabel! = UILabel(frame: CGRectMake(10, 2, 100,20))
      lbltilte.text = dict.objectForKey("name") as NSString
      lbltilte.font = lbltilte.font.fontWithSize(12)
      lbltilte.textColor = UIColor.whiteColor()
      vWheader.addSubview(lbltilte)
      
      return vWheader
    }
    return vWheader
    
  }
  
  func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    var str:NSString!
    if(btntag == 1){
      str = ""
      return str
    }else if (btntag == 2){
      var dict: NSDictionary! = dataArr.objectAtIndex(section) as NSDictionary
      str = dict.objectForKey("name") as NSString
      return str
    }
    return ""
  }
  
  
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell: UITableViewCell!
    
    if(btntag == 1){
      var hostCell = pickupTableView.dequeueReusableCellWithIdentifier("cell") as PickupTableViewCell
      hostCell.selectionStyle = UITableViewCellSelectionStyle.None
      hostCell.defaultCellContents(arrHost.objectAtIndex(indexPath.row)as NSDictionary)
      hostCell.selectionStyle = UITableViewCellSelectionStyle.None
      return hostCell
    }else if(btntag == 2){
      var allCell: AllTableViewCell!
      if(allCell == nil){
        allCell = pickupTableView.dequeueReusableCellWithIdentifier("allcell") as AllTableViewCell
        allCell.selectionStyle = UITableViewCellSelectionStyle.None
        var dict: NSDictionary! = dataArr.objectAtIndex(indexPath.row) as NSDictionary
        var arr: NSArray! = dict.objectForKey("array") as NSArray
        var subDict: NSDictionary! = arr.objectAtIndex(indexPath.row) as NSDictionary
        allCell.textLabel.text = subDict.objectForKey("name") as NSString
        allCell.textLabel.font = allCell.textLabel.font.fontWithSize(12)
        allCell.selectionStyle = UITableViewCellSelectionStyle.None
        return allCell
      }
    }
    return cell
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    var cellheight: CGFloat!
    if(btntag == 1){
      cellheight = 100
    }else if(btntag == 2){
      cellheight = 50
    }
    return cellheight
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    if(btntag == 1){
    var vc = self.storyboard?.instantiateViewControllerWithIdentifier("CourseDetailID") as CourseDetailViewController
    vc.callVw = "Pay"
    vc.clsDictDe = arrHost.objectAtIndex(indexPath.row) as NSDictionary
    self.navigationController?.pushViewController(vc, animated: true)
    }else if(btntag == 2){
      var dict: NSDictionary! = dataArr.objectAtIndex(indexPath.row) as NSDictionary
      var cellArr: NSArray! = dict.objectForKey("array") as NSArray
      var dictSub: NSDictionary! = cellArr.objectAtIndex(indexPath.row) as NSDictionary
      var vc = self.storyboard?.instantiateViewControllerWithIdentifier("ClassID") as ClassViewController
      vc.sub_cat_id = dictSub.objectForKey("id") as NSInteger
      vc.flgClass = "Pay"
      self.navigationController?.pushViewController(vc, animated: true)
    }
  }

  
  //************Api Calling Method***********
  
//  func getPayClassApiCall(){
//    
//      var aParams: NSDictionary = ["auth_token":auth_token[0]]
//      self.api.payClass(aParams, success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
//        println(responseObject)
//        var aParam: NSDictionary! = responseObject?.objectForKey("data") as NSDictionary
//        //self.haderArr =  aParam.objectForKey("category") as NSMutableArray
//        //self.hometableVw.reloadData()
//        
//        },
//        failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
//          println(error)
//          
//      })
//    
//  }
  
  //*************** Data feching Form DataBase **************
  
  func allDataFetchFromDataBase(){
    let arrFetchCat : NSArray = PayClsCat.MR_findAll()
    print(arrFetchCat.count)
    for var index = 0; index < arrFetchCat.count; ++index {
      //println("index is \(index)")
      let catObject : PayClsCat = arrFetchCat.objectAtIndex(index) as PayClsCat
      var str_cat_id = catObject.cat_id
      var strName = catObject.cat_name as NSString
      var dictData: NSMutableDictionary! = NSMutableDictionary()
      dictData.setObject(str_cat_id, forKey: "id")
      dictData.setObject(strName, forKey: "name")
      
      let sub_CatFilter : NSPredicate = NSPredicate(format: "sub_cat_id CONTAINS %@",str_cat_id)!
      let subcatData : NSArray = PaySubCat.MR_findAllWithPredicate(sub_CatFilter)
      
      for var index = 0; index < subcatData.count; ++index {
        let subCatObject : PaySubCat = subcatData.objectAtIndex(index) as PaySubCat
        var strID = subCatObject.sub_cat_id
        var strName = subCatObject.sub_cat_name as NSString
        var catDict2: NSMutableDictionary! = NSMutableDictionary()
        catDict2.setObject(strID, forKey: "id")
        catDict2.setObject(strName, forKey: "name")
        var subCatArr: NSMutableArray! = NSMutableArray(object: catDict2)
        dictData.setObject(subCatArr, forKey: "array")
        print(subCatArr.count)
      }
      dataArr.addObject(dictData)
      
    }
  }
  
  func hostDataFetchFromDataBase(){
    let arrFetchCat : NSArray = HostPayCls.MR_findAll()
    print(arrFetchCat.count)
    for var index = 0; index < arrFetchCat.count; ++index{
      let clsObject: HostPayCls = arrFetchCat.objectAtIndex(index) as HostPayCls
      var dictClass: NSMutableDictionary! = NSMutableDictionary()
      
      if((clsObject.cls_name) != nil){
        var strName: NSString = clsObject.cls_name
        dictClass.setValue(strName, forKey: "name")
        
      }else{
        var strName: NSString = ""
        dictClass.setValue(strName, forKey: "name")
        
      }
      if((clsObject.cls_days) != nil){
        var strDay: NSNumber = clsObject.cls_days
        dictClass.setValue(strDay, forKey: "day")
      }else {
        var strDay: NSNumber = 0
        dictClass.setValue(strDay, forKey: "day")
      }
      if((clsObject.cls_img) != nil){
        var strImgUrl: NSString = clsObject.cls_img
        dictClass.setValue(strImgUrl, forKey: "image")
      }else{
        var strImgUrl: NSString = "http://www.popular.com.my/images/no_image.gif"
        dictClass.setValue(strImgUrl, forKey: "image")
      }
      
      if((clsObject.cls_price) != nil){
        dictClass.setValue(clsObject.cls_price, forKey:"price")
      }else{
        var price: NSNumber = 0
        dictClass.setValue(price, forKey:"price")
      }
      
      if((clsObject.cls_score) != nil){
        dictClass.setValue(clsObject.cls_score, forKey:"score")
      }else{
        var score: NSNumber = 0
        dictClass.setValue(score, forKey:"score")
      }
      
      if((clsObject.cls_progress) != nil){
        dictClass.setValue(clsObject.cls_progress, forKey:"progress")
      }else{
        var progress: NSNumber = 0
        dictClass.setValue(progress, forKey:"progress")
      }
     
      if((clsObject.cls_suitable) != nil){
        dictClass.setValue(clsObject.cls_suitable, forKey:"suitable")
      }else{
        var suitable: NSString = " "
        dictClass.setValue(suitable, forKey:"suitable")
      }
      
      if((clsObject.cls_target) != nil){
        dictClass.setValue(clsObject.cls_target, forKey:"target")
      }else{
        var target: NSString = " "
        dictClass.setValue(target, forKey:"target")
      }

      if((clsObject.cls_arrange) != nil){
        dictClass.setValue(clsObject.cls_arrange, forKey:"arrange")
      }else{
        var arrange: NSString = " "
        dictClass.setValue(arrange, forKey:"arrange")
      }
      
      var clsID: NSNumber = clsObject.cls_id
      dictClass.setValue(clsID, forKey: "id")
      arrHost.addObject(dictClass)
    }
    print(arrHost.count)
    
    if(arrHost.count == 0){
      var alert: UIAlertView! = UIAlertView(title: "Alert", message: "Sorry No Class", delegate: self, cancelButtonTitle: "Ok")
      alert.show()
    }
    
  }
  
  
}