//
//  StartLearnTableViewCell.swift
//  Tonguer
//
//  Created by GrepRuby on 16/04/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import UIKit

class StartLearnTableViewCell: UITableViewCell {
  
  var imgVw: UIImageView!
  var lblTilte: UILabel!
  var names: NSArray!
  var images: NSArray!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
  
  func defaultCellContent(dict : NSDictionary){
    
    println(dict)

    
    imgVw = UIImageView(frame: CGRectMake(0,20, 30, 30))
    imgVw.image = UIImage(named: dict.objectForKey("image") as NSString)
    self.contentView.addSubview(imgVw)
    
    lblTilte = UILabel(frame: CGRectMake(imgVw.frame.origin.x+imgVw.frame.width+10,imgVw.frame.origin.y-5,200, 40))
    lblTilte.text = dict.objectForKey("name") as NSString
    //lblTilte.textAlignment = NSTextAlignment.Center
    //lblTilte.backgroundColor = UIColor.redColor()
    lblTilte.textColor = UIColor.darkGrayColor()
    lblTilte.font = lblTilte.font.fontWithSize(12)
    self.contentView.addSubview(lblTilte)

    
  }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
