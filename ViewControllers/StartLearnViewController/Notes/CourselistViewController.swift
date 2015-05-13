//
//  CourselistViewController.swift
//  Tonguer
//
//  Created by GrepRuby on 29/04/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import UIKit

class CourselistViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

   var barBackBtn :UIBarButtonItem!
   var tblVwCourse: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
   self.defaultUIDesign()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func defaultUIDesign(){
    self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
    
    self.navigationItem.setHidesBackButton(true, animated:false)
    
    var backbtn:UIButton = UIButton(frame: CGRectMake(0, 0,25,25))
    backbtn.setImage(UIImage(named: "whiteback.png"), forState: UIControlState.Normal)
    backbtn.addTarget(self, action: "btnBackTapped", forControlEvents: UIControlEvents.TouchUpInside)
    
    barBackBtn = UIBarButtonItem(customView: backbtn)
    self.navigationItem.setLeftBarButtonItem(barBackBtn, animated: true)
    
    tblVwCourse = UITableView(frame: CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y, self.view.frame.width, self.view.frame.height))
    tblVwCourse.backgroundColor = UIColor.grayColor()
    tblVwCourse.delegate = self
    tblVwCourse.dataSource = self
    self.view.addSubview(tblVwCourse)
    
    tblVwCourse.registerClass(CourselistTableViewCell.self, forCellReuseIdentifier: "cell")
  }
  
  func btnBackTapped(){
    self.navigationController?.popViewControllerAnimated(true)
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell = tblVwCourse.dequeueReusableCellWithIdentifier("cell") as CourselistTableViewCell
    cell.textLabel.text = "Hola"
    cell.textLabel.font = cell.textLabel.font.fontWithSize(15)
    
    return cell
  }
  
  
}
