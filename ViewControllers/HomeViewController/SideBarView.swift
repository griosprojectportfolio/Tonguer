//
//  SideBarView.swift
//  Tonguer
//
//  Created by GrepRuby on 08/04/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import UIKit

class SideBarView: UIView,UITableViewDataSource,UITableViewDelegate,LGChatControllerDelegate {

  var btnMyClass: UIButton!
  var btnPickUp: UIButton!
  var imgVw1: UIImageView!
  var imgVwLogo: UIImageView!
  var sideNavigation: UINavigationController!
  
  var arrname: NSArray = NSArray(objects: "My Class","Pick up Center","Charge","My Order","Feedback","Setting","Forum")
  
  var tableview: UITableView!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.addBackGround()
  }

  required init(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
  func addBackGround  () {
    self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
    
     var blackVw: UIImageView! = UIImageView(frame: CGRectMake(0,self.frame.origin.y, self.frame.width/2, self.frame.height))
    blackVw.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.95)
    self.bringSubviewToFront(blackVw)
    self.addSubview(blackVw)
    
    println((blackVw))
    
    imgVwLogo = UIImageView(frame: CGRectMake((blackVw.frame.width-90)/2,(blackVw.frame.height-140), 90, 100))
    imgVwLogo.image = UIImage(named: "Logo.png")
    self.addSubview(imgVwLogo)
    self.bringSubviewToFront(imgVwLogo)
    
    tableview = UITableView(frame: CGRectMake(0,blackVw.frame.origin.y+100, blackVw.frame.width,300))
    tableview.delegate = self
    tableview.dataSource = self
    tableview.scrollEnabled = false
    tableview.backgroundColor = UIColor.clearColor()
    tableview.separatorStyle = UITableViewCellSeparatorStyle.None
    tableview.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    self.addSubview(tableview)
    
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return arrname.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell: UITableViewCell!
    
    if(cell == nil){
      
      cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
      cell.backgroundColor = UIColor.clearColor()
      cell.selectionStyle = UITableViewCellSelectionStyle.None
      var lbl :UILabel! = UILabel(frame: CGRectMake(50, 0, 100, 30))
      lbl.text = arrname.objectAtIndex(indexPath.row) as NSString
      lbl.textColor = UIColor.whiteColor()
      lbl.font = lbl.font.fontWithSize(12)
      cell.addSubview(lbl)
      var imgVw: UIImageView! = UIImageView(frame: CGRectMake(20, 10, 12, 12))
      imgVw.image = UIImage(named: "whiteforward.png")
      cell.addSubview(imgVw)
    }
    
    return cell
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    println(indexPath.row)
    
    switch(indexPath.row){
      
    case 0:
      UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
     self.frame = CGRectMake(-(self.frame.width),self.frame.origin.y, self.frame.width, self.frame.height)
      }, completion: { (Bool) -> Void in
        println(indexPath.row)
        var vc = self.sideNavigation.storyboard?.instantiateViewControllerWithIdentifier("HomeID") as HomeViewController
        self.sideNavigation.pushViewController(vc, animated: false)
        
      })
      
    case 1:
      UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
        self.frame = CGRectMake(-(self.frame.width),self.frame.origin.y, self.frame.width, self.frame.height)
        }, completion: { (Bool) -> Void in
          println(indexPath.row)
          var vc = self.sideNavigation.storyboard?.instantiateViewControllerWithIdentifier("PickCenterID") as PickupCoursecenterViewController
          self.sideNavigation.pushViewController(vc, animated: false)
          
      })
    case 2:
      UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
        self.frame = CGRectMake(-(self.frame.width),self.frame.origin.y, self.frame.width, self.frame.height)
        }, completion: { (Bool) -> Void in
          println(indexPath.row)
          var vc = self.sideNavigation.storyboard?.instantiateViewControllerWithIdentifier("ChargeID") as ChargeViewController
          self.sideNavigation.pushViewController(vc, animated: false)
          
      })

    case 3:
      UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
        self.frame = CGRectMake(-(self.frame.width),self.frame.origin.y, self.frame.width, self.frame.height)
        }, completion: { (Bool) -> Void in
          println(indexPath.row)
          var vc = self.sideNavigation.storyboard?.instantiateViewControllerWithIdentifier("MyOderID") as MyOrderViewController
          self.sideNavigation.pushViewController(vc, animated: false)
          
      })
      
       case 4:
      
        UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
          self.frame = CGRectMake(-(self.frame.width),self.frame.origin.y, self.frame.width, self.frame.height)
          }, completion: { (Bool) -> Void in
           
            let chatController = LGChatController()
            chatController.opponentImage = UIImage(named: "User")
            chatController.userImage = UIImage(named: "User")
            
            chatController.title = "Chat"
            let helloWorld = LGChatMessage(content: "Hello World!", sentBy: .User)
            //      let helloWorld1 = LGChatMessage(content: "Hello World1!", sentBy: .Opponent)
            //      let helloWorld2 = LGChatMessage(content: "Hello World2!", sentBy: .Opponent)
            //      let helloWorld3 = LGChatMessage(content: "Hello World3!", sentBy: .Opponent)
            
            chatController.messages = [helloWorld]
            chatController.delegate = self
            self.sideNavigation?.pushViewController(chatController, animated: false)
                        
        })
      
        case 5:
          
          UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.frame = CGRectMake(-(self.frame.width),self.frame.origin.y, self.frame.width, self.frame.height)
            }, completion: { (Bool) -> Void in
              
              var vc = self.sideNavigation.storyboard?.instantiateViewControllerWithIdentifier("SettingID") as SettingViewController
              self.sideNavigation.pushViewController(vc, animated:false)
              
          })
      
    case 6:
      UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
        self.frame = CGRectMake(-(self.frame.width),self.frame.origin.y, self.frame.width, self.frame.height)
        }, completion: { (Bool) -> Void in
          
          var vc = self.sideNavigation.storyboard?.instantiateViewControllerWithIdentifier("QuesAnsID") as QesAndAnsViewController
          self.sideNavigation.pushViewController(vc, animated:false)
          
      })

    default:
      println("erroe")
      
    }
    
  }
  
  func chatController(chatController: LGChatController, didAddNewMessage message: LGChatMessage) {
    println("Did Add Message: \(message.content)")
  }
  
  
  func shouldChatController(chatController: LGChatController, addMessage message: LGChatMessage) -> Bool {
    /*
    Use this space to prevent sending a message, or to alter a message.  For example, you might want to hold a message until its successfully uploaded to a server.
    */
    return true
  }

  
}
