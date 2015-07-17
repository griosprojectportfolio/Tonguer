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
  var lbldeatil :UILabel!
  var imgVw :UIImageView!
  var tableview: UITableView!
  var api: AppApi!
    var scrollAdvertise:UIScrollView = UIScrollView()
  var haderArr: NSMutableArray! = NSMutableArray()
  var subCatArr: NSMutableArray! = NSMutableArray()
  var dataArr: NSMutableArray! = NSMutableArray()
  var dictParam: NSMutableDictionary!
  override func viewDidLoad() {
    super.viewDidLoad()
    api = AppApi.sharedClient()
    
    self.dataFetchFromDataBase()
    self.defaultUIDesign()
    //self.tableview.reloadData()
    
    var arry = Addvertiesment.MR_findAll()
    if(arry.count>0){
     advertiesmentFetchFromDataBase(arry)
    }else{
      imgVw.image = UIImage(named:"defaultImg.png")
      lbldeatil.text = ""
    }
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.navigationBar.translucent = false

    getAddvertiesmentApiCall()
      getFreeClassApiCall()
  }
  
  func defaultUIDesign(){
    
    self.title = "Try Class Centre"
    
    self.navigationItem.setHidesBackButton(true, animated:false)
    
    var backbtn:UIButton = UIButton(frame: CGRectMake(0, 0,25,25))
    backbtn.setImage(UIImage(named: "whiteback.png"), forState: UIControlState.Normal)
    backbtn.addTarget(self, action: "btnBackTapped", forControlEvents: UIControlEvents.TouchUpInside)
    
    barBackBtn = UIBarButtonItem(customView: backbtn)
    
    self.navigationItem.setLeftBarButtonItem(barBackBtn, animated: true)

    scrollAdvertise.frame = CGRectMake(self.view.frame.origin.x+10, self.view.frame.origin.y, self.view.frame.size.width-20,180)
    scrollAdvertise.layer.borderWidth = 0.5
    scrollAdvertise.showsVerticalScrollIndicator = false
    scrollAdvertise.layer.borderColor = UIColor.lightGrayColor().CGColor
    self.view.addSubview(scrollAdvertise)

    imgVw = UIImageView(frame: CGRectMake(0, 5 ,scrollAdvertise.frame.size.width,150))
    scrollAdvertise.addSubview(imgVw)

    var lblLine:UILabel = UILabel(frame: CGRectMake(imgVw.frame.origin.x,imgVw.frame.origin.y+imgVw.frame.size.height+3, scrollAdvertise.frame.size.width, 0.7))
    lblLine.backgroundColor = UIColor.darkGrayColor()
    scrollAdvertise.addSubview(lblLine)

    lbldeatil = UILabel(frame: CGRectMake(imgVw.frame.origin.x+2,imgVw.frame.origin.y+imgVw.frame.size.height+5, imgVw.frame.size.width-4,21))
    lbldeatil.numberOfLines = 0
    lbldeatil.font = lbldeatil.font.fontWithSize(12)
    lbldeatil.textColor = UIColor.blackColor()
    scrollAdvertise.addSubview(lbldeatil)
   
    tableview = UITableView(frame: CGRectMake(scrollAdvertise.frame.origin.x,scrollAdvertise.frame.origin.y+scrollAdvertise.frame.height, scrollAdvertise.frame.width, self.view.frame.height-scrollAdvertise.frame.origin.y))
    //tableview.backgroundColor = UIColor.grayColor()
    tableview.delegate = self
    tableview.dataSource = self
    self.view.addSubview(tableview)
   tableview.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
   tableview.tableFooterView = UIView(frame: CGRectZero)
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
    
    return vWheader
  }
  
  func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    var dict:NSDictionary! = dataArr.objectAtIndex(section) as NSDictionary
    return dict.valueForKey("name") as NSString
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell = tableview.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
     cell.selectionStyle = UITableViewCellSelectionStyle.None
    var dict: NSDictionary! = dataArr.objectAtIndex(indexPath.section) as NSDictionary
    var cellArr: NSArray! = dict.objectForKey("array") as NSArray
    if(cellArr.count>0){
      var dictSub: NSDictionary! = cellArr.objectAtIndex(indexPath.row) as NSDictionary
      cell.textLabel.text = dictSub.valueForKey("name") as NSString
      cell.textLabel.font = cell.textLabel.font.fontWithSize(12)
      return cell

    }else{
      cell.textLabel.text = ""
      return cell
    }
    
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 50
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
    var dict: NSDictionary! = dataArr.objectAtIndex(indexPath.section) as NSDictionary
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
    
    var aParams: NSDictionary = ["auth-token":auth_token[0]] //NSDictionary(objects: [auth_token], forKeys: ["auth_token"])
    
    self.api.addvertiesment(aParams, success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
      println(responseObject)
      let arry = responseObject as NSArray
      self.advertiesmentFetchFromDataBase(arry)
      
      },
      failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
        println(error)
        
    })
    
  }
  
  
  func getFreeClassApiCall(){
    
    var aParams: NSDictionary = ["auth-token":auth_token[0]]
    self.api.freeClass(aParams, success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
      println(responseObject)
      var aParam: NSDictionary! = responseObject?.objectForKey("data") as NSDictionary
      self.dataFetchFromDataBase()
      self.tableview.reloadData()
      },
      failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
        println(error)
    })
    
  }
  
  //*************** Advertiesment Data feching Form DataBase **************
  
  func advertiesmentFetchFromDataBase(arryAdd:NSArray){
    
    let obj = arryAdd.objectAtIndex(0) as Addvertiesment
    
    if((obj.add_name) != nil){
      lbldeatil.text = obj.add_name
    }else{
      lbldeatil.text = ""
    }
    var strDetail:NSString = lbldeatil.text!

    var rect:CGRect! = strDetail.boundingRectWithSize(CGSize(width:lbldeatil.frame.size.width ,height:300), options:NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName:lbldeatil.font], context: nil)

    lbldeatil.frame = CGRectMake(lbldeatil.frame.origin.x,lbldeatil.frame.origin.y,lbldeatil.frame.size.width, rect.size.height)
    scrollAdvertise.contentSize = CGSizeMake(scrollAdvertise.frame.size.width, imgVw.frame.size.height+lbldeatil.frame.size.height+15)
    
    if((obj.add_img) != nil){
      let url: NSURL = NSURL(string: obj.add_img as NSString)!
      imgVw.sd_setImageWithURL(url, placeholderImage:UIImage(named:"defaultImg.png"))
    }else{
      let url: NSURL = NSURL(string:"http://www.popular.com.my/images/no_image.gif")!
      imgVw.sd_setImageWithURL(url)
    }
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
      
      let sub_CatFilter : NSPredicate = NSPredicate(format: "cat_id CONTAINS %@",str_cat_id)!
      let subcatData : NSArray = FreeSubCat.MR_findAllWithPredicate(sub_CatFilter)
      print(subcatData.count)
      if (subcatData.count > 0){
        var subCatArr: NSMutableArray! = NSMutableArray()
      for var index = 0; index < subcatData.count; ++index {
        let subCatObject : FreeSubCat = subcatData.objectAtIndex(index) as FreeSubCat
        var catDict2: NSMutableDictionary! = NSMutableDictionary()
        if((subCatObject.sub_cat_id) != nil){
           var strID = subCatObject.sub_cat_id
           catDict2.setObject(strID, forKey: "id")
        }else{
           var strID = 0
           catDict2.setObject(strID, forKey: "id")
        }
        if((subCatObject.sub_cat_name) != nil){
         var strName = subCatObject.sub_cat_name as NSString
          catDict2.setObject(strName, forKey: "name")
        }else{
          var strName = ""
          catDict2.setObject(strName, forKey: "name")
        }
         subCatArr.addObject(catDict2)
        dictData.setObject(subCatArr, forKey: "array")
        print(subCatArr.count)
      }
      }else{
        dictData.setObject([], forKey: "array")
      }
      dataArr.addObject(dictData)

    }
  }
  
  
}
