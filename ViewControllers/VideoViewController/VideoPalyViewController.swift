//
//  VideoPalyViewController.swift
//  Tonguer
//
//  Created by GrepRuby on 25/06/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import UIKit
import MediaPlayer

class VideoPalyViewController:BaseViewController {
  

 var moviePlayerController:MPMoviePlayerController!
 var player:MPMoviePlayerViewController!
 var viedoUrl:NSURL!
 var barBackBtn :UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
      
      self.navigationItem.setHidesBackButton(true, animated:false)
      
      var backbtn:UIButton = UIButton(frame: CGRectMake(0, 0,25,25))
      backbtn.setImage(UIImage(named: "whiteback.png"), forState: UIControlState.Normal)
      backbtn.addTarget(self, action: "btnBackTapped", forControlEvents: UIControlEvents.TouchUpInside)
      
      barBackBtn = UIBarButtonItem(customView: backbtn)
      self.navigationItem.setLeftBarButtonItem(barBackBtn, animated: true)

//      moviePlayerController = MPMoviePlayerController(contentURL:viedoUrl)
//      moviePlayerController.view.frame = CGRectMake(self.view.frame.origin.x+20, self.view.frame.origin.y+74, self.view.frame.width-40,400)
//      self.view.addSubview(moviePlayerController.view)
//      moviePlayerController.setFullscreen(true, animated:true)
//      moviePlayerController.controlStyle = MPMovieControlStyle.Embedded
//      moviePlayerController.shouldAutoplay = false
      player = MPMoviePlayerViewController(contentURL: viedoUrl)
      //presentMoviePlayerViewControllerAnimated(player)
      //player.moviePlayer.play()
      self.presentMoviePlayerViewControllerAnimated(player)
      //moviePlayerController.play()
    }
  
  func btnBackTapped(){
    self.navigationController?.popViewControllerAnimated(true)
  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
}
