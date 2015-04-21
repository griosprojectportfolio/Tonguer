//
//  VideoViewControler.swift
//  Tonguer
//
//  Created by GrepRuby on 20/04/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import UIKit

class VideoViewControler: UIViewController,UITableViewDataSource,UITableViewDelegate {
  
  var barBackBtn :UIBarButtonItem!
  var barforwordBtn :UIBarButtonItem!
  var tableview: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.defaultUIDesign()
  }
  
  func defaultUIDesign(){
    self.title = "Videos"
    self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
    
    self.navigationItem.setHidesBackButton(true, animated:false)
    
    var backbtn:UIButton = UIButton(frame: CGRectMake(0, 0,25,25))
    backbtn.setImage(UIImage(named: "back.png"), forState: UIControlState.Normal)
    backbtn.addTarget(self, action: "btnBackTapped", forControlEvents: UIControlEvents.TouchUpInside)
    
    barBackBtn = UIBarButtonItem(customView: backbtn)
    
    self.navigationItem.setLeftBarButtonItem(barBackBtn, animated: true)
    
    tableview = UITableView(frame: CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y, self.view.frame.width,self.view.frame.height))
    tableview.delegate = self
    tableview.dataSource = self
    self.view.addSubview(tableview)
    
    tableview.registerClass(VideoTableViewCell.self, forCellReuseIdentifier: "cell")
    
  }
  func btnBackTapped(){
    self.navigationController?.popViewControllerAnimated(true)
  }
  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 5
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 200
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell = tableview.dequeueReusableCellWithIdentifier("cell") as VideoTableViewCell
    cell.defaultUIDesign()
    
    return cell
  }
  
  
  
}
