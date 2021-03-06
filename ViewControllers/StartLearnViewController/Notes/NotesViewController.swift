//
//  NotesViewController.swift
//  Tonguer
//
//  Created by GrepRuby on 27/04/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import UIKit

class NotesViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UISearchBarDelegate {
  
  var barBackBtn :UIBarButtonItem!
  var btnMyNotes,btnNotes: UIButton!
  var vWHori1,vWHori2: UIView!
  @IBOutlet var tblVwNotes: UITableView!
  var tapTag: NSInteger = 1
  var DataFilterTag: NSInteger = 0
  var btnSearch,btnfilter: UIButton!
  var api: AppApi!
  var pickerVW: UIPickerView!
  var vwPicker: UIView!
  var actiIndecatorVw: ActivityIndicatorView!
  var arrUserNotes: NSMutableArray! = NSMutableArray()
  var arrclass: NSMutableArray! = NSMutableArray()
  var arrNotes: NSMutableArray! = NSMutableArray()
  var isSearch:Bool = false
  var isFilter:Bool = false
  var scopeSearch:NSString = "user"
  var arrySearchNotes:NSMutableArray = NSMutableArray()

  var btnBarFilter,btnBarSearch,btnBarAdd: UIBarButtonItem!
  var search:UISearchBar!
  var lblNoData:UILabel!
  var imagViewNoData:UIImageView!

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
    
    actiIndecatorVw = ActivityIndicatorView(frame: self.view.frame)
    //self.view.addSubview(actiIndecatorVw)
    self.defaultUIDesign()
    setDataNofoundImg()
    var arryUserNotes:NSArray = UserNotes.MR_findAllSortedBy("notes_id", ascending:true)
    var arryNotes:NSArray = Notes.MR_findAllSortedBy("notes_id", ascending: true)
    
