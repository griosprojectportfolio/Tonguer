
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
  
  func defaultCellContenforCourselist(dict: NSDictionary,Frame:CGRect){
    println(dict)
    
    var arry = self.contentView.subviews
    var vwSub: UIView!
    for vwSub in arry {
      vwSub.removeFromSuperview()
    }
    
    var lblElemnet: UILabel = UILabel(frame: CGRectMake(0,0,Frame.width,70))
    lblElemnet.text = "Elements"
    lblElemnet.backgroundColor = UIColor.redColor()
    lblElemnet.font = lblElemnet.font.fontWithSize(12)
    lblElemnet.textColor = UIColor.grayColor()
    contentView.addSubview(lblElemnet)


  }

}
