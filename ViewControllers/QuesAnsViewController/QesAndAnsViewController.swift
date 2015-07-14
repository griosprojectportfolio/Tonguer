//
//  QesAndAnsViewController.swift
//  Tonguer
//
//  Created by GrepRuby on 20/04/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import UIKit

class QesAndAnsViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate {
  
  var barBackBtn :UIBarButtonItem!
  @IBOutlet var tableview: UITableView!
  var btnAddQues: UIButton!
  var classID: NSInteger!
  var api: AppApi!
  var actiIndecatorVw: ActivityIndicatorView!
  var arrQuestion: NSMutableArray = NSMutableArray()
  var lblNoData:UILabel!
  var imagViewNoData:UIImageView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    api = AppApi.sharedClient()
    self.title = "Question and Answer"
   
    self.navigationItem.setHidesBackButton(true, animated:false)
    
    var backbtn:UIButton = UIButton(frame: CGRectMake(0, 0,25,25))
    backbtn.setImage(UIImage(named: "whiteback.png"), forState: UIControlState.Normal)
    backbtn.addTarget(self, action: "btnBackTapped", forControlEvents: UIControlEvents.TouchUpInside)
    
    barBackBtn = UIBarButtonItem(customView: backbtn)
    self.navigationItem.setLeftBarButtonItem(barBackBtn, animated: true)
    
    self.arrQuestion.removeAllObjects()
    self.defaultUIDesign()
    self.setDataNofoundImg()
    var predicate:NSPredicate = NSPredicate (format: "class_id CONTAINS %i", classID)!
    var arry:NSArray = Questions.MR_findAllWithPredicate(predicate)
    self.dataFetchFromDataBaseQuestion(arry)
    
    actiIndecatorVw = ActivityIndicatorView(frame: self.view.frame)
    self.view.addSubview(actiIndecatorVw)
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    self.getQuestionApiCall()

    }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    self.tableview.reloadData()
  }

  func defaultUIDesign(){
    
    btnAddQues = UIButton(frame: CGRectMake(self.view.frame.origin.x+20,self.view.frame.height-50, self.view.frame.width-40, 40))
    btnAddQues.backgroundColor = UIColor(red: 71.0/255.0, green: 168.0/255.0, blue: 184.0/255.0,alpha:1.0)
    btnAddQues.setTitle("Add Your Question", forState: UIControlState.Normal)
    btnAddQues.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
    btnAddQues.titleLabel?.font = btnAddQues.titleLabel?.font.fontWithSize(12)
    btnAddQues.hidden = true
    self.view.addSubview(btnAddQues)
    
    tableview.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+64, self.view.frame.width,self.view.frame.height-64)
    tableview.separatorStyle = UITableViewCellSeparatorStyle.None
    tableview.contentInset = UIEdgeInsets(top: -64, left: 0, bottom: 0, right: 0)
    
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return arrQuestion.count
  }
  
 func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 120
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell = tableview.dequeueReusableCellWithIdentifier("cell") as QuesAnsTableViewCell
    cell.selectionStyle = UITableViewCellSelectionStyle.None
    if(arrQuestion.count>0){
    cell.defaultUIDesign(arrQuestion.objectAtIndex(indexPath.row) as NSDictionary,frame:self.view.frame)
    cell.cellbtnAddAns.tag = indexPath.row
    cell.cellbtnAddAns.addTarget(self, action: "btnAddAnswerTapped:", forControlEvents: UIControlEvents.TouchUpInside)
    cell.cellbtnAns.tag = indexPath.row
    cell.cellbtnAns.addTarget(self, action: "btnAnswerTapped:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    return cell
  }
  
  func btnBackTapped(){
    self.navigationController?.popViewControllerAnimated(true)
  }
  
  func btnAddAnswerTapped(sender:AnyObject){
    let btn = sender as UIButton
    print(btn.tag)
    let vc = self.storyboard?.instantiateViewControllerWithIdentifier("AdAnswerID") as AdAnsViewController
    var dict :NSDictionary! = arrQuestion.objectAtIndex(btn.tag) as NSDictionary
     vc.dictQus = dict
    self.navigationController?.pushViewController(vc, animated:true)
  }
  
  
  func btnAnswerTapped(sender:AnyObject){
    
    let btn = sender as UIButton
    print(btn.tag)
    let vc = self.storyboard?.instantiateViewControllerWithIdentifier("AnswerID") as AnswersViewController
     var dict :NSDictionary! = arrQuestion.objectAtIndex(btn.tag) as NSDictionary
    vc.dictQues = dict
    self.navigationController?.pushViewController(vc, animated:true)
  }

  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  //********Question Api calling Methode*********
  
  func getQuestionApiCall(){

    var aParams: NSMutableDictionary! = NSMutableDictionary()
    aParams.setValue(auth_token[0], forKey: "auth_token")
    aParams.setValue(classID, forKey: "class_id")
    self.api.clsQuestion(aParams, success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in

      println(responseObject)
      self.arrQuestion.removeAllObjects()
      self.actiIndecatorVw.loadingIndicator.stopAnimating()
      self.actiIndecatorVw.removeFromSuperview()

      var arry:NSArray = responseObject as NSArray
      print(arry.count)
      self.dataFetchFromDataBaseQuestion(arry)
      if(arry.count == 0){
//        var alert: UIAlertView = UIAlertView(title: "Alert", message: "Sorry No HomeWork Found", delegate:self, cancelButtonTitle:"OK")
//              alert.show()
       self.showSetDataNofoundImg()
      }else{
        self.reSetshowSetDataNofoundImg()
      }
      },
      failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
        println(error)
    })
  }

  func dataFetchFromDataBaseQuestion(var arrFetchQues:NSArray){
    arrQuestion.removeAllObjects()
    for var index = 0 ; index < arrFetchQues.count ; index++ {
      let clsObj: Questions! = arrFetchQues.objectAtIndex(index) as Questions
      
      var dict: NSMutableDictionary! = NSMutableDictionary()
      dict.setValue(clsObj.ques_id, forKey: "id")
      dict.setValue(clsObj.question, forKey:"question")
      arrQuestion.addObject(dict)
    }
    print(arrQuestion)
    if (arrQuestion.count != 0) {
      self.tableview.reloadData()
     // reSetshowSetDataNofoundImg()
    }else{
      //showSetDataNofoundImg()
    }
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

  
  
}
