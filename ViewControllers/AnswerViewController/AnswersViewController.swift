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
  var lblQuestion: UILabel!
  var lblAnswer: UILabel!
  var scrollVW: UIScrollView!
  var imgVw1 :UIImageView!
  var vWLine1 :  UIView!
  var arrComments: NSMutableArray! = NSMutableArray()
  var dictUserAns: NSMutableDictionary! = NSMutableDictionary()
  override func viewDidLoad() {
    super.viewDidLoad()
    api = AppApi.sharedClient()
    
    getUserAnswerApiCall()
    self.dataFetchFromDataBaseUserAnswer()
    self.getQuesCommentApiCall()
    //self.dataFetchFromDataBaseQuestion()
    self.defaultUIDesign()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
  }
  
  func defaultUIDesign(){
    
    print(arrComments)
    
    self.title = "Answers"
    self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
    
    self.navigationItem.setHidesBackButton(true, animated:false)
    
    var backbtn:UIButton = UIButton(frame: CGRectMake(0, 0,25,25))
    backbtn.setImage(UIImage(named: "whiteback.png"), forState: UIControlState.Normal)
    backbtn.addTarget(self, action: "btnBackTapped", forControlEvents: UIControlEvents.TouchUpInside)
    
    barBackBtn = UIBarButtonItem(customView: backbtn)
    self.navigationItem.setLeftBarButtonItem(barBackBtn, animated: true)
    
    scrollVW = UIScrollView(frame: CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y, self.view.frame.size.width,self.view.frame.size.height))
    scrollVW.backgroundColor = UIColor.grayColor()
    scrollVW.showsHorizontalScrollIndicator = true
    scrollVW.scrollEnabled = true
    scrollVW.userInteractionEnabled = true
    self.view.addSubview(scrollVW)
    
    imgVw = UIImageView(frame: CGRectMake(scrollVW.frame.origin.x+10,90, 20, 20))
    imgVw.backgroundColor = UIColor.grayColor()
    imgVw.image = UIImage(named: "Q.png")
   scrollVW.addSubview(imgVw);
    
    vWLine = UIView(frame: CGRectMake(imgVw.frame.origin.x+imgVw.frame.width+10, imgVw.frame.origin.y, 1, imgVw.frame.height))
    vWLine.backgroundColor = UIColor.lightGrayColor()
    scrollVW.addSubview(vWLine)
    
    var strQuest = dictQues.valueForKey("question") as NSString
    var rect: CGRect! = strQuest.boundingRectWithSize(CGSize(width:self.view.frame.size.width-40,height:300), options:NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(12)], context: nil)
  
    lblQuestion = UILabel(frame: CGRectMake(vWLine.frame.origin.x+5,vWLine.frame.origin.y,rect.width,rect.height))
    lblQuestion.text = strQuest
    lblQuestion.numberOfLines = 0
    lblQuestion.textAlignment = NSTextAlignment.Justified
    lblQuestion.font = lblQuestion.font.fontWithSize(12)
    lblQuestion.textColor = UIColor.grayColor()
    lblQuestion.backgroundColor = UIColor.greenColor()
    scrollVW.addSubview(lblQuestion)
    
    var strAns = dictUserAns.valueForKey("answer") as NSString
    var rectAns: CGRect! = strQuest.boundingRectWithSize(CGSize(width:self.view.frame.size.width-40,height:300), options:NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(12)], context: nil)
    
    imgVw1 = UIImageView(frame: CGRectMake(imgVw.frame.origin.x,imgVw.frame.origin.y+lblQuestion.frame.size.height+20, 20, 20))
    imgVw1.backgroundColor = UIColor.grayColor()
    imgVw1.image = UIImage(named: "Q.png")
    scrollVW.addSubview(imgVw1);
    
    vWLine1 = UIView(frame: CGRectMake(imgVw1.frame.origin.x+imgVw1.frame.width+10, imgVw1.frame.origin.y,1,imgVw1.frame.height))
    vWLine1.backgroundColor = UIColor.lightGrayColor()
    scrollVW.addSubview(vWLine1)
    
    
    lblAnswer = UILabel(frame: CGRectMake(vWLine1.frame.origin.x+5,vWLine1.frame.origin.y, rect.width,rect.height))
    
    lblAnswer.text = strAns
    lblAnswer.numberOfLines = 0
    lblAnswer.textAlignment = NSTextAlignment.Justified
    lblAnswer.font = lblQuestion.font.fontWithSize(12)
    lblAnswer.textColor = UIColor.grayColor()
    lblAnswer.backgroundColor = UIColor.redColor()
    scrollVW.addSubview(lblAnswer)

    
    
    
    
//    txtViewQues = UITextView(frame: CGRectMake(imgVw.frame.size.width+vWLine.frame.size.width+30,80, self.view.frame.size.width-80,(self.view.frame.height-250)/2))
//    txtViewQues.text = dictQues.valueForKey("question") as NSString
//    //txtViewQues.backgroundColor = UIColor.grayColor()
//    txtViewQues.textColor = UIColor.grayColor()
//    txtViewQues.allowsEditingTextAttributes = false
//   
//    scrollVW.addSubview(txtViewQues)
    
    ansTableview = UITableView(frame: CGRectMake(scrollVW.frame.origin.x+20, lblAnswer.frame.height+200,self.view.frame.width-40,(scrollVW.frame.height-50)/2))
     ansTableview.delegate = self
     ansTableview.dataSource = self
    ansTableview.scrollEnabled = true
    ansTableview.separatorStyle = UITableViewCellSeparatorStyle.None
    scrollVW.addSubview(ansTableview)
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
  
  
  //********Question Comment Api calling Methode*********
  
  func getUserAnswerApiCall(){
    
    var aParams: NSMutableDictionary! = NSMutableDictionary()
    aParams.setValue(auth_token[0], forKey: "auth_token")
    aParams.setValue(dictUserAns.valueForKey("id"), forKey: "answer_id")
    self.api.userAnswer(aParams, success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
      println(responseObject)
  
      },
      failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
        println(error)
        
    })
  }


  //*******Data Fetching from DataBase ***********
  
  
  func dataFetchFromDataBaseQuestion(){
    
    let arrFetchComment: NSArray = QuestionComment.MR_findAll()
    
    for var index = 0 ; index < arrFetchComment.count ; index++ {
      let clsObj: QuestionComment! = arrFetchComment.objectAtIndex(index) as QuestionComment
      
      var dict: NSMutableDictionary! = NSMutableDictionary()
      dict.setValue(clsObj.comt_id, forKey: "id")
      dict.setValue(clsObj.comment, forKey:"comment")
      arrComments.addObject(dict)
      ansTableview.reloadData()
    }
    
  }

  func dataFetchFromDataBaseUserAnswer(){
    
   let arrFetchAnswer: NSArray = Answer.MR_findAll()
  
      for var index = 0 ; index < arrFetchAnswer.count ; index++ {
      let ansObj: Answer! = arrFetchAnswer.objectAtIndex(index) as Answer
      
      dictUserAns.setValue(ansObj.ans_id, forKey: "id")
      dictUserAns.setValue(ansObj.answer, forKey:"answer")
    
    }
    
  }

  
}
