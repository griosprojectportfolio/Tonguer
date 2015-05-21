//
//  NotesDetailViewController.swift
//  Tonguer
//
//  Created by GrepRuby on 29/04/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import UIKit

class NotesDetailViewController: BaseViewController {
  
  var isShow: NSInteger!
  var barBackBtn :UIBarButtonItem!
  var btnDelete: UIButton!
  var btnEdit: UIButton!
  var btnLike: UIButton!
  var btnAdd: UIButton!
  var dictNotes: NSDictionary!
  var scrollVW: UIScrollView!
  var lblContent:UILabel!
  var api: AppApi!

  override func viewDidLoad() {
    super.viewDidLoad()
    api = AppApi.sharedClient()
    print(dictNotes)
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
      btnEdit.addTarget(self, action: "btnEditedTapped:", forControlEvents: UIControlEvents.TouchUpInside)
      
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
      btnLike.addTarget(self, action: "btnLikeTapped:", forControlEvents: UIControlEvents.TouchUpInside)
      var btnBarLike: UIBarButtonItem = UIBarButtonItem(customView: btnLike)
      
      self.navigationItem.setRightBarButtonItems([btnBarAdd,btnBarLike], animated: true)
    }
    
    scrollVW = UIScrollView(frame: CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width,self.view.frame.size.height))
    
    scrollVW.showsHorizontalScrollIndicator = true
    scrollVW.scrollEnabled = true
    scrollVW.userInteractionEnabled = true
    //scrollVW.backgroundColor = UIColor.grayColor()
    scrollVW.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height+100)
    self.view.addSubview(scrollVW)
    
    var strContent: NSString = dictNotes.valueForKey("content") as NSString
    
    var rect: CGRect! = strContent.boundingRectWithSize(CGSize(width:self.view.frame.size.width-60,height:300), options:NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(12)], context: nil)
    
    lblContent = UILabel(frame: CGRectMake(scrollVW.frame.origin.x+20,5,scrollVW.frame.size.width-40,rect.height))
    
    lblContent.text = strContent
    lblContent.numberOfLines = 0
    lblContent.textAlignment = NSTextAlignment.Justified
    lblContent.font = lblContent.font.fontWithSize(12)
    lblContent.textColor = UIColor.grayColor()
    //lblContent.backgroundColor = UIColor.greenColor()
    scrollVW.addSubview(lblContent)

  }
  
  func btnBackTapped(){
    self.navigationController?.popViewControllerAnimated(true)
  }
  
  func btnEditedTapped(sender:UIButton){
    
    var vc = self.storyboard?.instantiateViewControllerWithIdentifier("AddNotesID") as AddNotesViewController
    vc.dictNote = dictNotes
    self.navigationController?.pushViewController(vc, animated: true)
    
  }
  
  func btnLikeTapped(sender:UIButton){
    notesLikeApiCall()
  }
  
  
  
  //************Call Notes Api Method *********
  
  func notesLikeApiCall(){
    
    var aParams: NSMutableDictionary! = NSMutableDictionary()
    aParams.setValue(auth_token[0], forKey: "auth_token")
     aParams.setValue(dictNotes.valueForKey("id"), forKey: "auth_token")
    
    self.api.notesLike(aParams, success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
      println(responseObject)
      self.btnLike.enabled = false
     
      },
      failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
        println(error)
        
    })
    
  }

  

}

