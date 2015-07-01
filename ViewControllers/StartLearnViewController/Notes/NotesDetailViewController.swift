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
  var btnDelete,btnLike,btnEdit,btnAdd: UIButton!
  var dictNotes: NSDictionary!
  var scrollVW: UIScrollView!
  var lblContent:UILabel!
  var imgVW: UIImageView!
  var api: AppApi!
  var actiIndecatorVw: ActivityIndicatorView!

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
      btnDelete.addTarget(self, action: "btnDeleteTapped:", forControlEvents: UIControlEvents.TouchUpInside)
      
      var btnBarEdit: UIBarButtonItem = UIBarButtonItem(customView: btnEdit)
      var btnBarDelete: UIBarButtonItem = UIBarButtonItem(customView: btnDelete)
      self.navigationItem.setRightBarButtonItems([btnBarEdit,btnBarDelete], animated: true)
      
    }else if(isShow == 2){
      
      btnAdd = UIButton(frame: CGRectMake(0, 0, 25, 25))
      btnAdd.setImage(UIImage(named: "Add.png"), forState: UIControlState.Normal)
      btnAdd.addTarget(self, action:"btnAddNoteTapped:", forControlEvents: UIControlEvents.TouchUpInside)
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
    
    var rect: CGRect! = strContent.boundingRectWithSize(CGSize(width:self.view.frame.size.width-60,height:300), options:NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(13)], context: nil)
    
    lblContent = UILabel(frame: CGRectMake(scrollVW.frame.origin.x+20,5,scrollVW.frame.size.width-40,rect.height))
    
    lblContent.text = strContent
    lblContent.numberOfLines = 0
    lblContent.textAlignment = NSTextAlignment.Justified
    lblContent.font = lblContent.font.fontWithSize(12)
    lblContent.textColor = UIColor.grayColor()
    //lblContent.backgroundColor = UIColor.greenColor()
    scrollVW.addSubview(lblContent)
    
    imgVW = UIImageView(frame: CGRectMake(lblContent.frame.origin.x,lblContent.frame.origin.y+lblContent.frame.height+30,lblContent.frame.width,400))
    let url = NSURL(string: dictNotes.objectForKey("image") as NSString)
    imgVW.sd_setImageWithURL(url)
    //imgVW.backgroundColor = UIColor.redColor()
    scrollVW.addSubview(imgVW);
  }
  
  func btnBackTapped(){
    self.navigationController?.popViewControllerAnimated(true)
  }
  
   //************Call Add Notes Api Method *********
  
  func btnAddNoteTapped(sender:UIButton){
    
    var aParams: NSMutableDictionary! = NSMutableDictionary()
    aParams.setValue(auth_token[0], forKey: "auth_token")
    aParams.setValue(dictNotes.valueForKey("id"), forKey: "note_id")
    actiIndecatorVw = ActivityIndicatorView(frame: self.view.frame)
    self.view.addSubview(actiIndecatorVw)
    self.api.addNotes(aParams, success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
      println(responseObject)
      self.actiIndecatorVw.loadingIndicator.startAnimating()
      self.actiIndecatorVw.removeFromSuperview()
      var alert: UIAlertView! = UIAlertView(title: "Alert", message: "Note added successfully", delegate:nil, cancelButtonTitle: "OK")
      alert.show()
      },
      failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
        println(operation?.responseString)
        self.actiIndecatorVw.loadingIndicator.startAnimating()
        self.actiIndecatorVw.removeFromSuperview()
        var alert: UIAlertView! = UIAlertView(title: "Alert", message: "Note is not added successfully", delegate:nil, cancelButtonTitle: "OK")
        alert.show()
    })
    
  }
  
  
  func btnEditedTapped(sender:UIButton){
    
    var vc = self.storyboard?.instantiateViewControllerWithIdentifier("AddNotesID") as AddNotesViewController
    vc.dictNote = dictNotes
    vc.is_Call = "Upadte"
    self.navigationController?.pushViewController(vc, animated: true)
    
  }
  
  func btnLikeTapped(sender:UIButton){
    notesLikeApiCall()
  }
  
  func btnDeleteTapped(sender:UIButton){
    var notes_id = dictNotes.valueForKey("id") as NSInteger
    deleteNotesApiCall(notes_id)
  }
  
  
 
  
  
  //************Call Notes Api Method *********
  
  func notesLikeApiCall(){
    
    var aParams: NSMutableDictionary! = NSMutableDictionary()
    aParams.setValue(auth_token[0], forKey: "auth_token")
     aParams.setValue(dictNotes.valueForKey("id"), forKey: "note_id")
    
    self.api.notesLike(aParams, success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
      println(responseObject)
      self.btnLike.enabled = false
     
      },
      failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
        println(error)
        var alert: UIAlertView! = UIAlertView(title: "Alert", message:"You have already like this note.", delegate:nil, cancelButtonTitle: "OK")
        alert.show()
    })
  }

    
  func deleteNotesApiCall (notes_id:NSInteger) {

    let param:NSDictionary = NSDictionary(objects: [auth_token[0],notes_id], forKeys: ["auth_token","note_id"])
    self.api.callNotesDeleteApi(param, success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject?) -> Void in
      self.deleteNotes()
      }){ (operation: AFHTTPRequestOperation?,errro:NSError!) -> Void in
       
        var alert: UIAlertView = UIAlertView(title: "Alert", message: "Note is not deleted.", delegate:self, cancelButtonTitle:"OK")
        alert.show()
    }
  }

  func deleteNotes () {
    self.navigationController?.popViewControllerAnimated(true)
  }
}

