
//
//  CourseListCell.swift
//  Tonguer
//
//  Created by GrepRuby on 17/04/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import UIKit

class CourseListCell: BaseTableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
  func defaultCellContenforCourselist(dict: NSDictionary){
    println(dict)
    
    var arry = self.contentView.subviews
    var vwSub: UIView!
    for vwSub in arry {
      vwSub.removeFromSuperview()
    }

    
    var imgVw1: UIImageView! = UIImageView(frame: CGRectMake(0, 0, 90, 90))
    imgVw1.image = UIImage(named: dict.objectForKey("image") as NSString)
    imgVw1.layer.borderWidth = 0.5
    imgVw1.layer.borderColor = UIColor.grayColor().CGColor
    self.contentView.addSubview(imgVw1)
    
    var vWCell: UIView! = UIView(frame: CGRectMake(90, imgVw1.frame.origin.y,self.frame.width, imgVw1.frame.height))
    //vWCell.backgroundColor = UIColor.grayColor()
    vWCell.layer.borderWidth = 0.5
    vWCell.layer.borderColor = UIColor.grayColor().CGColor
    self.contentView.addSubview(vWCell)
    
    var lbl: UILabel! = UILabel(frame: CGRectMake(5, 0,vWCell.frame.width, vWCell.frame.height))
    lbl.text = dict.objectForKey("title") as NSString
    lbl.font = lbl.font.fontWithSize(12)
    lbl.textColor = UIColor.grayColor()
    vWCell.addSubview(lbl)
    
  }

}
