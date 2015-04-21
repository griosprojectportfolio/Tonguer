//
//  ClassCenterViewController.swift
//  Tonguer
//
//  Created by GrepRuby on 08/04/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import UIKit

class ClassCenterViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{
  
  var flag: Bool!
  
  var barBackBtn :UIBarButtonItem!
  var barforwordBtn :UIBarButtonItem!
  var vWContent :UIView!
  var lbldeatil :UILabel!
  var imgVw :UIImageView!
  var tableview: UITableView!
  
  var img1TapGest: UITapGestureRecognizer!
  var img2TapGest: UITapGestureRecognizer!

  var haderArr: NSArray! = NSArray(objects: "LblTile1","LblTile2","LblTile3")
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.defaultUIDesign()
  }
  
  func defaultUIDesign(){
    
    self.title = "Try Class Center"
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
    self.view.addSubview(tableview)
   tableview.registerClass(CalssCenterCell.self, forCellReuseIdentifier: "cell")
    
    img1TapGest = UITapGestureRecognizer(target: self, action: "img1TapGestureSelecter")
    img2TapGest = UITapGestureRecognizer(target: self, action: "img2TapGestureSelecter")
  }
  
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 3
  }
  
  func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    var vWheader: UIView! = UIView(frame: CGRectMake(5, 5, 100, 40))
    vWheader.backgroundColor = UIColor.whiteColor()
    vWheader.layer.borderWidth = 0.5
    vWheader.layer.borderColor = UIColor.lightGrayColor().CGColor
    
    var lbltilte: UILabel! = UILabel(frame: CGRectMake(10, 2, 100,20))
    lbltilte.text = haderArr.objectAtIndex(section) as NSString
    lbltilte.font = lbltilte.font.fontWithSize(12)
    lbltilte.textColor = UIColor.blackColor()
    vWheader.addSubview(lbltilte)
    
    var btnmore: UIButton! = UIButton(frame: CGRectMake(tableview.frame.width-80, 5, 60, 20))
    btnmore.setTitle("more", forState: UIControlState.Normal)
    btnmore.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
    btnmore.titleLabel?.font = btnmore.titleLabel?.font.fontWithSize(12)
    //btnmore.backgroundColor = UIColor.blueColor()
    btnmore.addTarget(self, action: "", forControlEvents:UIControlEvents.TouchUpInside)
    vWheader.addSubview(btnmore)
    return vWheader
  }
  
  func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return "Host"
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell = tableview.dequeueReusableCellWithIdentifier("cell") as CalssCenterCell
   cell.defaultCellContent()
   cell.imgVw1.addGestureRecognizer(img1TapGest)
   cell.imgVw2.addGestureRecognizer(img2TapGest)
    
    return cell
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 100
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func btnBackTapped(){
    self.navigationController?.popViewControllerAnimated(true)
  }
  
  func img1TapGestureSelecter(){
    var vc = self.storyboard?.instantiateViewControllerWithIdentifier("CourseDetailID") as CourseDetailViewController
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  func img2TapGestureSelecter(){
    var vc = self.storyboard?.instantiateViewControllerWithIdentifier("CourseDetailID") as CourseDetailViewController
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  func btnMoreTapped(){
    
  }

  
}
