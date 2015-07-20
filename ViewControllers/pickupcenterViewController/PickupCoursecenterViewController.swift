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
 @IBOutlet var pickupTableView: UITableView!
  var dataArr: NSMutableArray! = NSMutableArray()
  var arrHost: NSMutableArray! = NSMutableArray()
  var btnsVw: UIView!
  var dict,allCatDict,allSubCatDict: NSDictionary!
  var btnHost,btnAll: UIButton!
  var arrclasses,arrCat,arrSubCat:NSArray!
  var horiVw,horiVw1: UIView!
  var listingShow:NSString = "Host"
  var arrySearch:NSMutableArray = NSMutableArray()
  var isSearch:Bool = false
  var search:UISearchBar!
  var backbtn:UIButton!
  var lblNoData:UILabel!
  var imagViewNoData:UIImageView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    dict = NSDictionary(objects: ["ClassName","000.0","date","img2.png"], forKeys: ["class_name","priz","date","image"])
    arrclasses = NSArray(object: dict)
    allCatDict = NSDictionary(objects: ["lblCatregories"], forKeys: ["cat_id"])
    arrCat = NSArray(object: allCatDict)
    allSubCatDict = NSDictionary(objects: ["lblSubCategories"], forKeys: ["sub_id"])
    arrSubCat = NSArray(object: allSubCatDict)
    api = AppApi.sharedClient()
    self.setDataNofoundImg()
    self.hostDataFetchFromDataBase()
    self.defaultUIDesign()
    //pickupTableView.reloadData()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    getHostPayClsApiCall()
    getPayClassApiCall()
   // pickupTableView.reloadData()
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
     pickupTableView.reloadData()
    if(btntag == 1){
     setTableContentinset()
    }
    if(btntag == 1){
      if(arrHost.count == 0){
        showSetDataNofoundImg()
        reSetshowSetDataNofoundImg()
      }else{
        reSetshowSetDataNofoundImg()
      }
    }else if(btntag == 2){
      if(dataArr.count == 0){
        showSetDataNofoundImg()
      }else{
        reSetshowSetDataNofoundImg()
      }
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func defaultUIDesign(){
    
    self.title = "Pick Up Course Center"
       
    self.navigationItem.setHidesBackButton(true, animated:false)
    
    backbtn = UIButton(frame: CGRectMake(0, 0,25,25))
    backbtn.setImage(UIImage(named: "sideIcon.png"), forState: UIControlState.Normal)
    backbtn.addTarget(self, action: "rightswipeGestureRecognizer", forControlEvents: UIControlEvents.TouchUpInside)
    
    barBackBtn = UIBarButtonItem(customView: backbtn)
    self.navigationItem.setLeftBarButtonItem(barBackBtn, animated: true)

    var btnSearch:UIButton = UIButton(frame: CGRectMake(0, 0,25,25))
    btnSearch.setImage(UIImage(named: "searchicon.png"), forState: UIControlState.Normal)
    btnSearch.addTarget(self, action: "btnSearchTapped", forControlEvents: UIControlEvents.TouchUpInside)

    barforwordBtn = UIBarButtonItem(customView: btnSearch)

    self.navigationItem.setRightBarButtonItem(barforwordBtn, animated: true)
    
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
    horiVw1.backgroundColor = UIColor.grayColor()
  
    self.view.addSubview(horiVw1)
    
    pickupTableView.frame =  CGRectMake(self.view.frame.origin.x,horiVw1.frame.origin.y+horiVw1.frame.size.height+5,self.view.frame.width,self.view.frame.height-115)
    pickupTableView.delegate = self
    pickupTableView.dataSource = self
    pickupTableView.showsVerticalScrollIndicator = false
    pickupTableView.separatorStyle = UITableViewCellSeparatorStyle.None
    //pickupTableView.backgroundColor = UIColor.grayColor()
    
    search = UISearchBar(frame: CGRectMake(0, 0, 100, 30))
    search.hidden = true
    search.delegate = self
    search.showsCancelButton = true
    search.tintColor = UIColor.whiteColor()
    self.navigationItem.titleView = search
    
  }
  
  
  func rightswipeGestureRecognizer(){
    
    UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
      self.appDelegate.objSideBar.frame = self.view.bounds
      self.appDelegate.objSideBar.sideNavigation = self.navigationController
      }, completion: nil)
    
  }
  
  
  func setTableContentinset(){
    pickupTableView.contentInset = UIEdgeInsets(top:-(btnAll.frame.origin.y-30), left: 0, bottom: 0, right: 0)
  }
  
  
  func btnHostTapped(sender:AnyObject){
  self.navigationItem.rightBarButtonItem = barforwordBtn
    isSearch = false
    listingShow = "Host"
    horiVw.backgroundColor = UIColor(red: 71.0/255.0, green: 168.0/255.0, blue: 184.0/255.0,alpha:1.0)
    horiVw1.backgroundColor = UIColor.grayColor()
    var btn = sender as UIButton
    btntag = btn.tag
    print(btntag)
    setTableContentinset()
    pickupTableView.reloadData()
    print(arrHost.count)
    if(arrHost.count<=0){
      showSetDataNofoundImg()
    }else{
      reSetshowSetDataNofoundImg()
    }
  }
  
  func btnAllTapped(sender:AnyObject){
    self.navigationItem.rightBarButtonItem = nil
     isSearch = false
    listingShow = "All"
    horiVw1.backgroundColor = UIColor(red: 71.0/255.0, green: 168.0/255.0, blue: 184.0/255.0,alpha:1.0)
    horiVw.backgroundColor = UIColor.grayColor()
    var btn = sender as UIButton
    btntag = btn.tag
    print(btntag)
    pickupTableView.contentInset = UIEdgeInsets(top:0, left: 0, bottom: 0, right: 0)
    pickupTableView.reloadData()
    if(dataArr.count<=0){
      showSetDataNofoundImg()
    }else{
      reSetshowSetDataNofoundImg()
    }
  }

  
  func btnSearchTapped(){

    self.navigationItem.leftBarButtonItem = nil
    self.navigationItem.rightBarButtonItems = nil
    search.hidden = false
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    var count: NSInteger!

      if(btntag == 1){
        if(isSearch == true){
          count = arrySearch.count
        }else{
          count = arrHost.count
        }
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
      if (isSearch == false) {
        hostCell.defaultCellContents(arrHost.objectAtIndex(indexPath.row) as NSDictionary,frame: self.view.frame)
      } else {
        hostCell.defaultCellContents(arrySearch.objectAtIndex(indexPath.row) as NSDictionary,frame: self.view.frame)
      }
      hostCell.selectionStyle = UITableViewCellSelectionStyle.None
      return hostCell
    }else if(btntag == 2){
      var allCell: UITableViewCell!
      if(allCell == nil){
        allCell = pickupTableView.dequeueReusableCellWithIdentifier("allcell") as UITableViewCell
        allCell.selectionStyle = UITableViewCellSelectionStyle.None
        var dict: NSDictionary!
        if (isSearch == false) {
           dict = dataArr.objectAtIndex(indexPath.section) as NSDictionary
        } else {
          dict = arrySearch.objectAtIndex(indexPath.row) as NSDictionary
        }
        var arr: NSArray! = dict.objectForKey("array") as NSArray
         allCell.selectionStyle = UITableViewCellSelectionStyle.None
        if(arr.count>0){
          var subDict: NSDictionary! = arr.objectAtIndex(indexPath.row) as NSDictionary
          allCell.textLabel.text = subDict.objectForKey("name") as NSString
          allCell.textLabel.font = allCell.textLabel.font.fontWithSize(12)
          return allCell
        }else{
          allCell.textLabel.text = ""
          allCell.textLabel.font = allCell.textLabel.font.fontWithSize(12)
          return allCell
        }
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
      vc.isSearch = false
      if (isSearch == false) {
        vc.clsDictDe = arrHost.objectAtIndex(indexPath.row) as NSDictionary
      } else {
        println(arrySearch.objectAtIndex(indexPath.row))
        vc.clsDictDe  = arrySearch.objectAtIndex(indexPath.row)as NSDictionary
        vc.isSearch = true
      }
      self.navigationController?.pushViewController(vc, animated: true)
    }else if(btntag == 2){
      var dict: NSDictionary! = dataArr.objectAtIndex(indexPath.section) as NSDictionary
      var cellArr: NSArray! = dict.objectForKey("array") as NSArray
      var dictSub: NSDictionary!
      if (isSearch == false) {
       dictSub = cellArr.objectAtIndex(indexPath.row) as NSDictionary
      } else {
        dictSub = arrySearch.objectAtIndex(indexPath.row)as NSDictionary
      }
      var vc = self.storyboard?.instantiateViewControllerWithIdentifier("ClassID") as ClassViewController
      vc.sub_cat_id = dictSub.objectForKey("id") as NSInteger
      vc.flgClass = "Pay"
      self.navigationController?.pushViewController(vc, animated: true)
    }
  }

  
  //************Api Calling Method***********
  
  func getPayClassApiCall(){
    
    var aParams: NSDictionary = ["auth-token":auth_token[0]]
    self.api.payClass(aParams, success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
      println(responseObject)
      var aParam: NSDictionary! = responseObject?.objectForKey("data") as NSDictionary
      if aParam.isKindOfClass(NSNull){
        self.reSetshowSetDataNofoundImg()
      }
      self.allDataFetchFromDataBase()
      
      if(self.dataArr.count == 0){
        if(self.btntag == 2){
//          var alert: UIAlertView! = UIAlertView(title: "Alert", message: "Sorry no class found.", delegate: self, cancelButtonTitle: "Ok")
//          alert.show()
          //self.showSetDataNofoundImg()
        }
      }
      
      },
      failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
        println(error)
        
    })
    
  }
  
  
  func getHostPayClsApiCall(){
    
    var aParams: NSDictionary = ["auth-token":auth_token[0]]
    self.api.hostpayClass(aParams, success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
      println(responseObject)
      var aParam: NSDictionary! = responseObject?.objectForKey("data") as NSDictionary
      if(aParam.isKindOfClass(NSNull)){
        self.reSetshowSetDataNofoundImg()
      }
      self.hostDataFetchFromDataBase()
      if(self.dataArr.count == 0){
        if(self.btntag == 1){
//          var alert: UIAlertView! = UIAlertView(title: "Alert", message: "Sorry no class found.", delegate: self, cancelButtonTitle: "Ok")
//          alert.show()
         //self.showSetDataNofoundImg()
        }
      }
      
      },
      failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
        println(error)
        
    })
    
  }

  
  //*************** Data feching Form DataBase **************
  
  func allDataFetchFromDataBase(){
    dataArr.removeAllObjects()
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
      
      let sub_CatFilter : NSPredicate = NSPredicate(format:"cat_id CONTAINS %@",str_cat_id)!
      let subcatData : NSArray = PaySubCat.MR_findAllWithPredicate(sub_CatFilter)
      if (subcatData.count > 0){
        var subCatArr: NSMutableArray! = NSMutableArray()
      for var index = 0; index < subcatData.count; ++index {
        let subCatObject : PaySubCat = subcatData.objectAtIndex(index) as PaySubCat
        var strID = subCatObject.sub_cat_id
        var strName = subCatObject.sub_cat_name as NSString
        var catDict2: NSMutableDictionary! = NSMutableDictionary()
        catDict2.setObject(strID, forKey: "id")
        catDict2.setObject(strName, forKey: "name")
        subCatArr.addObject(catDict2)
        dictData.setObject(subCatArr, forKey: "array")
        print(subCatArr.count)
      }
      }else{
         dictData.setObject([], forKey: "array")
      }
      dataArr.addObject(dictData)
    }
    if(dataArr.count == 0){
      if(btntag == 2){
      showSetDataNofoundImg()
      }
    }
  }
  
  func hostDataFetchFromDataBase(){
    arrHost.removeAllObjects()
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
        dictClass.setValue(strDay, forKey: "valid_days")
      }else {
        var strDay: NSNumber = 0
        dictClass.setValue(strDay, forKey: "valid_days")
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
      if(btntag == 1){
         showSetDataNofoundImg()
      }
     
    }
  }

  func setDataNofoundImg(){
    lblNoData = UILabel(frame: CGRectMake(self.view.frame.origin.x+20,self.view.frame.origin.y+120,self.view.frame.width-40, 30))
    lblNoData.text = "Sorry no data found."
    lblNoData.textAlignment = NSTextAlignment.Center
    lblNoData.hidden = true
    self.view.addSubview(lblNoData)
    //self.view.bringSubviewToFront(lblNoData)
    imagViewNoData = UIImageView(frame: CGRectMake((self.view.frame.width-100)/2,(self.view.frame.height-100)/2,100,100))
    imagViewNoData.image = UIImage(named:"smile")
    imagViewNoData.hidden = true
    self.view.addSubview(imagViewNoData)
    //self.view.bringSubviewToFront(imagViewNoData)
  }
  
  func showSetDataNofoundImg(){
    lblNoData.hidden = false
    imagViewNoData.hidden = false
  }
  
  func reSetshowSetDataNofoundImg(){
    lblNoData.hidden = true
    imagViewNoData.hidden = true
  }

  func convertResponseIntoSectionData(arrFetchCat : NSArray){

    for var index = 0; index < arrFetchCat.count; ++index {

      let catObject : NSDictionary = arrFetchCat.objectAtIndex(index) as NSDictionary
      print(catObject)
//      var str_cat_id = catObject.objectForKey("") as NSInteger
//      var strName = catObject.objectForKey("") as NSString
      var dictData: NSMutableDictionary! = NSMutableDictionary()
//      dictData.setObject(str_cat_id, forKey: "id")
//      dictData.setObject(strName, forKey: "name")

      let subcatData : NSArray = catObject.objectForKey("") as NSArray

      for var index = 0; index < subcatData.count; ++index {
        let subCatObject : NSDictionary = subcatData.objectAtIndex(index) as NSDictionary
        var strID = subCatObject.objectForKey("") as NSInteger
        var strName = subCatObject.objectForKey("") as NSString
        var catDict2: NSMutableDictionary! = NSMutableDictionary()
        catDict2.setObject(strID, forKey: "id")
        catDict2.setObject(strName, forKey: "name")
        var subCatArr: NSMutableArray! = NSMutableArray(object: catDict2)
        dictData.setObject(subCatArr, forKey: "array")
        print(subCatArr.count)
      }
      arrySearch.addObject(dictData)
    }
  }
}

