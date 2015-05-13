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
  var tableview: UITableView!
  var btnAddQues: UIButton!
  var classID: NSInteger!
  var api: AppApi!
  var arrQuestion: NSMutableArray! = NSMutableArray()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    api = AppApi.sharedClient()
    self.defaultUIDesign()
    self.getQuestionApiCall()
  }
  
  override func viewWillAppear(animated: Bool) {
    arrQuestion.removeAllObjects()
    self.dataFetchFromDataBaseQuestion()
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
    btnAddQues.hidden = true
    self.view.addSubview(btnAddQues)
    
    tableview = UITableView(frame: CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+64, self.view.frame.width,btnAddQues.frame.origin.y - btnAddQues.frame.height-30))
    //tableview.backgroundColor = UIColor.grayColor()
    tableview.delegate = self
    tableview.dataSource = self
    tableview.separatorStyle = UITableViewCellSeparatorStyle.None
    self.view.addSubview(tableview)
    
    tableview.registerClass(QuesAnsTableViewCell.self, forCellReuseIdentifier: "cell")
    
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
    cell.defaultUIDesign(arrQuestion.objectAtIndex(indexPath.row) as NSDictionary)
    cell.cellbtnAddAns.tag = indexPath.row
    cell.cellbtnAddAns.addTarget(self, action: "btnAddAnswerTapped:", forControlEvents: UIControlEvents.TouchUpInside)
    cell.cellbtnAns.tag = indexPath.row
    cell.cellbtnAns.addTarget(self, action: "btnAnswerTapped:", forControlEvents: UIControlEvents.TouchUpInside)
    
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
    aParams.setValue(/*dictClasses.valueForKey("id")*/4, forKey: "class_id")
    self.api.clsQuestion(aParams, success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
      println(responseObject)
      },
      failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
        println(error)
        
    })    
  }
  
  
  
  
  
  
  //********Data Fetch frome Database *********
  
  func dataFetchFromDataBaseQuestion(){
    
     let arrFetchQues: NSArray = Questions.MR_findAll()
    
    for var index = 0 ; index < arrFetchQues.count ; index++ {
      let clsObj: Questions! = arrFetchQues.objectAtIndex(index) as Questions
      
      var dict: NSMutableDictionary! = NSMutableDictionary()
      dict.setValue(clsObj.ques_id, forKey: "id")
      dict.setValue(clsObj.question, forKey:"question")
     arrQuestion.addObject(dict)
    }
    
  }
  
  
}
