//
//  NotesDetailViewController.swift
//  Tonguer
//
//  Created by GrepRuby on 29/04/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import UIKit

class NotesDetailViewController: UIViewController {
  
  var isShow: NSInteger!
  var barBackBtn :UIBarButtonItem!
  var btnDelete: UIButton!
  var btnEdit: UIButton!
  var btnLike: UIButton!
  var btnAdd: UIButton!

  override func viewDidLoad() {
    super.viewDidLoad()
     self.defaultUIDesign()
    }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func defaultUIDesign() {
    self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
    
    self.navigationItem.setHidesBackButton(true, animated:false)
    
    var backbtn:UIButton = UIButton(frame: CGRectMake(0, 0,25,25))
    backbtn.setImage(UIImage(named: "whiteback.png"), forState: UIControlState.Normal)
    backbtn.addTarget(self, action: "btnBackTapped", forControlEvents: UIControlEvents.TouchUpInside)
    
    barBackBtn = UIBarButtonItem(customView: backbtn)
    self.navigationItem.setLeftBarButtonItem(barBackBtn, animated: true)
    
    if(isShow == 1){
      
      btnEdit = UIButton(frame: CGRectMake(0, 0, 25, 25))
      btnEdit.setImage(UIImage(named: "edit.png"), forState: UIControlState.Normal)
      
      btnDelete = UIButton(frame: CGRectMake(0, 0, 25, 25))
      btnDelete.setImage(UIImage(named: "deleteicon.png"), forState: UIControlState.Normal)
      
      var btnBarEdit: UIBarButtonItem = UIBarButtonItem(customView: btnEdit)
      var btnBarDelete: UIBarButtonItem = UIBarButtonItem(customView: btnDelete)
      self.navigationItem.setRightBarButtonItems([btnBarEdit,btnBarDelete], animated: true)
      
    }else if(isShow == 2){
      
      btnAdd = UIButton(frame: CGRectMake(0, 0, 25, 25))
      btnAdd.setImage(UIImage(named: "Add.png"), forState: UIControlState.Normal)
      var btnBarAdd: UIBarButtonItem = UIBarButtonItem(customView: btnAdd)
      
      btnLike = UIButton(frame: CGRectMake(0, 0, 25, 25))
      btnLike.setImage(UIImage(named: "like.png"), forState: UIControlState.Normal)
      var btnBarLike: UIBarButtonItem = UIBarButtonItem(customView: btnLike)
      
      self.navigationItem.setRightBarButtonItems([btnBarAdd,btnBarLike], animated: true)
    }
    

  }
  
  func btnBackTapped(){
    self.navigationController?.popViewControllerAnimated(true)
  }
  

}

