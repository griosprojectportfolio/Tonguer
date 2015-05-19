//
//  NotesViewController.swift
//  Tonguer
//
//  Created by GrepRuby on 27/04/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import UIKit

class NotesViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

  
  var barBackBtn :UIBarButtonItem!
  var btnMyNotes: UIButton!
  var btnNotes: UIButton!
  var vWHori1: UIView!
  var vWHori2: UIView!
  var tblVwNotes: UITableView!
  var tapTag: NSInteger = 1
  var btnSearch: UIButton!
  var btnfilter: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.defaultUIDesign()
    }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func defaultUIDesign(){
    
    self.title = "Notes"
    
    self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
    
    self.navigationItem.setHidesBackButton(true, animated:false)
    
    var backbtn:UIButton = UIButton(frame: CGRectMake(0, 0,25,25))
    backbtn.setImage(UIImage(named: "whiteback.png"), forState: UIControlState.Normal)
    backbtn.addTarget(self, action: "btnBackTapped", forControlEvents: UIControlEvents.TouchUpInside)
    
    barBackBtn = UIBarButtonItem(customView: backbtn)
    
    self.navigationItem.setLeftBarButtonItem(barBackBtn, animated: true)
    
    btnfilter = UIButton(frame: CGRectMake(0, 0, 25, 25))
    btnfilter.setImage(UIImage(named: "filter.png"), forState: UIControlState.Normal)
    btnfilter.addTarget(self, action: "btnFilterTapped:", forControlEvents: UIControlEvents.TouchUpInside)
    
    btnSearch = UIButton(frame: CGRectMake(0, 0, 25, 25))
    btnSearch.setImage(UIImage(named: "searchicon.png"), forState: UIControlState.Normal)
    btnSearch.addTarget(self, action: "btnSearchTapped:", forControlEvents: UIControlEvents.TouchUpInside)
    
    var btnBarFilter: UIBarButtonItem! = UIBarButtonItem(customView: btnfilter)
    var btnBarSearch: UIBarButtonItem! = UIBarButtonItem(customView: btnSearch)
    
    var btnBarAdd: UIBarButtonItem! = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "btnAddTapped:")
    btnBarAdd.tintColor = UIColor.whiteColor()
    
    self.navigationItem.setRightBarButtonItems([btnBarFilter,btnBarSearch,btnBarAdd], animated: true)
    
    
    btnMyNotes = UIButton(frame: CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y+64, self.view.frame.width/2, 40))
    btnMyNotes.setTitle("My Notes", forState: UIControlState.Normal)
    btnMyNotes.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
    btnMyNotes.tag = 1
   // btnMyNotes.titleLabel?.font = btnMyNotes.titleLabel?.font.fontWithSize(12)
    btnMyNotes.addTarget(self, action: "btnMyNotesTapped:", forControlEvents: UIControlEvents.TouchUpInside)
    self.view.addSubview(btnMyNotes)
    
    var VWVertical1: UIView! = UIView(frame: CGRectMake(btnMyNotes.frame.origin.x + btnMyNotes.frame.width, btnMyNotes.frame.origin.y,1, btnMyNotes.frame.height))
    VWVertical1.backgroundColor = UIColor.darkGrayColor()
    self.view.addSubview(VWVertical1)
    
    vWHori1 = UIView(frame: CGRectMake(btnMyNotes.frame.origin.x, btnMyNotes.frame.origin.y+btnMyNotes.frame.height, btnMyNotes.frame.width, 1))
    vWHori1.backgroundColor =  UIColor(red: 71.0/255.0, green: 168.0/255.0, blue: 184.0/255.0,alpha:1.0)
    self.view.addSubview(vWHori1)
    
    btnNotes = UIButton(frame: CGRectMake(btnMyNotes.frame.origin.x+btnMyNotes.frame.width, btnMyNotes.frame.origin.y, btnMyNotes.frame.width, btnMyNotes.frame.height))
    btnNotes.tag = 2
    btnNotes.setTitle("Notes", forState: UIControlState.Normal)
    btnNotes.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
    btnNotes.addTarget(self, action: "btnNotesTapped:", forControlEvents: UIControlEvents.TouchUpInside)
    self.view.addSubview(btnNotes)
    
    vWHori2 = UIView(frame: CGRectMake(btnNotes.frame.origin.x, btnNotes.frame.origin.y+btnNotes.frame.height, btnNotes.frame.width, 1))
    vWHori2.backgroundColor = UIColor.lightGrayColor()
    self.view.addSubview(vWHori2)
    
    tblVwNotes = UITableView(frame: CGRectMake(self.view.frame.origin.x,btnNotes.frame.origin.y+btnNotes.frame.height+5,self.view.frame.width, self.view.frame.height - (btnNotes.frame.origin.y+btnNotes.frame.height+5)))
    //tblVwNotes.backgroundColor = UIColor.grayColor()
    tblVwNotes.separatorStyle = UITableViewCellSeparatorStyle.None
    tblVwNotes.delegate = self
    tblVwNotes.dataSource = self
    self.view.addSubview(tblVwNotes)
    
    tblVwNotes.registerClass(MyNotesTableViewCell.self, forCellReuseIdentifier: "MyNotesCell")
    tblVwNotes.registerClass(NotesTableViewCell.self, forCellReuseIdentifier: "NotesCell")
    
  }
  
  func btnSearchTapped(sender:AnyObject){
    let vc = self.storyboard?.instantiateViewControllerWithIdentifier("SearchID") as SearchViewController
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  func btnAddTapped(sender:AnyObject){
    var vc = self.storyboard?.instantiateViewControllerWithIdentifier("AddNotesID") as AddNotesViewController
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  func btnFilterTapped(sender:AnyObject){
    var vc = self.storyboard?.instantiateViewControllerWithIdentifier("CourseListID") as CourselistViewController
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  func btnMyNotesTapped(sender:AnyObject){
    var btn = sender as UIButton
    tapTag = btn.tag
    vWHori1.backgroundColor =  UIColor(red: 71.0/255.0, green: 168.0/255.0, blue: 184.0/255.0,alpha:1.0)
    vWHori2.backgroundColor = UIColor.lightGrayColor()
    tblVwNotes.reloadData()
  }
  
  func btnNotesTapped(sender:AnyObject){
    var btn = sender as UIButton
    tapTag = btn.tag
    vWHori2.backgroundColor =  UIColor(red: 71.0/255.0, green: 168.0/255.0, blue: 184.0/255.0,alpha:1.0)
    vWHori1.backgroundColor = UIColor.lightGrayColor()
    tblVwNotes.reloadData()
  }
  
  func btnBackTapped(){
    self.navigationController?.popViewControllerAnimated(true)
  }

  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    var cell: UITableViewCell! = nil
    
    if(tapTag == 1){
      var cell: MyNotesTableViewCell!
      cell = tblVwNotes.dequeueReusableCellWithIdentifier("MyNotesCell") as MyNotesTableViewCell
      cell.selectionStyle = UITableViewCellSelectionStyle.None
      //cell.backgroundColor = UIColor.redColor()
//      cell.textLabel.text = "My Notes"
//      cell.textLabel.font = cell.textLabel.font.fontWithSize(12)
      cell.defaultUIDesign(self.view.frame)
       return cell
      
    }else if(tapTag == 2){
      var cell: NotesTableViewCell!
      cell = tblVwNotes.dequeueReusableCellWithIdentifier("NotesCell") as NotesTableViewCell
      cell.defaultUIDesign(self.view.frame)
       return cell
    }
    
    return cell
    
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 100
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
    let vc = self.storyboard?.instantiateViewControllerWithIdentifier("NotesDetailID") as NotesDetailViewController
    vc.isShow = tapTag
    self.navigationController?.pushViewController(vc, animated: true)
    
  }
  

}
