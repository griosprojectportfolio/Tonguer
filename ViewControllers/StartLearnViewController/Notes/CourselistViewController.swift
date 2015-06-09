//
//  CourselistViewController.swift
//  Tonguer
//
//  Created by GrepRuby on 29/04/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import UIKit

protocol CourselistViewControllerDelegates {

 // func CourselistViewControllerDelegatesGetDictionary(dictionaty:NSDictionary)
}

class CourselistViewController: UIViewController, UITableViewDataSource,UITableViewDelegate{

   var barBackBtn :UIBarButtonItem!
   var tblVwCourse: UITableView!
   var arrclass: NSMutableArray! = NSMutableArray()
    var delegate: CourselistViewControllerDelegates?
  
  override func viewDidLoad() {
    super.viewDidLoad()
  fetchDataFromDBforDefaultCls()
   defaultUIDesign()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func defaultUIDesign(){
    
    self.navigationItem.setHidesBackButton(true, animated:false)
    
    var backbtn:UIButton = UIButton(frame: CGRectMake(0, 0,25,25))
    backbtn.setImage(UIImage(named: "whiteback.png"), forState: UIControlState.Normal)
    backbtn.addTarget(self, action: "btnBackTapped", forControlEvents: UIControlEvents.TouchUpInside)
    
    barBackBtn = UIBarButtonItem(customView: backbtn)
    self.navigationItem.setLeftBarButtonItem(barBackBtn, animated: true)
    
    tblVwCourse = UITableView(frame: CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y, self.view.frame.width, self.view.frame.height))
    //tblVwCourse.backgroundColor = UIColor.grayColor()
    tblVwCourse.separatorColor = UIColor(red: 71.0/255.0, green: 168.0/255.0, blue: 184.0/255.0,alpha:1.0)
    tblVwCourse.delegate = self
    tblVwCourse.dataSource = self
    self.view.addSubview(tblVwCourse)
    
    tblVwCourse.registerClass(CourselistTableViewCell.self, forCellReuseIdentifier: "cell")
  }
  
  func btnBackTapped(){
    self.navigationController?.popViewControllerAnimated(true)
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return arrclass.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell = tblVwCourse.dequeueReusableCellWithIdentifier("cell") as CourselistTableViewCell
    var dict: NSDictionary! = arrclass.objectAtIndex(indexPath.row) as NSDictionary
    cell.textLabel.text = dict.valueForKey("name") as NSString
    cell.textLabel.textColor = UIColor.grayColor()
    cell.textLabel.font = cell.textLabel.font.fontWithSize(15)
    
    return cell
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 50
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    var clsUserDefault: NSUserDefaults! = NSUserDefaults.standardUserDefaults()
//    var dict: NSDictionary! = arrclass.objectAtIndex(indexPath.row) as NSDictionary
//    clsUserDefault.setObject(dict, forKey: "class")
//    clsUserDefault.synchronize()
    self.navigationController?.popViewControllerAnimated(true)
  }
  
  
  //****** User Data fetch from database for user default class ************
  
  func fetchDataFromDBforDefaultCls(){
    let arrFetchedData : NSArray = UserDefaultClsList.MR_findAll()
    
    for var index = 0; index < arrFetchedData.count; ++index {
      let userClsObj : UserDefaultClsList = arrFetchedData.objectAtIndex(index) as UserDefaultClsList
      var dict: NSMutableDictionary! = NSMutableDictionary()
      
      dict.setObject(userClsObj.cls_id, forKey: "id")
      
      if((userClsObj.cls_name) != nil){
        dict.setObject(userClsObj.cls_name, forKey:"name")
      }else{
        dict.setObject("No Class Name", forKey:"name")
      }
      
      if((userClsObj.cls_img_url) != nil){
        var str_url: NSString = userClsObj.cls_img_url
        dict.setObject(str_url, forKey:"image")
        
      }else{
        var str_url: NSString = "http://www.popular.com.my/images/no_image.gif"
        dict.setObject(str_url, forKey:"image")
      }
      
      if((userClsObj.cls_vaild_days) != nil){
        dict.setObject(userClsObj.cls_vaild_days,forKey:"days")
        
      }else{
        dict.setObject("No Day",forKey:"days")
      }
      
      if((userClsObj.cls_score) != nil){
        dict.setObject(userClsObj.cls_score, forKey: "score")
        
      }else{
        dict.setObject("0.0", forKey: "score")
      }
      
      if((userClsObj.cls_price) != nil){
        dict.setObject(userClsObj.cls_price, forKey: "price")
        
      }else{
        dict.setObject("0.0", forKey: "price")
      }
      
      if((userClsObj.cls_progress) != nil){
        dict.setObject(userClsObj.cls_progress, forKey:"progress")
        
      }else{
        dict.setObject("0", forKey:"progress")
      }
      arrclass.addObject(dict)
    }
    
    print(arrclass.count)
    
  }

  func vv () {
    //delegate?.CourselistViewControllerDelegatesGetDictionary()
  }
  
  
}