extension PickupCoursecenterViewController:UISearchBarDelegate {
  func searchBarCancelButtonClicked(searchBar: UISearchBar) {
    isSearch = false
    if(btntag == 1){
    getHostPayClsApiCall()
    }else if(btntag == 2){
    getPayClassApiCall()
    }
    searchBar.text = ""
    searchBar.hidden = true
    searchBar.resignFirstResponder()
    self.navigationItem.setRightBarButtonItem(barforwordBtn, animated: true)
    self.navigationItem.setLeftBarButtonItem(barBackBtn, animated: true)
  }

  //***********Search Api Call****************
  func searchBarSearchButtonClicked(searchBar: UISearchBar) {
    let param:NSDictionary = NSDictionary(objects: [auth_token[0],searchBar.text], forKeys: ["auth-token","cls_key_word"])
    self.api.callSearchClassApi(param, success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject?) -> Void in
      print(responseObject)
      searchBar.resignFirstResponder()
     // self.arrySearch = responseObject as NSMutableArray
      let arrySe = responseObject as? NSArray
      if(arrySe?.count == 0){
        var alert: UIAlertView = UIAlertView(title: "Alert", message: "Sorry no class found.", delegate:self, cancelButtonTitle:"OK")
        alert.show()
      }else{
        self.isSearch = true
        if (self.btntag == 2) {
          self.convertResponseIntoSectionData(responseObject as NSMutableArray)
        } else {
          self.arrySearch = responseObject as NSMutableArray
          print(self.arrySearch.count)
          self.pickupTableView.reloadData()
        }
      }
      }){ (operation: AFHTTPRequestOperation?,errro:NSError!) -> Void in
    }
  }
}
