//
//  LearnStatusViewController.swift
//  Tonguer
//
//  Created by GrepRuby on 08/06/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import UIKit

class LearnStatusViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate {
  
  var barBackBtn :UIBarButtonItem!
  var tblStatus:UITableView!
  var api:AppApi!
  var statusData:NSArray = NSArray()

    override func viewDidLoad() {
      api = AppApi.sharedClient()
        super.viewDidLoad()
      defaultUIDesign()
    }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
//    let netconnection =   CommonUtilities.checkNetconnection()
//    if(netconnection){
//
//    }else {
//      var alert: UIAlertView! = UIAlertView(title: "Alert", message: "Please check your netconnection.", delegate: self, cancelButtonTitle: "Ok")
//      alert.show()
//    }
     userLearnClsApiCall()
  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  func defaultUIDesign(){
    
    self.title = "Already"
    
    self.navigationItem.setHidesBackButton(true, animated:false)
    
    var backbtn:UIButton = UIButton(frame: CGRectMake(0, 0,25,25))
    backbtn.setImage(UIImage(named: "whiteback.png"), forState: UIControlState.Normal)
    backbtn.addTarget(self, action: "btnBackTapped", forControlEvents: UIControlEvents.TouchUpInside)
    
    barBackBtn = UIBarButtonItem(customView: backbtn)
    self.navigationItem.setLeftBarButtonItem(barBackBtn, animated: true)
    
    tblStatus = UITableView(frame: CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.width,self.view.frame.height))
    tblStatus.delegate = self
    tblStatus.dataSource = self
    // hometableVw.backgroundColor = UIColor.grayColor()
    //tblStatus.separatorStyle = UITableViewCellSeparatorStyle.None
    tblStatus.separatorColor = UIColor.lightGrayColor()//UIColor(red: 71.0/255.0, green: 168.0/255.0, blue: 184.0/255.0,alpha:1.0)
    self.view.addSubview(tblStatus)
    tblStatus.registerClass(UITableViewCell.self, forCellReuseIdentifier:"cell")
    
  }
  
  func btnBackTapped(){
    self.navigationController?.popViewControllerAnimated(true)
  }
  
  func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    var vWheader: UIView! = UIView(frame: CGRectMake(5, 5,self.view.frame.width, 40))
    vWheader.backgroundColor = UIColor(red: 71.0/255.0, green: 168.0/255.0, blue: 184.0/255.0,alpha:1.0)
    vWheader.layer.borderWidth = 0.5
    vWheader.layer.borderColor = UIColor.lightGrayColor().CGColor
    var lblTilte: UILabel! = UILabel(frame: CGRectMake(10, 2,200,20))
    lblTilte.text = "Class Name"
    lblTilte.font = lblTilte.font.fontWithSize(16)
    lblTilte.textColor = UIColor.whiteColor()
    vWheader.addSubview(lblTilte)
    var lblStatus: UILabel! = UILabel(frame: CGRectMake(vWheader.frame.width-100, 2,100,20))
    lblStatus.text = "Learn Status"
    lblStatus.font = lblTilte.font.fontWithSize(16)
    lblStatus.textColor = UIColor.whiteColor()
    vWheader.addSubview(lblStatus)
    return vWheader
  }
  
  func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    
    return "Class Name"
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 50
  }

  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return statusData.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var  cell = tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
    
    var arry = cell.contentView.subviews
    var vwSub: UIView!
    for vwSub in arry {
      vwSub.removeFromSuperview()
    }
    cell.selectionStyle = UITableViewCellSelectionStyle.None
    var lblStatus: UILabel! = UILabel(frame: CGRectMake(self.view.frame.width-100,15,100,20))
        lblStatus.textColor = UIColor.darkGrayColor()
        lblStatus.font = lblStatus.font.fontWithSize(15)
        lblStatus.textAlignment = NSTextAlignment.Center
    cell.contentView.addSubview(lblStatus)
    if(statusData.count > 0){
      var dict:NSDictionary = statusData.objectAtIndex(indexPath.row) as NSDictionary
      var strStatus = NSString(format: "%i",dict.valueForKey("learn_status")!.integerValue!)
      var strClsname = dict.valueForKey("a_class")?.valueForKey("name") as NSString
      lblStatus.text = strStatus
      var lblClsName: UILabel! = UILabel(frame: CGRectMake(10,15,lblStatus.frame.origin.x+10,20))
      lblClsName.textColor = UIColor.darkGrayColor()
      lblClsName.text = strClsname
      lblClsName.font = lblStatus.font.fontWithSize(15)
      lblClsName.numberOfLines = 0
      lblClsName.lineBreakMode = NSLineBreakMode.ByWordWrapping
      lblClsName.sizeToFit()
      //lblClsName.textAlignment = NSTextAlignment.Center
      cell.contentView.addSubview(lblClsName)
    }
    return cell
  }
  
  func userLearnClsApiCall(){
    
    var aParams: NSDictionary = NSDictionary(objects: [self.auth_token[0]], forKeys: ["auth-token"])
    
    self.api.userDefaultCls(aParams, success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
      println(responseObject)
      let dictCls = responseObject?.valueForKey("data") as NSDictionary
      self.statusData = dictCls.valueForKey("classes") as NSArray
      if( self.statusData.count > 0){
        self.tblStatus.reloadData()
      }
     
      },
      failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
        println(error)
    })
    
  }



}
