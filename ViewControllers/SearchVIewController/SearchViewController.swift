//
//  SearchViewController.swift
//  Tonguer
//
//  Created by GrepRuby on 15/04/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
  
  var barBackBtn :UIBarButtonItem!
  var searchbar: UISearchBar!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.defaultUIDesign()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func defaultUIDesign() {
    
    searchbar = UISearchBar(frame: CGRectMake(0, 0,80,35))
    
    self.navigationItem.titleView = searchbar
    
    self.navigationItem.setHidesBackButton(true, animated:false)
    
    var backbtn:UIButton = UIButton(frame: CGRectMake(0, 0,25,25))
    backbtn.setImage(UIImage(named: "whiteback.png"), forState: UIControlState.Normal)
    backbtn.addTarget(self, action: "btnBackTapped", forControlEvents: UIControlEvents.TouchUpInside)
    
    barBackBtn = UIBarButtonItem(customView: backbtn)
    self.navigationItem.setLeftBarButtonItem(barBackBtn, animated: true)
    
    //fhdfhdfhdfh
  }
  
  func btnBackTapped(){
    self.navigationController?.popViewControllerAnimated(true)
  }
  
   
}
