//
//  SettingViewController.swift
//  Tonguer
//
//  Created by GrepRuby on 15/04/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
  
  var barBackBtn :UIBarButtonItem!
  var tableview: UITableView!
  var VwUserDetail: UIView!
  var imgVwPPic: UIImageView!
  var lblname: UILabel!
  var btnLogout: UIButton!
  
  var userDict: NSDictionary!
  var arrsettdata: NSArray!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    userDict = NSDictionary(objects: ["img2","Test User"], forKeys: ["image","name"])
    
    arrsettdata = NSArray(objects:"Alreday down","Option for video","Download reminder","Feedback","Recommand to friend","About us")
    
    self.defaultUIDesign()
    
  }
  
  func defaultUIDesign(){
    
    self.title = "Setting"
    self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
    
    self.navigationItem.setHidesBackButton(true, animated:false)
    
    var backbtn:UIButton = UIButton(frame: CGRectMake(0, 0,25,25))
    backbtn.setImage(UIImage(named: "whiteback.png"), forState: UIControlState.Normal)
    backbtn.addTarget(self, action: "btnBackTapped", forControlEvents: UIControlEvents.TouchUpInside)
    
    barBackBtn = UIBarButtonItem(customView: backbtn)
    
    self.navigationItem.setLeftBarButtonItem(barBackBtn, animated: true)
    
    VwUserDetail = UIView(frame: CGRectMake(self.view.frame.origin.x+20, self.view.frame.origin.y+74, self.view.frame.width-50, 60))
    VwUserDetail.layer.borderWidth = 0.5
    VwUserDetail.layer.borderColor = UIColor.lightGrayColor().CGColor
    self.view.addSubview(VwUserDetail)
    
    imgVwPPic = UIImageView(frame: CGRectMake(5,5,50,50))
    imgVwPPic.image = UIImage(named: userDict.objectForKey("image")as NSString)
    VwUserDetail.addSubview(imgVwPPic)
    
    lblname = UILabel(frame: CGRectMake(imgVwPPic.frame.origin.x + imgVwPPic.frame.width+2,10,VwUserDetail.frame.width-120,40))
    //lblname.backgroundColor = UIColor.grayColor()
    lblname.text = userDict.objectForKey("name") as NSString
    lblname.font = lblname.font.fontWithSize(15)
    VwUserDetail.addSubview(lblname)
    
    btnLogout = UIButton(frame: CGRectMake(lblname.frame.origin.x+lblname.frame.width+1, 0,VwUserDetail.frame.width-(lblname.frame.origin.x+lblname.frame.width),VwUserDetail.frame.height))
    btnLogout.setTitle("Logout", forState: UIControlState.Normal)
    btnLogout.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
    btnLogout.titleLabel?.font = btnLogout.titleLabel?.font.fontWithSize(12)
    btnLogout.addTarget(self, action:"btnLogoutTapped", forControlEvents: UIControlEvents.TouchUpInside)
    //btnLogout.backgroundColor = UIColor.blackColor()
    VwUserDetail.addSubview(btnLogout)
    
    tableview = UITableView(frame: CGRectMake(self.view.frame.origin.x,VwUserDetail.frame.origin.y+VwUserDetail.frame.height, self.view.frame.width, self.view.frame.height - (VwUserDetail.frame.origin.y+VwUserDetail.frame.height+10)))
    //tableview.backgroundColor = UIColor.grayColor()
    tableview.delegate = self
    tableview.dataSource = self
    self.view.addSubview(tableview)
    tableview.registerClass(SettingTableViewCell.self, forCellReuseIdentifier: "cell")
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return arrsettdata.count
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 80
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell = tableview.dequeueReusableCellWithIdentifier("cell") as SettingTableViewCell
    cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
    cell.selectionStyle = UITableViewCellSelectionStyle.None
    cell.defaultUICellContent(arrsettdata.objectAtIndex(indexPath.row) as NSString, index: indexPath.row)
    return cell
  }
  
  func btnBackTapped(){
    self.navigationController?.popViewControllerAnimated(true)
  }
  
  func btnLogoutTapped(){
    
  }
  
   
}
