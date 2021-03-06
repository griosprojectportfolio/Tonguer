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
  var vWHori1: UIView!
  var arrComments: NSMutableArray! = NSMutableArray()
  var dictUserAns: NSMutableDictionary! = NSMutableDictionary()
  var actiIndecatorVw: ActivityIndicatorView!
  var lblNoData:UILabel!
  var imagViewNoData:UIImageView!
  var arryAnswer:NSArray = NSArray()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    api = AppApi.sharedClient()
    
    self.title = "Answers"
    self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
    
    self.navigationItem.setHidesBackButton(true, animated:false)
    
    var backbtn:UIButton = UIButton(frame: CGRectMake(0, 0,25,25))
    backbtn.setImage(UIImage(named: "whiteback.png"), forState: UIControlState.Normal)
    backbtn.addTarget(self, action: "btnBackTapped", forControlEvents: UIControlEvents.TouchUpInside)
    
    barBackBtn = UIBarButtonItem(customView: backbtn)
    self.navigationItem.setLeftBarButtonItem(barBackBtn, animated: true)
  
    actiIndecatorVw = ActivityIndicatorView(frame: self.view.frame)
    self.view.addSubview(actiIndecatorVw)

    self.setDataNofoundImg()
  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    self.view.bringSubviewToFront(actiIndecatorVw)
  }
  
  override func viewDidAppear(animated: Bool) {

    super.viewDidAppear(animated)
    getUserAnswerApiCall()

    if(arryAnswer.count == 0){
      showSetDataNofoundImg()
    }else{
      resetShowSetDataNofoundImg()
    }
  }

  func defaultUIDesign(){
    
    print(arrComments)
    
    scrollVW = UIScrollView(frame: CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y+64, self.view.frame.size.width,self.view.frame.size.height-64))
   //scrollVW.backgroundColor = UIColor.grayColor()
    scrollVW.showsHorizontalScrollIndicator = true
    scrollVW.scrollEnabled = true
    scrollVW.userInteractionEnabled = true
    self.view.addSubview(scrollVW)
    
    imgVw = UIImageView(frame: CGRectMake(scrollVW.frame.origin.x+10,30,20,20))
    //imgVw.backgroundColor = UIColor.grayColor()
    imgVw.image = UIImage(named: "Q.png")
   scrollVW.addSubview(imgVw);
    
    vWLine = UIView(frame: CGRectMake(imgVw.frame.origin.x+imgVw.frame.width, imgVw.frame.origin.y, 1, imgVw.frame.height))
    vWLine.backgroundColor = UIColor.lightGrayColor()
    scrollVW.addSubview(vWLine)
    
    var strQuest = dictQues.valueForKey("question") as! NSString
    var rect: CGRect! = strQuest.boundingRectWithSize(CGSize(width:self.view.frame.size.width-40,height:300), options:NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(12)], context: nil)
    
   
  
    lblQuestion = UILabel(frame: CGRectMake(vWLine.frame.origin.x+5,vWLine.frame.origin.y,rect.width,rect.height))
    lblQuestion.text = strQuest as String
    lblQuestion.numberOfLines = 0
    lblQuestion.textAlignment = NSTextAlignment.Justified
    lblQuestion.font = lblQuestion.font.fontWithSize(12)
    lblQuestion.textColor = UIColor.grayColor()
   // lblQuestion.backgroundColor = UIColor.greenColor()
    scrollVW.addSubview(lblQuestion)
    
    
    vWHori1 = UIView(frame: CGRectMake(scrollVW.frame.origin.x, (lblQuestion.frame.origin.y+lblQuestion.frame.height+10),scrollVW.frame.width,0.5))
    vWHori1.backgroundColor = UIColor(red: 71.0/255.0, green: 168.0/255.0, blue: 184.0/255.0,alpha:1.0)
    scrollVW.addSubview(vWHori1)
    
    var strAns = dictUserAns.valueForKey("answer") as! NSString
    var strAnswer: NSString
    if(strAns.isKindOfClass(NSNull)){
      strAnswer = ""
    }else{
      strAnswer = strAns
    }
    var rectAns: CGRect! = strAnswer.boundingRectWithSize(CGSize(width:self.view.frame.size.width-60,height:300), options:NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(12)], context: nil)
    
    imgVw1 = UIImageView(frame: CGRectMake(imgVw.frame.origin.x,imgVw.frame.origin.y+lblQuestion.frame.size.height+20, 20,20))
    //imgVw1.backgroundColor = UIColor.grayColor()
    imgVw1.image = UIImage(named: "A.png")
    scrollVW.addSubview(imgVw1);
    
    vWLine1 = UIView(frame: CGRectMake(imgVw1.frame.origin.x+imgVw1.frame.width, imgVw1.frame.origin.y,1,imgVw1.frame.height))
    vWLine1.backgroundColor = UIColor.lightGrayColor()
    scrollVW.addSubview(vWLine1)
    
    
    lblAnswer = UILabel(frame: CGRectMake(vWLine1.frame.origin.x+5,vWLine1.frame.origin.y,rectAns.width,rectAns.height))
    
    lblAnswer.text = strAnswer as String
    lblAnswer.numberOfLines = 0
    lblAnswer.textAlignment = NSTextAlignment.Justified
    lblAnswer.font = lblQuestion.font.fontWithSize(12)
    lblAnswer.textColor = UIColor.grayColor()
    //lblAnswer.backgroundColor = UIColor.redColor()
    scrollVW.addSubview(lblAnswer)

    
    var vWHori2: UIView!
    vWHori2 = UIView(frame: CGRectMake(scrollVW.frame.origin.x, (lblAnswer.frame.origin.y+lblAnswer.frame.height+10),scrollVW.frame.width,1))
    vWHori2.backgroundColor = UIColor(red: 71.0/255.0, green: 168.0/255.0, blue: 184.0/255.0,alpha:1.0)
    scrollVW.addSubview(vWHori2)
    
    
    ansTableview = UITableView(frame: CGRectMake(scrollVW.frame.origin.x,vWHori2.frame.height+vWHori2.frame.origin.y+20,scrollVW.frame.width,scrollVW.frame.height-(vWHori2.frame.origin.y+30)))
     ansTableview.delegate = self
     ansTableview.dataSource = self
    ansTableview.scrollEnabled = true
    //ansTableview.backgroundColor = UIColor.yellowColor()
    ansTableview.separatorStyle = UITableViewCellSeparatorStyle.None
    scrollVW.addSubview(ansTableview)
    ansTableview.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    
    scrollVW.contentSize = CGSize(width: self.view.frame.width, height:rect.height+ansTableview.frame.height+lblAnswer.frame.height+200)
    
    if((arrComments).count == 0){
      var vwComment: UIView! = UIView(frame: CGRectMake(0,20,ansTableview.frame.width,ansTableview.frame.height))
      //vwComment.backgroundColor = UIColor.yellowColor()
      ansTableview.addSubview(vwComment)
      
      var imgVwComment:UIImageView! = UIImageView(frame: CGRectMake((vwComment.frame.width-100)/2,(vwComment.frame.height-100)/2,100,100))
      imgVwComment.image = UIImage(named: "smile.png")
      vwComment.addSubview(imgVwComment)
    }
  }
  
  func btnBackTapped(){

    println(self.navigationController?.viewControllers)
    if let viewControllers = self.navigationController?.viewControllers {
      for viewController in viewControllers {
        if viewController.isKindOfClass(QesAndAnsViewController) {
          self.navigationController?.popToViewController(viewController as! QesAndAnsViewController, animated: true)
        }
      }
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    
    return "Admin Comment"
  }
  
  func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    var vWheader: UIView! = UIView(frame: CGRectMake(5, 5, 100, 40))
    vWheader.backgroundColor = UIColor(red: 71.0/255.0, green: 168.0/255.0, blue: 184.0/255.0,alpha:1.0)
    vWheader.layer.borderWidth = 0.5
    vWheader.layer.borderColor = UIColor.lightGrayColor().CGColor
    var lblTilte: UILabel! = UILabel(frame: CGRectMake(10, 2, 100,20))
    lblTilte.text = "Admin Comments"
    lblTilte.font = lblTilte.font.fontWithSize(12)
    lblTilte.textColor = UIColor.whiteColor()
    vWheader.addSubview(lblTilte)
    
    return vWheader

  }
  
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return arrComments.count
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 50
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell: UITableViewCell! = ansTableview.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
    if(arrComments.count>0){
    var dict: NSDictionary! = arrComments.objectAtIndex(indexPath.row) as! NSDictionary
     cell.textLabel!.text = dict.valueForKey("comment") as? String
     cell.textLabel!.font = cell.textLabel!.font.fontWithSize(15)
     cell.textLabel!.textColor = UIColor.lightGrayColor()
    }
    return cell
  }
  
  //********Question Comment Api calling Methode*********
  
  func getAdminCommentApiCall(){
    
    var aParams: NSMutableDictionary = NSMutableDictionary()
    aParams.setValue(auth_token[0], forKey: "auth_token")
    aParams.setValue(dictUserAns.valueForKey("id"), forKey: "answer_id")
    self.api.clsAdminComment(aParams as [NSObject : AnyObject], success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
      println(responseObject)

      self.actiIndecatorVw.loadingIndicator.stopAnimating()
      self.actiIndecatorVw.removeFromSuperview()
      let arryQuestion:NSArray = responseObject as! NSArray
      if(arryQuestion.count>0){
        self.resetShowSetDataNofoundImg()
      self.dataFetchFromDataBaseComments(arryQuestion)
      }
      
      },
      failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
        println(error)
        
    })
  }
  //********User Answer Api calling Methode*********
  
  func getUserAnswerApiCall(){

    var userId:Int = CommonUtilities.sharedDelegate().dictUserInfo.objectForKey("id") as! Int
    var aParams: NSMutableDictionary = NSMutableDictionary()
    aParams.setValue(auth_token[0], forKey: "auth-token")
    aParams.setValue(dictQues.valueForKey("id"), forKey: "question_id")
    aParams.setValue(userId, forKey: "userId")
    println(aParams)
    self.api.userAnswer(aParams as [NSObject : AnyObject], success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
      println(responseObject)

      self.actiIndecatorVw.loadingIndicator.stopAnimating()
      self.actiIndecatorVw.removeFromSuperview()
      self.arryAnswer = responseObject as! NSArray
      if(self.arryAnswer.count>0){

        self.resetShowSetDataNofoundImg()
        self.dataFetchFromDataBaseUserAnswer(self.arryAnswer)
        self.getAdminCommentApiCall()
      }
      },
      failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
        println(error)
    })
  }
  
  func dataFetchFromDataBaseComments(arrFetchComment: NSArray ){

    for var index = 0 ; index < arrFetchComment.count ; index++ {
      let clsObj: QuestionComment! = arrFetchComment.objectAtIndex(index) as! QuestionComment
      
      var dict: NSMutableDictionary! = NSMutableDictionary()
      dict.setValue(clsObj.comt_id, forKey: "id")
      dict.setValue(clsObj.comment, forKey:"comment")
      arrComments.addObject(dict)
     
    }
  }

  func dataFetchFromDataBaseUserAnswer(arrFetchAnswer: NSArray){

      for var index = 0 ; index < arrFetchAnswer.count ; index++ {
      dictUserAns.removeAllObjects()
      let ansObj: Answer! = arrFetchAnswer.objectAtIndex(index) as! Answer
      
      dictUserAns.setValue(ansObj.ans_id, forKey: "id")
      dictUserAns.setValue(ansObj.answer, forKey:"answer")
      var strAns = ansObj.answer as NSString
      self.defaultUIDesign()
      
    }
  }
  
  func setDataNofoundImg(){
    lblNoData = UILabel(frame: CGRectMake(self.view.frame.origin.x+20,self.view.frame.origin.y+120,self.view.frame.width-40, 30))
    lblNoData.text = "Sorry no data found."
    lblNoData.textAlignment = NSTextAlignment.Center
    lblNoData.hidden = true
    self.view.addSubview(lblNoData)
    self.view.bringSubviewToFront(lblNoData)
    imagViewNoData = UIImageView(frame: CGRectMake((self.view.frame.width-100)/2,(self.view.frame.height-100)/2,100,100))
    imagViewNoData.image = UIImage(named:"smile")
    imagViewNoData.hidden = true
    self.view.addSubview(imagViewNoData)
    self.view.bringSubviewToFront(imagViewNoData)
  }
  
  func showSetDataNofoundImg(){
    lblNoData.hidden = false
    imagViewNoData.hidden = false
  }
  
  func resetShowSetDataNofoundImg(){
    lblNoData.hidden = true
    imagViewNoData.hidden = true
  }

  

}
