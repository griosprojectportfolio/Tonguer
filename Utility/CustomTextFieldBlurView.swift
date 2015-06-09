//
//  CustomTextFieldBlurView.swift
//  Monitoring
//
//  Created by GrepRuby on 17/02/15.
//  Copyright (c) 2015 GrepRuby. All rights reserved.
//

import UIKit


class CustomTextFieldBlurView: UITextField {

    // weak var txtFld: UITextField!

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

  init(frame: CGRect, imgName:String) {
        super.init(frame: frame)
        self.addBlurViewWithTextField(imgName)
    }

    func addBlurViewWithTextField(imgName: String) {

      self.text = ""
         if (countElements(imgName) != 0) {

            var imageName = imgName
            var image = UIImage(named:imageName)
            var imageView = UIImageView(image: image!)
            var imageViewLine = UIImageView ()
            imageViewLine.backgroundColor = UIColor(red: 66.0/255.0, green: 150.0/255.0, blue: 173.0/255.0,alpha:1.0)
            imageViewLine.frame = CGRect(x: 46, y: (self.frame.size.height - 20)/2, width: 1, height: 20)
          
            imageView.frame = CGRect(x: 11, y: 11, width: 22, height: 22)
            imageView.contentMode = UIViewContentMode.ScaleAspectFit
            var vwImage = UIView(frame:CGRect(x: 0, y: 0, width: 60, height: 40))
            vwImage.addSubview(imageView)
          vwImage.addSubview(imageViewLine)
            self.returnKeyType = UIReturnKeyType.Done
            self.layer.borderColor = UIColor(red: 66.0/255.0, green: 150.0/255.0, blue: 173.0/255.0,alpha:1.0).CGColor
            self.layer.borderWidth = 1.0;
            self.leftView = vwImage
            self.leftViewMode = UITextFieldViewMode.Always;
            self.font = UIFont(name: "Palatino", size: 17.0)
            //self.textColor = UIColor.whiteColor()
            self.clearButtonMode = UITextFieldViewMode.WhileEditing;

         } else {
            var vwImage = UIView(frame:CGRect(x: 0, y: 0, width: 10, height: 5))
          self.layer.borderColor = UIColor(red: 66.0/255.0, green: 150.0/255.0, blue: 173.0/255.0,alpha:1.0).CGColor
          self.layer.borderWidth = 1.0;
            self.leftView = vwImage
            self.leftViewMode = UITextFieldViewMode.Always;
        }
    }
}
