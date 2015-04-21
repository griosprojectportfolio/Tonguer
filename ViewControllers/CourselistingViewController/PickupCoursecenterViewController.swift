//
//  PickupCoursecenterViewController.swift
//  Tonguer
//
//  Created by GrepRuby on 11/04/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import UIKit

class PickupCoursecenterViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
  
  let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
  
  var flag: NSString = "PicupCourse"
  
  var barBackBtn :UIBarButtonItem!
  var barforwordBtn :UIBarButtonItem!
  
  var pickupTableView: UITableView!
  
  var btnsVw: UIView!
  
  var btnHost: UIButton!
  var btnAll: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.defaultUIDesign()
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
    
    btnsVw = UIView(frame: CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+64,self.view.frame.width, 40))
    btnsVw.layer.borderWidth = 0.5
    btnsVw.layer.borderColor = UIColor.lightGrayColor().CGColor
    self.view.addSubview(btnsVw)
    
    btnHost = UIButton(frame: CGRectMake(btnsVw.frame.origin.x,0, btnsVw.frame.width/2, 40))
    btnHost.setTitle("Host", forState: UIControlState.Normal)
    btnHost.setTitleColor(UIColor.grayColor(),forState: UIControlState.Normal)
    //btnHost.backgroundColor = UIColor.redColor()
    btnsVw.addSubview(btnHost)
    
    var horiVw: UIView! = UIView(frame: CGRectMake(btnHost.frame.origin.x,btnHost.frame.size.height,btnHost.frame.size.width,1))
    horiVw.backgroundColor = UIColor(red: 66.0/255.0, green: 150.0/255.0, blue: 173.0/255.0,alpha:1.0)
    btnsVw.addSubview(horiVw)
    
    var vertiVw: UIView! = UIView(frame: CGRectMake(btnHost.frame.width, 0,1,btnHost.frame.height))
    vertiVw.backgroundColor = UIColor.grayColor()
    btnsVw.addSubview(vertiVw)
    
    btnAll = UIButton(frame: CGRectMake(vertiVw.frame.origin.x, 0,btnHost.frame.width,40))
    btnAll.setTitle("All", forState: UIControlState.Normal)
    btnAll.setTitleColor(UIColor.grayColor(),forState: UIControlState.Normal)
    //btnHost.backgroundColor = UIColor.redColor()
    btnsVw.addSubview(btnAll)
    
    var horiVw1: UIView! = UIView(frame: CGRectMake(btnAll.frame.origin.x,btnAll.frame.size.height,btnAll.frame.size.width,1))
    horiVw1.backgroundColor = UIColor(red: 66.0/255.0, green: 150.0/255.0, blue: 173.0/255.0,alpha:1.0)
    btnsVw.addSubview(horiVw1)
    
    pickupTableView = UITableView(frame: CGRectMake(self.view.frame.origin.x,btnsVw.frame.origin.y+btnsVw.frame.size.height+5,self.view.frame.width,self.view.frame.height))
    pickupTableView.delegate = self
    pickupTableView.dataSource = self
    self.view.addSubview(pickupTableView)
    
    pickupTableView.registerClass(PickupTableViewCell.self, forCellReuseIdentifier: "cell")

  }
  
  
  func rightswipeGestureRecognizer(){
    
    UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
      self.appDelegate.objSideBar.frame = self.view.bounds
      self.appDelegate.objSideBar.sideNavigation = self.navigationController
      }, completion: nil)
    
  }

  
  func btnforwardTapped(){
    let vc = self.storyboard?.instantiateViewControllerWithIdentifier("SearchID") as SearchViewController
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell: PickupTableViewCell!
    if(cell == nil){
      cell = pickupTableView.dequeueReusableCellWithIdentifier("cell") as PickupTableViewCell
      cell.defaultCellContents()
    }
    
    return cell
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 100
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    var vc = self.storyboard?.instantiateViewControllerWithIdentifier("CourseDetailID") as CourseDetailViewController
    vc.flag = flag
    self.navigationController?.pushViewController(vc, animated: true)
  }

  
  
}
