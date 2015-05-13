//
//  AnswersViewController.swift
//  Tonguer
//
//  Created by GrepRuby on 03/04/15.
//  Copyright (c) 2015 GrepRuby. All rights reserved.
//

import UIKit
import Foundation

class AnswersViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate{
  
  var barBackBtn :UIBarButtonItem!
  var txtViewQues :UITextView!
  var imgVw :UIImageView!
  var vWLine :  UIView!
  var ansTableview:UITableView!
  var dictQues: NSDictionary!
  var api: AppApi!
  var arrComments: NSMutableArray! = NSMutableArray()
  override func viewDidLoad() {
    super.viewDidLoad()
    api = AppApi.sharedClient()
    self.defaultUIDesign()
    self.getQuesCommentApiCall()
    //self.dataFetchFromDataBaseQuestion()
  }
  
  func defaultUIDesign(){
    
    self.title = "Answers"
    self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
    
    self.navigationItem.setHidesBackButton(true, animated:false)
    
    var backbtn:UIButton = UIButton(frame: CGRectMake(0, 0,25,25))
    backbtn.setImage(UIImage(named: "whiteback.png"), forState: UIControlState.Normal)
    backbtn.addTarget(self, action: "btnBackTapped", forControlEvents: UIControlEvents.TouchUpInside)
    
    barBackBtn = UIBarButtonItem(customView: backbtn)
    self.navigationItem.setLeftBarButtonItem(barBackBtn, animated: true)
    
    imgVw = UIImageView(frame: CGRectMake(self.view.frame.origin.x+10,90, 20, 20))
    imgVw.backgroundColor = UIColor.grayColor()
    imgVw.image = UIImage(named: "Q.png")
    self.view.addSubview(imgVw);
    
    vWLine = UIView(frame: CGRectMake(imgVw.frame.origin.x+imgVw.frame.width+10, imgVw.frame.origin.y, 1, imgVw.frame.height))
    vWLine.backgroundColor = UIColor.lightGrayColor()
    self.view.addSubview(vWLine)
    
    txtViewQues = UITextView(frame: CGRectMake(imgVw.frame.size.width+vWLine.frame.size.width+30,80, self.view.frame.size.width-80,(self.view.frame.height-250)/2))
    txtViewQues.text = dictQues.valueForKey("question") as NSString
    //txtViewQues.backgroundColor = UIColor.grayColor()
    txtViewQues.textColor = UIColor.grayColor()
    txtViewQues.allowsEditingTextAttributes = false
   
    self.view.addSubview(txtViewQues)
    
    ansTableview = UITableView(frame: CGRectMake(self.view.frame.origin.x+20, txtViewQues.frame.height+100,self.view.frame.width-40,(self.view.frame.height-50)/2))
     ansTableview.delegate = self
     ansTableview.dataSource = self
    ansTableview.scrollEnabled = true
    ansTableview.separatorStyle = UITableViewCellSeparatorStyle.None
    self.view.addSubview(ansTableview)
    ansTableview.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
  }
  
  func btnBackTapped(){
    self.navigationController?.popViewControllerAnimated(true)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return arrComments.count
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 50
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell: UITableViewCell! = ansTableview.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
    var dict: NSDictionary! = arrComments.objectAtIndex(indexPath.row) as NSDictionary
     cell.textLabel.text = dict.valueForKey("comment") as NSString
    return cell
  }
  
  //********Question Comment Api calling Methode*********
  
  func getQuesCommentApiCall(){
    
    var aParams: NSMutableDictionary! = NSMutableDictionary()
    aParams.setValue(auth_token[0], forKey: "auth_token")
    aParams.setValue(dictQues.valueForKey("id"), forKey: "question_id")
    self.api.clsQueaComment(aParams, success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
      println(responseObject)
     self.dataFetchFromDataBaseQuestion()
      },
      failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
        println(error)
        
    })
  }

  //*******Data Fetching from DataBase ***********
  
  
  func dataFetchFromDataBaseQuestion(){
    
    let arrFetchQues: NSArray = QuestionComment.MR_findAll()
    
    for var index = 0 ; index < arrFetchQues.count ; index++ {
      let clsObj: QuestionComment! = arrFetchQues.objectAtIndex(index) as QuestionComment
      
      var dict: NSMutableDictionary! = NSMutableDictionary()
      dict.setValue(clsObj.comt_id, forKey: "id")
      dict.setValue(clsObj.comment, forKey:"comment")
      arrComments.addObject(dict)
      ansTableview.reloadData()
    }
    
  }

  
  
}
