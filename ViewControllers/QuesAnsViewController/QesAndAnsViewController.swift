//
//  QesAndAnsViewController.swift
//  Tonguer
//
//  Created by GrepRuby on 20/04/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import UIKit

class QesAndAnsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
  
  var barBackBtn :UIBarButtonItem!
  var tableview: UITableView!
  var btnAddQues: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.defaultUIDesign()
  }
  
  func defaultUIDesign(){
    self.title = "Question and Answer"
    self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
    
    self.navigationItem.setHidesBackButton(true, animated:false)
    
    var backbtn:UIButton = UIButton(frame: CGRectMake(0, 0,25,25))
    backbtn.setImage(UIImage(named: "whiteback.png"), forState: UIControlState.Normal)
    backbtn.addTarget(self, action: "btnBackTapped", forControlEvents: UIControlEvents.TouchUpInside)
    
    barBackBtn = UIBarButtonItem(customView: backbtn)
    self.navigationItem.setLeftBarButtonItem(barBackBtn, animated: true)
    
    btnAddQues = UIButton(frame: CGRectMake(self.view.frame.origin.x+20,self.view.frame.height-50, self.view.frame.width-40, 40))
    btnAddQues.backgroundColor = UIColor(red: 71.0/255.0, green: 168.0/255.0, blue: 184.0/255.0,alpha:1.0)
    btnAddQues.setTitle("Add Your Question", forState: UIControlState.Normal)
    btnAddQues.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
    btnAddQues.titleLabel?.font = btnAddQues.titleLabel?.font.fontWithSize(12)
    self.view.addSubview(btnAddQues)
    
    tableview = UITableView(frame: CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+64, self.view.frame.width,btnAddQues.frame.origin.y - btnAddQues.frame.height-30))
    //tableview.backgroundColor = UIColor.grayColor()
    tableview.delegate = self
    tableview.dataSource = self
    self.view.addSubview(tableview)
    
    tableview.registerClass(QuesAnsTableViewCell.self, forCellReuseIdentifier: "cell")
    
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 4
  }
  
 func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 120
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell = tableview.dequeueReusableCellWithIdentifier("cell") as QuesAnsTableViewCell
    
    cell.defaultUIDesign()
    cell.cellbtnAddAns.addTarget(self, action: "btnAddAnswerTapped", forControlEvents: UIControlEvents.TouchUpInside)
    cell.cellbtnAns.addTarget(self, action: "btnAnswerTapped", forControlEvents: UIControlEvents.TouchUpInside)
    
    return cell
    
  }
  
  func btnBackTapped(){
    self.navigationController?.popViewControllerAnimated(true)
  }
  
  func btnAddAnswerTapped(){
    let vc = self.storyboard?.instantiateViewControllerWithIdentifier("AddAnsID") as AddAnsViewController
    self.navigationController?.pushViewController(vc, animated:true)
  }
  
  
  func btnAnswerTapped(){
    let vc = self.storyboard?.instantiateViewControllerWithIdentifier("AnswerID") as AnswersViewController
    self.navigationController?.pushViewController(vc, animated:true)
  }

  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  
  
}