    self.dataFetchFromDatabaseGetNotes(arryNotes)
    self.dataFetchFromDatabaseGetUserlNotes(arryUserNotes)
    self.fetchDataFromDBforDefaultCls()
    if (arryNotes.count != 0 || arryUserNotes.count != 0) {
      self.actiIndecatorVw.loadingIndicator.stopAnimating()
      self.actiIndecatorVw.removeFromSuperview()
      self.tblVwNotes.reloadData()
    }


  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    self.view.bringSubviewToFront(self.actiIndecatorVw)
    self.getNotesApiCall()
    self.tblVwNotes.reloadData()
    tblVwNotes.contentInset = UIEdgeInsetsMake(-64,0,0,0)
    if(tapTag == 1){
    if(arrUserNotes.count == 0){
      showSetDataNofoundImg()
    }else{
      reSetshowSetDataNofoundImg()
      }
    }else if(tapTag == 2){
      if(arrNotes.count == 0){
        showSetDataNofoundImg()
      }else{
        reSetshowSetDataNofoundImg()
      }
    }
    
  }

  func defaultUIDesign(){

    vwPicker = UIView(frame: CGRectMake(0, 0,self.view.frame.width,self.view.frame.height))
    vwPicker.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)

    var tapGuesture: UITapGestureRecognizer! = UITapGestureRecognizer(target: self, action:"tappedGestureRecog")
    vwPicker.addGestureRecognizer(tapGuesture)

    pickerVW = UIPickerView(frame: CGRectMake(vwPicker.frame.origin.x+20,(vwPicker.frame.height-250)/2,vwPicker.frame.width-40,250))
    pickerVW.backgroundColor = UIColor.whiteColor()
    pickerVW.dataSource = self
    pickerVW.delegate = self
    self.view.addSubview(vwPicker)

    vwPicker.addSubview(pickerVW)
    vwPicker.hidden = true

    btnfilter = UIButton(frame: CGRectMake(0, 0, 25, 25))
    btnfilter.setImage(UIImage(named: "filter.png"), forState: UIControlState.Normal)
    btnfilter.tag = 3
    btnfilter.addTarget(self, action: "btnFilterTapped:", forControlEvents: UIControlEvents.TouchUpInside)
    
    btnSearch = UIButton(frame: CGRectMake(0, 0, 25, 25))
    btnSearch.setImage(UIImage(named: "searchicon.png"), forState: UIControlState.Normal)
    btnSearch.tag = 4
    btnSearch.addTarget(self, action: "btnSearchTapped:", forControlEvents: UIControlEvents.TouchUpInside)
    
    btnBarFilter = UIBarButtonItem(customView: btnfilter)
    btnBarSearch = UIBarButtonItem(customView: btnSearch)
    btnBarAdd = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "btnAddTapped:")
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
    
    tblVwNotes.frame = CGRectMake(self.view.frame.origin.x,btnNotes.frame.origin.y+btnNotes.frame.height+2,self.view.frame.width, self.view.frame.height - (btnNotes.frame.origin.y+btnNotes.frame.height+5))
    //tblVwNotes.backgroundColor = UIColor.grayColor()
    tblVwNotes.separatorStyle = UITableViewCellSeparatorStyle.None

    // tblVwNotes.registerClass(MyNotesTableViewCell.self, forCellReuseIdentifier: "MyNotesCell")
    // tblVwNotes.registerClass(NotesTableViewCell.self, forCellReuseIdentifier: "NotesCell")

    search = UISearchBar(frame: CGRectMake(0, 0, 100, 30))
    search.hidden = true
    search.delegate = self
    search.showsCancelButton = true
    search.tintColor = UIColor.whiteColor()
    self.navigationItem.titleView = search
  }
  
  func setDataNofoundImg(){
    lblNoData = UILabel(frame: CGRectMake(self.view.frame.origin.x+20,self.view.frame.origin.y+120,self.view.frame.width-40, 30))
    lblNoData.text = "Sorry no data found."
    lblNoData.textAlignment = NSTextAlignment.Center
    lblNoData.hidden = true
    self.view.addSubview(lblNoData)
    //self.view.bringSubviewToFront(lblNoData)
    imagViewNoData = UIImageView(frame: CGRectMake((self.view.frame.width-100)/2,(self.view.frame.height-100)/2,100,100))
    imagViewNoData.image = UIImage(named:"smile")
    imagViewNoData.hidden = true
    self.view.addSubview(imagViewNoData)
    //self.view.bringSubviewToFront(imagViewNoData)
  }
  
  func showSetDataNofoundImg(){
    lblNoData.hidden = false
    imagViewNoData.hidden = false
  }
  
  func reSetshowSetDataNofoundImg(){
    lblNoData.hidden = true
    imagViewNoData.hidden = true
  }

  
  func btnSearchTapped(sender:AnyObject){
    var btn = sender as! UIButton
    DataFilterTag = btn.tag
    self.navigationItem.rightBarButtonItems = nil
    self.navigationItem.leftBarButtonItem = nil
    search.hidden = false
  }
  
  func btnAddTapped(sender:AnyObject){
    var vc = self.storyboard?.instantiateViewControllerWithIdentifier("AddNotesID") as! AddNotesViewController
    vc.is_Call = "Save"
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  func btnFilterTapped(sender:AnyObject){
    var btn = sender as! UIButton
    DataFilterTag = btn.tag
    vwPicker.hidden = false
    self.view.bringSubviewToFront(vwPicker)
  }
  
  func btnMyNotesTapped(sender:AnyObject){
    scopeSearch = "user"
    var btn = sender as! UIButton
    tapTag = btn.tag
    vWHori1.backgroundColor =  UIColor(red: 71.0/255.0, green: 168.0/255.0, blue: 184.0/255.0,alpha:1.0)
    vWHori2.backgroundColor = UIColor.lightGrayColor()
    getNotesApiCall()
    isFilter = false
    isSearch = false
    tblVwNotes.reloadData()
    if(arrUserNotes.count == 0){
      if(tapTag == 1){
        showSetDataNofoundImg()
      }
    }else{
      reSetshowSetDataNofoundImg()
    }

  }
  
  func btnNotesTapped(sender:AnyObject){
    scopeSearch = "all"
    var btn = sender as! UIButton
    tapTag = btn.tag
    isSearch = false
    vWHori2.backgroundColor =  UIColor(red: 71.0/255.0, green: 168.0/255.0, blue: 184.0/255.0,alpha:1.0)
    vWHori1.backgroundColor = UIColor.lightGrayColor()
    getNotesApiCall()
    isFilter = false
    tblVwNotes.reloadData()
    if(arrNotes.count == 0){
      if(tapTag == 2){
        showSetDataNofoundImg()
      }
    }else{
      reSetshowSetDataNofoundImg()
    }

  }
  
  func btnBackTapped(){
    self.navigationController?.popViewControllerAnimated(true)
  }

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    var count: NSInteger!

    if (isSearch == true || isFilter == true) {
      count = arrySearchNotes.count
    } else {
      if(tapTag == 1){
        count = arrUserNotes.count
      } else if(tapTag == 2){
        count = arrNotes.count
      }
    }
    return count
  }

  func tappedGestureRecog(){
    vwPicker.hidden = true
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    var cell: UITableViewCell! = nil
    if(tapTag == 1){
      var cell: MyNotesTableViewCell!
      cell = tblVwNotes.dequeueReusableCellWithIdentifier("MyNotesCell") as! MyNotesTableViewCell
      cell.selectionStyle = UITableViewCellSelectionStyle.None
      self.searchCellMyNotes(indexPath.row, cell1:cell)
       return cell
    } else if(tapTag == 2){
      var cell: NotesTableViewCell!
       cell = tblVwNotes.dequeueReusableCellWithIdentifier("NotesCell") as! NotesTableViewCell
      self.searchCellNotes(indexPath.row, cell1:cell)
       cell.selectionStyle = UITableViewCellSelectionStyle.None
      return cell
    }
    return cell
  }

  func searchCellNotes(var rowIndex:Int , var cell1:NotesTableViewCell)  {

    if (isSearch == true || isFilter == true) {
      if(arrySearchNotes.count>0){
        cell1.defaultUIDesign(arrySearchNotes.objectAtIndex(rowIndex) as! NSDictionary, Frame: self.view.frame)
      }
    } else{
      if(arrNotes.count>0){
        cell1.defaultUIDesign(arrNotes.objectAtIndex(rowIndex) as! NSDictionary, Frame: self.view.frame)
        }
    }
  }

  func searchCellMyNotes(var rowIndex:Int , var cell1:MyNotesTableViewCell) {
      if (isSearch == true || isFilter == true) {
        if(arrySearchNotes.count>0){
          cell1.defaultUIDesign(arrySearchNotes.objectAtIndex(rowIndex) as! NSDictionary, Frame: self.view.frame)
        }
      } else {
        if(arrUserNotes.count>0){
          cell1.defaultUIDesign(arrUserNotes.objectAtIndex(rowIndex) as! NSDictionary, Frame: self.view.frame)
        }
      }
  }

  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 100
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
    let vc = self.storyboard?.instantiateViewControllerWithIdentifier("NotesDetailID") as! NotesDetailViewController
    vc.isShow = tapTag
    if(tapTag == 1){
      if(isSearch == true){
        vc.dictNotes = arrySearchNotes.objectAtIndex(indexPath.row) as! NSDictionary
        self.navigationController?.pushViewController(vc, animated: true)
        return
      }
      if(isFilter == true){
        vc.dictNotes = arrySearchNotes.objectAtIndex(indexPath.row) as! NSDictionary
        self.navigationController?.pushViewController(vc, animated: true)
        return
      }
      vc.dictNotes = arrUserNotes.objectAtIndex(indexPath.row) as! NSDictionary
      self.navigationController?.pushViewController(vc, animated: true)
      
    }else if(tapTag == 2){
      if(isSearch == true){
        vc.dictNotes = arrySearchNotes.objectAtIndex(indexPath.row) as! NSDictionary
        self.navigationController?.pushViewController(vc, animated: true)
        return
      }
      if(isFilter == true){
        vc.dictNotes = arrySearchNotes.objectAtIndex(indexPath.row) as! NSDictionary
        self.navigationController?.pushViewController(vc, animated: true)
        return
      }
      vc.dictNotes = arrNotes.objectAtIndex(indexPath.row) as! NSDictionary
      self.navigationController?.pushViewController(vc, animated: true)
    }
   // self.navigationController?.pushViewController(vc, animated: true)
    
  }
  
  //************Call Notes Api Method *********
  
  func getNotesApiCall(){
    
    var aParams: NSMutableDictionary = NSMutableDictionary()
    aParams.setValue(auth_token[0], forKey: "auth-token")

    self.api.getUserNotes(aParams as [NSObject : AnyObject], success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
      println(responseObject)

        self.actiIndecatorVw.loadingIndicator.stopAnimating()
        self.actiIndecatorVw.removeFromSuperview()
        var dictResponse:NSDictionary = responseObject as! NSDictionary
        var arrUserNotes = dictResponse.objectForKey("UserNotes") as! NSArray
        var arrNotes = dictResponse.objectForKey("Notes") as! NSArray
       if(arrUserNotes.count != 0){
       self.reSetshowSetDataNofoundImg()
       }
      if(arrUserNotes.count != 0){
        self.reSetshowSetDataNofoundImg()
      }
        self.dataFetchFromDatabaseGetUserlNotes(dictResponse.objectForKey("UserNotes") as! NSArray)
        self.dataFetchFromDatabaseGetNotes(dictResponse.objectForKey("Notes") as! NSArray)
        self.tblVwNotes.reloadData()
      },
      failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
        println(error)
    })
  }

  //************Data fetching From DataBase Get UserNotes  *********
  
  func dataFetchFromDatabaseGetUserlNotes(arrFetchAdmin:NSArray){

    arrUserNotes.removeAllObjects()
    for var index = 0; index < arrFetchAdmin.count; ++index{
      let notesObj: UserNotes = arrFetchAdmin.objectAtIndex(index) as! UserNotes
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
        dict.setValue("http://www.popular.com.my/images/no_image.gif", forKey:"image")
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
      
      if((notesObj.notes_cls_name) != nil){
        dict.setValue(notesObj.notes_cls_name, forKey:"cls_name")
      }else{
        dict.setValue("", forKey:"cls_name")
      }

      arrUserNotes.addObject(dict)
    }
    print(arrUserNotes.count)
    if(arrUserNotes.count == 0){
      if(tapTag == 1){
        showSetDataNofoundImg()
      }else{
        reSetshowSetDataNofoundImg()
      }
    }
  }
  
  
  func dataFetchFromDatabaseGetNotes(arrFetchAdmin:NSArray){

    arrNotes.removeAllObjects()
    for var index = 0; index < arrFetchAdmin.count; ++index{
      let notesObj: Notes = arrFetchAdmin.objectAtIndex(index) as! Notes
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
        dict.setValue("http://www.popular.com.my/images/no_image.gif", forKey:"image")
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
      
      if((notesObj.notes_cls_name) != nil){
        dict.setValue(notesObj.notes_cls_name, forKey:"cls_name")
      }else{
        dict.setValue("", forKey:"cls_name")
      }
      if((notesObj.note_like_status) != nil){
        dict.setValue(notesObj.note_like_status, forKey:"note_like_status")
      }else{
        dict.setValue(0, forKey:"note_like_status")
      }
      
      arrNotes.addObject(dict)
    }
    print(arrNotes.count)
    if(arrNotes.count == 0){
      if(tapTag == 2){
        showSetDataNofoundImg()
      }
    }else{
      //reSetshowSetDataNofoundImg()
    }
  }


  func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
    return 1
  }

  func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return arrclass.count
  }

  func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {

    var dict: NSDictionary! = arrclass.objectAtIndex(row) as! NSDictionary
    var strName = dict.valueForKey("name") as! String
    //id filter
    return strName
  }

  func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

    var dict: NSDictionary! = arrclass.objectAtIndex(row) as! NSDictionary
    var name:NSString =  dict.valueForKey("name") as! NSString
    var classId:NSInteger =  dict.valueForKey("id") as! NSInteger
    vwPicker.hidden = true
    self.filterApiCall(classId) //call filter api
  }

  func filterApiCall (classId:NSInteger) {
    let param:NSDictionary = NSDictionary(objects: [auth_token[0],classId,scopeSearch], forKeys: ["auth-token","cls_id","scope"])
    self.api.callFilterNotesApi(param as [NSObject : AnyObject], success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject?) -> Void in
      print(responseObject)
      
      let arryNot = responseObject as? NSArray
      self.arrySearchNotes.removeAllObjects()
      for var index = 0; index < arryNot?.count; ++index{
        var dictData = arryNot?.objectAtIndex(index) as! NSDictionary
        print(dictData)
        
        var dict: NSMutableDictionary! = NSMutableDictionary()
        
        dict.setValue(dictData.valueForKey("id"), forKey: "id")
        dict.setValue(dictData.valueForKey("a_class")!.valueForKey("id")!, forKey: "cls_id")
        
        if((dictData.valueForKey("content")) != nil){
          dict.setValue(dictData.valueForKey("content"), forKey:"content")
        }else{
          dict.setValue("", forKey:"content")
        }
        
        if(dictData.valueForKey("image") != nil){
          dict.setValue(dictData.valueForKey("image"),forKey:"image")
        }else{
          dict.setValue("http://www.popular.com.my/images/no_image.gif", forKey:"image")
        }
        
        if((dictData.valueForKey("like_count")) != nil){
          dict.setValue(dictData.valueForKey("like_count"), forKey:"like")
        }else{
          dict.setValue(0, forKey:"like")
        }
        
        if((dictData.valueForKey("is_enable")) != nil){
          dict.setValue(dictData.valueForKey("is_enable"), forKey:"isenable")
        }else{
          dict.setValue(0, forKey:"isenable")
        }
        
        if((dictData.valueForKey("note_liked")) != nil){
          dict.setValue(dictData.valueForKey("note_liked"), forKey:"note_like_status")
        }else{
          dict.setValue(0, forKey:"note_like_status")
        }

        
        if((dictData.valueForKey("created_at")) != nil){
          dict.setValue(dictData.valueForKey("created_at"), forKey:"date")
        }else{
          dict.setValue("0000-00-00 00:00", forKey:"date")
        }
        
        if((dictData.valueForKey("a_class")?.valueForKey("name")!) != nil){
          dict.setValue(dictData.valueForKey("a_class")?.valueForKey("name"), forKey:"cls_name")
        }else{
          dict.setValue("", forKey:"cls_name")
        }
        
        
        self.arrySearchNotes.addObject(dict)
      }
      print(self.arrySearchNotes.count)
      if(arryNot?.count == 0){
        var alert: UIAlertView = UIAlertView(title: "Alert", message: "Sorry no notes found.", delegate:self, cancelButtonTitle:"OK")
        alert.show()
      }else{
        self.isFilter = true
        self.tblVwNotes.reloadData()
      }

      }){ (operation: AFHTTPRequestOperation?,errro:NSError!) -> Void in

    }
  }

  func fetchDataFromDBforDefaultCls(){
    let arrFetchedData : NSArray = UserDefaultClsList.MR_findAll()

    for var index = 0; index < arrFetchedData.count; ++index {
      let userClsObj : UserDefaultClsList = arrFetchedData.objectAtIndex(index) as! UserDefaultClsList
      var dict: NSMutableDictionary! = NSMutableDictionary()

      dict.setObject(userClsObj.cls_id, forKey: "id")

      if((userClsObj.cls_name) != nil){
        dict.setObject(userClsObj.cls_name, forKey:"name")
      }else{
        dict.setObject("No Class Name", forKey:"name")
      }

      if((userClsObj.cls_img_url) != nil){
        var str_url: NSString = userClsObj.cls_img_url
        dict.setObject(str_url, forKey:"image")

      }else{
        var str_url: NSString = "http://www.popular.com.my/images/no_image.gif"
        dict.setObject(str_url, forKey:"image")
      }

      if((userClsObj.cls_vaild_days) != nil){
        dict.setObject(userClsObj.cls_vaild_days,forKey:"days")

      }else{
        dict.setObject("No Day",forKey:"days")
      }

      if((userClsObj.cls_score) != nil){
        dict.setObject(userClsObj.cls_score, forKey: "score")

      }else{
        dict.setObject("0.0", forKey: "score")
      }

      if((userClsObj.cls_price) != nil){
        dict.setObject(userClsObj.cls_price, forKey: "price")

      }else{
        dict.setObject("0.0", forKey: "price")
      }

      if((userClsObj.cls_progress) != nil){
        dict.setObject(userClsObj.cls_progress, forKey:"progress")

      }else{
        dict.setObject("0", forKey:"progress")
      }
      arrclass.addObject(dict)
    }

    print(arrclass.count)
  }
}

