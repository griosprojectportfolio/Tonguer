//
//  MyOrderViewController.swift
//  Tonguer
//
//  Created by GrepRuby on 07/04/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import UIKit

class MyOrderViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate{
  
  let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
  
  var myordertableview :UITableView!
  
  var barBackBtn :UIBarButtonItem!
  var barforwordBtn :UIBarButtonItem!
  var btnsVw :UIView!
  var btn1:UIButton!
  var btn2:UIButton!
  var api: AppApi!
  
  var btnTag: NSInteger = 1
  
  var HorizVw : UIView!
  var vertiVw :UIView!
  var HorizVw2 : UIView!
  var vertiVw2 :UIView!
  var HorizVw3 : UIView!
  var arryTrue: NSArray! = NSArray()
  var arryFalse: NSArray! = NSArray()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    api = AppApi.sharedClient()
    self.defaultUIDesign()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func defaultUIDesign(){
    self.title = "My Order"
    self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
    
    self.navigationItem.setHidesBackButton(true, animated:false)
    
    var backbtn:UIButton = UIButton(frame: CGRectMake(0, 0,25,25))
    backbtn.setImage(UIImage(named: "sideIcon.png"), forState: UIControlState.Normal)
    backbtn.addTarget(self, action: "rightswipeGestureRecognizer", forControlEvents: UIControlEvents.TouchUpInside)
    
    barBackBtn = UIBarButtonItem(customView: backbtn)
    
    self.navigationItem.setLeftBarButtonItem(barBackBtn, animated: true)
    
    
    btn1 = UIButton(frame: CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y+64,(self.view.frame.width)/2,40))
    //btn1.backgroundColor = UIColor.redColor()
    btn1.userInteractionEnabled = true
    btn1.setTitle("Course list order", forState: UIControlState.Normal)
    btn1.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
    btn1.tag = 1
    btn1.addTarget(self, action: "btn1Tapped:", forControlEvents: UIControlEvents.TouchUpInside)
    self.view.addSubview(btn1)
    self.view.bringSubviewToFront(btn1)
    
    HorizVw = UIView(frame: CGRectMake(btn1.frame.origin.x,btn1.frame.origin.y+btn1.frame.size.height , btn1.frame.size.width, 1))
    HorizVw.backgroundColor = UIColor(red: 66.0/255.0, green: 150.0/255.0, blue: 173.0/255.0,alpha:1.0)
    self.view.addSubview(HorizVw)
   
    vertiVw = UIView(frame: CGRectMake(btn1.frame.origin.x+btn1.frame.size.width,btn1.frame.origin.y,1, btn1.frame.height))
    vertiVw.backgroundColor = UIColor.grayColor()
    self.view.addSubview(vertiVw)
    
    btn2 = UIButton(frame: CGRectMake(vertiVw.frame.origin.x+1,btn1.frame.origin.y,btn1.frame.width, 40))
   //btn2.backgroundColor = UIColor.greenColor()
    btn2.userInteractionEnabled = true
    btn2.setTitle("Credit order", forState: UIControlState.Normal)
    btn2.tag = 2
    btn2.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
    btn2.addTarget(self, action: "btn2Tapped:", forControlEvents: UIControlEvents.TouchUpInside)
    self.view.addSubview(btn2)
    self.view.bringSubviewToFront(btn2)
    
    HorizVw2 = UIView(frame: CGRectMake(btn2.frame.origin.x,btn2.frame.origin.y+btn2.frame.size.height , btn2.frame.size.width, 1))
    HorizVw2.backgroundColor = UIColor.lightGrayColor()
   self.view.addSubview(HorizVw2)
  
    myordertableview = UITableView(frame: CGRectMake(btn1.frame.origin.x,HorizVw2.frame.origin.y+HorizVw2.frame.size.height+10,self.view.frame.width,self.view.frame.height-64-HorizVw2.frame.height-20))
    //myordertableview.backgroundColor = UIColor.grayColor()
    myordertableview.separatorStyle = UITableViewCellSeparatorStyle.None
    myordertableview.delegate = self
    myordertableview.dataSource = self
    self.view.addSubview(myordertableview)
    
     myordertableview.registerClass(CourseOrderTableViewCell.self, forCellReuseIdentifier: "courseCell")
    myordertableview.registerClass(CreditTableViewCell.self, forCellReuseIdentifier: "creditCell")

  }
  
  func btnBackTapped(){
    self.navigationController?.popViewControllerAnimated(true)
  }
  
  func rightswipeGestureRecognizer(){
    
    UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
      self.appDelegate.objSideBar.frame = self.view.bounds
      self.appDelegate.objSideBar.sideNavigation = self.navigationController
      }, completion: nil)
    
  }
  
  
  func btn1Tapped(sender:AnyObject){
    var btn = sender as UIButton
    btnTag = btn.tag
    HorizVw.backgroundColor = UIColor(red: 66.0/255.0, green: 150.0/255.0, blue: 173.0/255.0,alpha:1.0)
    HorizVw2.backgroundColor = UIColor.lightGrayColor()
    myordertableview.reloadData()
  }
  
  func btn2Tapped(sender:AnyObject){
    var btn = sender as UIButton
    btnTag = btn.tag
    HorizVw2.backgroundColor = UIColor(red: 66.0/255.0, green: 150.0/255.0, blue: 173.0/255.0,alpha:1.0)
    HorizVw.backgroundColor = UIColor.lightGrayColor()
     myordertableview.reloadData()
  }
  
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    var count: NSInteger!
    if(btnTag == 1){
      count = arryFalse.count
    }else if(btnTag == 2){
      count = arryTrue.count
    }
    return 3 //count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    var cell:UITableViewCell!
    
    if(btnTag == 1){
      var cell:CourseOrderTableViewCell!
      var dict: NSDictionary! = NSDictionary()
      cell = myordertableview.dequeueReusableCellWithIdentifier("courseCell") as CourseOrderTableViewCell
      cell.defaultCellContents(arryFalse.objectAtIndex(indexPath.row) as UserClassOrder, frame: self.view.frame)
      return cell
      }else if(btnTag == 2){
      var cell:CreditTableViewCell!
      var dict: NSDictionary! = NSDictionary()
      cell = myordertableview.dequeueReusableCellWithIdentifier("creditCell") as CreditTableViewCell
      cell.defaultCellContents(arryFalse.objectAtIndex(indexPath.row) as UserClassOrder, frame: self.view.frame)
      return cell
    }
    
    return cell
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 100
  }
  
  //**************** User Classes Orders Api Call **************
  
  func userClassOrdersApiCall(){
    var aParam: NSDictionary = NSDictionary(objects: [auth_token[0]], forKeys: ["auth_token"])
    
    self.api.userClassOrders(aParam, success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
      println(responseObject)
      self.dataFetchFromDatabase(responseObject as NSDictionary)
      
      },
      failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
        println(error)
    })
    
  }

  func dataFetchFromDatabase(dicrOrders:NSDictionary){
    
    arryTrue = dicrOrders.objectForKey("True") as NSArray
    arryFalse = dicrOrders.objectForKey("False") as NSArray
  }
  
  
}
