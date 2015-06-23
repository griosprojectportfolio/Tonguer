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
    var vWheader: UIView! = UIView(frame: CGRectMake(5, 5, 100, 40))
    vWheader.backgroundColor = UIColor(red: 71.0/255.0, green: 168.0/255.0, blue: 184.0/255.0,alpha:1.0)
    vWheader.layer.borderWidth = 0.5
    vWheader.layer.borderColor = UIColor.lightGrayColor().CGColor
    var lblTilte: UILabel! = UILabel(frame: CGRectMake(10, 2,200,20))
    lblTilte.text = "Class Name" + " :: " + "Learn Status"
    lblTilte.font = lblTilte.font.fontWithSize(16)
    lblTilte.textColor = UIColor.whiteColor()
    vWheader.addSubview(lblTilte)
    
    return vWheader
  }
  
  func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    
    return "Class Name"
  }

  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return statusData.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var  cell = tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
     cell.textLabel.text = ""
    cell.textLabel.textColor = UIColor.lightGrayColor()
    cell.textLabel.font = cell.textLabel.font.fontWithSize(15)
    cell.selectionStyle = UITableViewCellSelectionStyle.None
    if(statusData.count > 0){
      var dict:NSDictionary = statusData.objectAtIndex(indexPath.row) as NSDictionary
      var strStatus = NSString(format: "%i",dict.valueForKey("learn_status")!.integerValue!)
      var strClsname = dict.valueForKey("a_class")?.valueForKey("name") as NSString
      cell.textLabel.text = strClsname + " :: " + strStatus
    }
    return cell
  }
  
  func userLearnClsApiCall(){
    
    var aParams: NSDictionary = NSDictionary(objects: [self.auth_token[0]], forKeys: ["auth_token"])
    
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
