//
//  ClassCenterViewController.swift
//  Tonguer
//
//  Created by GrepRuby on 08/04/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import UIKit

class ClassCenterViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate{
  
  
  var barBackBtn :UIBarButtonItem!
  var barforwordBtn :UIBarButtonItem!
  var vWContent :UIView!
  var lbldeatil :UILabel!
  var imgVw :UIImageView!
  var tableview: UITableView!
  var api: AppApi!
  var haderArr: NSMutableArray! = NSMutableArray()
  var subCatArr: NSMutableArray! = NSMutableArray()
  var dataArr: NSMutableArray! = NSMutableArray()
  var dictParam: NSMutableDictionary!
  override func viewDidLoad() {
    super.viewDidLoad()
    api = AppApi.sharedClient()
    self.defaultUIDesign()
    //self.getFreeClassApiCall()
    self.dataFetchFromDataBase()
    //self.getAddvertiesmentApiCall()
    
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    getFreeClassApiCall()
  }
  
  func defaultUIDesign(){
    
    self.title = "Try Class Centre"
    self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
    
    self.navigationItem.setHidesBackButton(true, animated:false)
    
    var backbtn:UIButton = UIButton(frame: CGRectMake(0, 0,25,25))
    backbtn.setImage(UIImage(named: "whiteback.png"), forState: UIControlState.Normal)
    backbtn.addTarget(self, action: "btnBackTapped", forControlEvents: UIControlEvents.TouchUpInside)
    
    barBackBtn = UIBarButtonItem(customView: backbtn)
    
    self.navigationItem.setLeftBarButtonItem(barBackBtn, animated: true)
    
    imgVw = UIImageView(frame: CGRectMake(self.view.frame.origin.x+10, self.view.frame.origin.y+84,self.view.frame.size.width-20,150))
    imgVw.image = UIImage(named: "img2.png")
    imgVw.layer.borderWidth = 0.5
    imgVw.layer.borderColor = UIColor.lightGrayColor().CGColor
    self.view.addSubview(imgVw)
    
    vWContent = UIView(frame: CGRectMake(imgVw.frame.origin.x, imgVw.frame.origin.y+imgVw.frame.size.height, imgVw.frame.size.width, 50))
    vWContent.layer.borderWidth = 0.5
    vWContent.layer.borderColor = UIColor.lightGrayColor().CGColor
    self.view.addSubview(vWContent)
    
    lbldeatil = UILabel(frame: CGRectMake(vWContent.frame.origin.x+5,0, vWContent.frame.size.width-10,vWContent.frame.size.height-10))
    lbldeatil.text = "This is a preliminary document for an API or technology in development. Apple is supplying this."
    lbldeatil.numberOfLines = 0
    lbldeatil.font = lbldeatil.font.fontWithSize(12)
    //lblDeatil.backgroundColor = UIColor.yellowColor()
    lbldeatil.textColor = UIColor.blackColor()
    vWContent.addSubview(lbldeatil)
   
    tableview = UITableView(frame: CGRectMake(vWContent.frame.origin.x,vWContent.frame.origin.y+vWContent.frame.height, vWContent.frame.width, self.view.frame.height/1.8))
    //tableview.backgroundColor = UIColor.grayColor()
    tableview.delegate = self
    tableview.dataSource = self
    tableview.separatorStyle = UITableViewCellSeparatorStyle.None
    self.view.addSubview(tableview)
   tableview.registerClass(CalssCenterCell.self, forCellReuseIdentifier: "cell")
    
  }
  
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    var dict: NSDictionary! = dataArr.objectAtIndex(section) as NSDictionary
    var cellArr: NSArray! = dict.objectForKey("array") as NSArray
    return cellArr.count//subCatArr.count
  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return dataArr.count
  }
  
  func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    var vWheader: UIView! = UIView(frame: CGRectMake(5, 5, 100, 40))
    vWheader.backgroundColor = UIColor(red: 71.0/255.0, green: 168.0/255.0, blue: 184.0/255.0,alpha:1.0)
    vWheader.layer.borderWidth = 0.5
    vWheader.layer.borderColor = UIColor.lightGrayColor().CGColor
    var dict:NSDictionary! = dataArr.objectAtIndex(section) as NSDictionary
    var lblTilte: UILabel! = UILabel(frame: CGRectMake(10, 2, 100,20))
    lblTilte.text = dict.valueForKey("name") as NSString
    lblTilte.font = lblTilte.font.fontWithSize(12)
    lblTilte.textColor = UIColor.whiteColor()
    vWheader.addSubview(lblTilte)
    
    var btnMore: UIButton! = UIButton(frame: CGRectMake(tableview.frame.width-80, 5, 60, 20))
    btnMore.setTitle("more", forState: UIControlState.Normal)
    btnMore.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
    btnMore.titleLabel?.font = btnMore.titleLabel?.font.fontWithSize(12)
    btnMore.tag = section
    //btnmore.backgroundColor = UIColor.blueColor()
    btnMore.addTarget(self, action: "btnMoreTapped:", forControlEvents:UIControlEvents.TouchUpInside)
    //vWheader.addSubview(btnMore)
    return vWheader
  }
  
  func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    var dict:NSDictionary! = dataArr.objectAtIndex(section) as NSDictionary
    return dict.valueForKey("name") as NSString
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell = tableview.dequeueReusableCellWithIdentifier("cell") as CalssCenterCell
     cell.selectionStyle = UITableViewCellSelectionStyle.None
    var dict: NSDictionary! = dataArr.objectAtIndex(indexPath.row) as NSDictionary
    var cellArr: NSArray! = dict.objectForKey("array") as NSArray
    var dictSub: NSDictionary! = cellArr.objectAtIndex(indexPath.row) as NSDictionary
     cell.textLabel.text = dictSub.valueForKey("name") as NSString
     cell.textLabel.font = cell.textLabel.font.fontWithSize(12)
    return cell
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 50
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
    var dict: NSDictionary! = dataArr.objectAtIndex(indexPath.row) as NSDictionary
    var cellArr: NSArray! = dict.objectForKey("array") as NSArray
    var dictSub: NSDictionary! = cellArr.objectAtIndex(indexPath.row) as NSDictionary
    var vc = self.storyboard?.instantiateViewControllerWithIdentifier("ClassID") as ClassViewController
    vc.sub_cat_id = dictSub.objectForKey("id") as NSInteger
    vc.flgClass = "Free"
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func btnBackTapped(){
    self.navigationController?.popViewControllerAnimated(true)
  }
  
  
  //*************** Call Free Class Api**************
  
  func getAddvertiesmentApiCall(){
    
    var aParams: NSDictionary = ["auth_token":auth_token[0]] //NSDictionary(objects: [auth_token], forKeys: ["auth_token"])
    
    self.api.addvertiesment(aParams, success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
      println(responseObject)
      var aParam: NSDictionary! = responseObject?.objectForKey("advertiesment") as NSDictionary
      
      
      },
      failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
        println(error)
        
    })
    
  }
  
  
  func getFreeClassApiCall(){
    
    var aParams: NSDictionary = ["auth_token":auth_token[0]]
    self.api.freeClass(aParams, success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
      println(responseObject)
      var aParam: NSDictionary! = responseObject?.objectForKey("data") as NSDictionary
      //self.haderArr =  aParam.objectForKey("category") as NSMutableArray
      //self.hometableVw.reloadData()
      self.dataFetchFromDataBase()
      },
      failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
        println(error)
    })
    
  }

  
  //*************** Data feching Form DataBase **************
  
  func dataFetchFromDataBase(){
    dataArr.removeAllObjects()
    let arrFetchCat : NSArray = FreeClsCat.MR_findAll()
    print(arrFetchCat.count)
    for var index = 0; index < arrFetchCat.count; ++index {
      //println("index is \(index)")
      let catObject : FreeClsCat = arrFetchCat.objectAtIndex(index) as FreeClsCat
      var str_cat_id = catObject.cat_id
      var strName = catObject.cat_name as NSString
       var dictData: NSMutableDictionary! = NSMutableDictionary()
      dictData.setObject(str_cat_id, forKey: "id")
      dictData.setObject(strName, forKey: "name")
      
      let sub_CatFilter : NSPredicate = NSPredicate(format: "sub_cat_id CONTAINS %@",str_cat_id)!
      let subcatData : NSArray = FreeSubCat.MR_findAllWithPredicate(sub_CatFilter)
      
      for var index = 0; index < subcatData.count; ++index {
        let subCatObject : FreeSubCat = subcatData.objectAtIndex(index) as FreeSubCat
        var strID = subCatObject.sub_cat_id
        var strName = subCatObject.sub_cat_name as NSString
        var catDict2: NSMutableDictionary! = NSMutableDictionary()
        catDict2.setObject(strID, forKey: "id")
        catDict2.setObject(strName, forKey: "name")
        //subCatArr.addObject(catDict2)
        var subCatArr: NSMutableArray! = NSMutableArray(object: catDict2)
        dictData.setObject(subCatArr, forKey: "array")
        print(subCatArr.count)
      }
      dataArr.addObject(dictData)
      tableview.reloadData()
    }
    
  }
  
  
}
