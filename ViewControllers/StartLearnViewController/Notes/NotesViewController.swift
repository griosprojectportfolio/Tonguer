//
//  NotesViewController.swift
//  Tonguer
//
//  Created by GrepRuby on 27/04/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import UIKit

class NotesViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate {

  
  var barBackBtn :UIBarButtonItem!
  var btnMyNotes: UIButton!
  var btnNotes: UIButton!
  var vWHori1: UIView!
  var vWHori2: UIView!
  var tblVwNotes: UITableView!
  var tapTag: NSInteger = 1
  var btnSearch: UIButton!
  var btnfilter: UIButton!
  var api: AppApi!
  var actiIndecatorVw: ActivityIndicatorView!
  var arrUserNotes: NSMutableArray! = NSMutableArray()
  var arrNotes: NSMutableArray! = NSMutableArray()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.title = "Notes"
    
    self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
    
    self.navigationItem.setHidesBackButton(true, animated:false)
    
    var backbtn:UIButton = UIButton(frame: CGRectMake(0, 0,25,25))
    backbtn.setImage(UIImage(named: "whiteback.png"), forState: UIControlState.Normal)
    backbtn.addTarget(self, action: "btnBackTapped", forControlEvents: UIControlEvents.TouchUpInside)
    
    barBackBtn = UIBarButtonItem(customView: backbtn)
    
    self.navigationItem.setLeftBarButtonItem(barBackBtn, animated: true)
    
    api = AppApi.sharedClient()
    self.getNotesApiCall()
    actiIndecatorVw = ActivityIndicatorView(frame: self.view.frame)
    self.view.addSubview(actiIndecatorVw)
    
    delay(8) { () -> () in
      
      self.actiIndecatorVw.loadingIndicator.stopAnimating()
      self.actiIndecatorVw.removeFromSuperview()
      self.defaultUIDesign()
    }
    
    }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func defaultUIDesign(){
    
    
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
    var count: NSInteger!
    if(tapTag == 1){
      count = arrUserNotes.count
    }else if(tapTag == 2){
      count = arrNotes.count
    }
    return count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    var cell: UITableViewCell! = nil
    
    if(tapTag == 1){
      var cell: MyNotesTableViewCell!
      cell = tblVwNotes.dequeueReusableCellWithIdentifier("MyNotesCell") as MyNotesTableViewCell
      cell.selectionStyle = UITableViewCellSelectionStyle.None
     
      cell.defaultUIDesign(arrUserNotes.objectAtIndex(indexPath.row) as NSDictionary, Frame: self.view.frame)
       return cell
      
    }else if(tapTag == 2){
      var cell: NotesTableViewCell!
      cell = tblVwNotes.dequeueReusableCellWithIdentifier("NotesCell") as NotesTableViewCell
       cell.defaultUIDesign(arrNotes.objectAtIndex(indexPath.row) as NSDictionary, Frame: self.view.frame)
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
    if(tapTag == 1){
      vc.dictNotes = arrUserNotes.objectAtIndex(indexPath.row) as NSDictionary
    }else if(tapTag == 2){
      vc.dictNotes = arrNotes.objectAtIndex(indexPath.row) as NSDictionary
    }
    self.navigationController?.pushViewController(vc, animated: true)
    
  }
  
  func delay(delay:Double, closure:()->()) {
    dispatch_after(
      dispatch_time(
        DISPATCH_TIME_NOW,
        Int64(delay * Double(NSEC_PER_SEC))
      ),
      dispatch_get_main_queue(), closure)
  }
  
  //************Call Notes Api Method *********
  
  func getNotesApiCall(){
    
    var aParams: NSMutableDictionary! = NSMutableDictionary()
    aParams.setValue(auth_token[0], forKey: "auth_token")
       self.api.getUserNotes(aParams, success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
      println(responseObject)
     self.delay(2, closure: { () -> () in
        self.dataFetchFromDatabaseGetUserlNotes()
        self.dataFetchFromDatabaseGetNotes()
        })
      },
      failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
        println(error)
        
    })
    
  }

  
  //************Data fetching From DataBase Get UserNotes  *********
  
  func dataFetchFromDatabaseGetUserlNotes(){
    
      let arrFetchAdmin: NSArray = UserNotes.MR_findAll()
    for var index = 0; index < arrFetchAdmin.count; ++index{
      let notesObj: UserNotes = arrFetchAdmin.objectAtIndex(index) as UserNotes
      var dict: NSMutableDictionary! = NSMutableDictionary()
      dict.setValue(notesObj.notes_id, forKey: "id")
      dict.setValue(notesObj.notes_cls_id, forKey: "cls_id")
      
      if((notesObj.notes_content) != nil){
        dict.setValue(notesObj.notes_content, forKey:"content")
      }else{
        dict.setValue("", forKey:"content")
      }
      
      if((notesObj.notes_img) != nil){
        dict.setValue(notesObj.notes_img, forKey:"image")
      }else{
        dict.setValue("", forKey:"image")
      }
      
      if((notesObj.notes_like_count) != nil){
        dict.setValue(notesObj.notes_like_count, forKey:"like")
      }else{
        dict.setValue(0, forKey:"like")
      }
      
      if((notesObj.notes_date) != nil){
        dict.setValue(notesObj.notes_date, forKey:"date")
      }else{
        dict.setValue("0000-00-00 00:00", forKey:"date")
      }
      
      if((notesObj.isenable) != nil){
        dict.setValue(notesObj.isenable, forKey:"isenable")
      }else{
        dict.setValue(0, forKey:"isenable")
      }
      
      arrUserNotes.addObject(dict)

    }
    
    print(arrUserNotes.count)
    
  }
  
  
  func dataFetchFromDatabaseGetNotes(){
    
    let arrFetchAdmin: NSArray = Notes.MR_findAll()
    for var index = 0; index < arrFetchAdmin.count; ++index{
      let notesObj: Notes = arrFetchAdmin.objectAtIndex(index) as Notes
      var dict: NSMutableDictionary! = NSMutableDictionary()
      dict.setValue(notesObj.notes_id, forKey: "id")
      dict.setValue(notesObj.notes_cls_id, forKey: "cls_id")
      
      if((notesObj.notes_content) != nil){
        dict.setValue(notesObj.notes_content, forKey:"content")
      }else{
        dict.setValue("", forKey:"content")
      }
      
      if((notesObj.notes_img) != nil){
        dict.setValue(notesObj.notes_img, forKey:"image")
      }else{
        dict.setValue("", forKey:"image")
      }
      
      if((notesObj.notes_like_cont) != nil){
        dict.setValue(notesObj.notes_like_cont, forKey:"like")
      }else{
        dict.setValue(0, forKey:"like")
      }
      
      if((notesObj.notes_date) != nil){
        dict.setValue(notesObj.notes_date, forKey:"date")
      }else{
        dict.setValue("0000-00-00 00:00", forKey:"date")
      }
      
      arrNotes.addObject(dict)
      
    }
    
    print(arrNotes.count)
    
  }

  
  

}