extension NotesViewController:UISearchBarDelegate {

  func searchBarCancelButtonClicked(searchBar: UISearchBar) {
    searchBar.text = ""
    searchBar.hidden = true
    searchBar.resignFirstResponder()
    self.navigationItem.setLeftBarButtonItem(barBackBtn, animated: true)
    self.navigationItem.setRightBarButtonItems([btnBarFilter,btnBarSearch,btnBarAdd], animated: true)
    self.isSearch = false
    self.tblVwNotes.reloadData()
  }

  func searchBarSearchButtonClicked(searchBar: UISearchBar) {
    let param:NSDictionary = NSDictionary(objects: [auth_token[0],searchBar.text,scopeSearch], forKeys: ["auth-token","notes_key_word","scope"])
    self.api.callSearchNotesApi(param as [NSObject : AnyObject], success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject?) -> Void in
      print(responseObject)
      searchBar.resignFirstResponder()
      let arryNotes = responseObject as? NSArray
      self.arrySearchNotes.removeAllObjects()

      for var index = 0; index < arryNotes?.count; ++index{
       var dictData = arryNotes?.objectAtIndex(index) as! NSDictionary
        print(dictData)
        var dict: NSMutableDictionary! = NSMutableDictionary()

        dict.setValue(dictData.valueForKey("id"), forKey: "id")
        dict.setValue(dictData.valueForKey("a_class")!.valueForKey("id")!, forKey: "cls_id")
        
        if((dictData.valueForKey("content")) != nil){
          dict.setValue(dictData.valueForKey("content"), forKey:"content")
        }else{
          dict.setValue("", forKey:"content")
        }
        
        if((dictData.valueForKey("image")?.valueForKey("url")) != nil){
          dict.setValue(dictData.valueForKey("image")?.valueForKey("url"), forKey:"image")
        }else{
          dict.setValue("http://www.popular.com.my/images/no_image.gif", forKey:"image")
        }
        
        if((dictData.valueForKey("like_count")) != nil){
          dict.setValue(dictData.valueForKey("like_count"), forKey:"like")
        }else{
          dict.setValue(0, forKey:"like")
        }
        
        if((dictData.valueForKey("is_enable")) != nil){
          dict.setValue(dictData.valueForKey("is_enable"), forKey:"isenable")
        }else{
          dict.setValue(0, forKey:"isenable")
        }
        
        if((dictData.valueForKey("note_liked")) != nil){
          dict.setValue(dictData.valueForKey("note_liked"), forKey:"note_like_status")
        }else{
          dict.setValue(0, forKey:"note_like_status")
        }
        
        if((dictData.valueForKey("created_at")) != nil){
          dict.setValue(dictData.valueForKey("created_at"), forKey:"date")
        }else{
          dict.setValue("0000-00-00 00:00", forKey:"date")
        }
        
        if((dictData.valueForKey("a_class")?.valueForKey("name")!) != nil){
          dict.setValue(dictData.valueForKey("a_class")?.valueForKey("name"), forKey:"cls_name")
        }else{
          dict.setValue("", forKey:"cls_name")
        }
        self.arrySearchNotes.addObject(dict)
        self.isSearch = true
        self.tblVwNotes.reloadData()
      }
      
      if(arryNotes?.count == 0){
        var alert: UIAlertView = UIAlertView(title: "Alert", message: "Sorry no notes found.", delegate:self, cancelButtonTitle:"OK")
        alert.show()
        }else{
        self.isSearch = true
        self.tblVwNotes.reloadData()
      }

      }){ (operation: AFHTTPRequestOperation?,errro:NSError!) -> Void in
    }
  }
}

