//
//  DiscussViewController.swift
//  Tonguer
//
//  Created by GrepRuby on 27/04/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import UIKit

class DiscussViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
  
  var barBackBtn :UIBarButtonItem!
  var btnAdd :UIButton!
  var tblDiscuss: UITableView!
  var arrSecton: NSArray! = NSArray(objects: "Admin","User")
  var arrDatalist: NSMutableArray!
  var arrUserTopic:NSArray! = NSArray()
  var arrAdminTopic:NSArray! = NSArray()
   var arrTopics: NSMutableArray! = NSMutableArray()
   var classID: NSInteger!
  var arrAdmin:NSMutableArray! = NSMutableArray()
  var arrUser:NSMutableArray! = NSMutableArray()

  override func viewDidLoad() {
    super.viewDidLoad()
    
   self.defaultUIDesign()
   //self.getDataFromDatabase()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    arrTopics.removeAllObjects()
    arrUser.removeAllObjects()
    arrAdmin.removeAllObjects()
    self.dataFetchFromDatabaseDiscus()
    tblDiscuss.reloadData()
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func defaultUIDesign(){
    
    self.title = "Discuss"
    
    self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
    
    self.navigationItem.setHidesBackButton(true, animated:false)
    
    var backbtn:UIButton = UIButton(frame: CGRectMake(0, 0,25,25))
    backbtn.setImage(UIImage(named: "whiteback.png"), forState: UIControlState.Normal)
    backbtn.addTarget(self, action: "btnBackTapped", forControlEvents: UIControlEvents.TouchUpInside)
    
    barBackBtn = UIBarButtonItem(customView: backbtn)
    self.navigationItem.setLeftBarButtonItem(barBackBtn, animated: true)
    
    btnAdd = UIButton(frame: CGRectMake(0, 0, 25, 25))
    btnAdd.setImage(UIImage(named: "Add.png"), forState: UIControlState.Normal)
    btnAdd.addTarget(self, action: "btnAddtapped:", forControlEvents: UIControlEvents.TouchUpInside)
    
    var btnBarAdd: UIBarButtonItem! = UIBarButtonItem(customView: btnAdd)
    self.navigationItem.setRightBarButtonItem(btnBarAdd, animated: true)
    
    tblDiscuss = UITableView(frame: CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y, self.view.frame.width, self.view.frame.height))
    //tblDiscuss.backgroundColor = UIColor.grayColor()
    tblDiscuss.delegate = self
    tblDiscuss.dataSource = self
    tblDiscuss.separatorStyle = UITableViewCellSeparatorStyle.None
    self.view.addSubview(tblDiscuss)
    
    tblDiscuss.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    
    
  }
  
  func btnBackTapped(){
    self.navigationController?.popViewControllerAnimated(true)
  }

  func btnAddtapped(sender:AnyObject){
    let vc = self.storyboard?.instantiateViewControllerWithIdentifier("AddTopicID") as AddTopicViewController
    vc.classID = classID
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
     var dict:NSDictionary! = arrTopics.objectAtIndex(section) as NSDictionary
    var arrTopic: NSArray! = dict.valueForKey("array") as NSArray
    return arrTopic.count
  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return arrTopics.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell = tblDiscuss.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
    cell.selectionStyle = UITableViewCellSelectionStyle.None
    var dict:NSDictionary! = NSDictionary()
         dict = arrTopics.objectAtIndex(indexPath.section) as NSDictionary
    var arrTopc: NSArray! = dict.valueForKey("array") as NSArray
    var aParams:NSDictionary! = arrTopc.objectAtIndex(indexPath.row) as NSDictionary
    cell.textLabel.text = aParams.valueForKey("name") as NSString
    cell.textLabel.font = cell.textLabel.font.fontWithSize(12)
    return cell
  }
  
  func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    var dict:NSDictionary! = arrTopics.objectAtIndex(section) as NSDictionary
    return dict.valueForKey("name") as NSString
  }
  
  func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    var vWheader: UIView! = UIView(frame: CGRectMake(5, 5, 100, 40))
    vWheader.backgroundColor = UIColor(red: 71.0/255.0, green: 168.0/255.0, blue: 184.0/255.0,alpha:1.0)
    vWheader.layer.borderWidth = 0.5
    vWheader.layer.borderColor = UIColor.lightGrayColor().CGColor
    
    var lblTilte: UILabel! = UILabel(frame: CGRectMake(10, 2, 100,20))
    var dict:NSDictionary! = arrTopics.objectAtIndex(section) as NSDictionary
    lblTilte.text = dict.valueForKey("name") as NSString
    lblTilte.font = lblTilte.font.fontWithSize(12)
    lblTilte.textColor = UIColor.whiteColor()
    vWheader.addSubview(lblTilte)
    
    return vWheader

  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    var vc = self.storyboard?.instantiateViewControllerWithIdentifier("AddAnsID") as AddAnsViewController
    var dict:NSDictionary! = NSDictionary()
    dict = arrTopics.objectAtIndex(indexPath.section) as NSDictionary
    var arrTopc: NSArray! = dict.valueForKey("array") as NSArray
    var aParams:NSDictionary! = arrTopc.objectAtIndex(indexPath.row) as NSDictionary
    vc.dictTopic = aParams
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  //***********Datafetching******************
  
  func getDataFromDatabase(){
    
    for var index = 0; index < arrSecton.count; ++index{
      var dict: NSMutableDictionary! = NSMutableDictionary()
      dict.setValue(arrSecton.objectAtIndex(index) as NSString, forKey: "name")
      dict.setValue(arrDatalist.objectAtIndex(index), forKey: "array")
      arrTopics.addObject(dict)
  }
  }
  
  
  func dataFetchFromDatabaseDiscus(){
    let arrFetchAdmin: NSArray = DisAdminTopic.MR_findAll()
    let arrFetchUser: NSArray = DisUserToic.MR_findAll()
    var count: NSInteger = arrFetchAdmin.count + arrFetchUser.count
    print(count)
   
    for var index = 0; index < arrFetchAdmin.count; ++index{
      let clsObject: DisAdminTopic = arrFetchAdmin.objectAtIndex(index) as DisAdminTopic
      var dict: NSMutableDictionary! = NSMutableDictionary()
      dict.setValue(clsObject.topic_id, forKey: "id")
      dict.setValue(clsObject.topic_name, forKey: "name")
      dict.setValue(clsObject.topic_content, forKey: "content")
      arrAdmin.addObject(dict)
    }
    
    for var index = 0; index < arrFetchUser.count; ++index{
      let clsObject: DisUserToic = arrFetchUser.objectAtIndex(index) as DisUserToic
      var dict: NSMutableDictionary! = NSMutableDictionary()
      dict.setValue(clsObject.topic_id, forKey: "id")
      dict.setValue(clsObject.topic_name, forKey: "name")
      dict.setValue(clsObject.topic_content, forKey: "content")
      arrUser.addObject(dict)
    }
     arrDatalist = NSMutableArray(objects:arrAdmin,arrUser)
     print(arrDatalist)
    self.getDataFromDatabase()
  }

  
  
}
