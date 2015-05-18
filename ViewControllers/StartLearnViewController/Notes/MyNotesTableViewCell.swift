//
//  MyNotesTableViewCell.swift
//  Tonguer
//
//  Created by GrepRuby on 29/04/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import UIKit

class MyNotesTableViewCell:BaseTableViewCell  {
  
  var imageVW: UIImageView!
  var lblContent: UILabel!
  var lblClassNam: UILabel!
  var lblDate: UILabel!
  var lblTime: UILabel!
  var lblLikeCount: UILabel!
  var vwCell: UIView!

  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  
  func defaultUIDesign(/*aParam:NSDictionary*/){
    
    var arry = self.contentView.subviews
    var vwSub: UIView!
    for vwSub in arry {
      vwSub.removeFromSuperview()
    }
    
    imageVW = UIImageView(frame: CGRectMake(self.contentView.frame.origin.x+10,self.contentView.frame.origin.y+10,80, 70))
    
    imageVW.image = UIImage(named: "demoimg.png")
    self.contentView.addSubview(imageVW)
    
    vwCell = UIView(frame: CGRectMake(imageVW.frame.origin.x+imageVW.frame.width,imageVW.frame.origin.y, self.contentView.frame.width-(imageVW.frame.width+20),imageVW.frame.height))
    vwCell.layer.borderWidth = 0.5
    vwCell.layer.borderColor = UIColor.lightGrayColor().CGColor
    self.contentView.addSubview(vwCell)
    
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  
  
}
