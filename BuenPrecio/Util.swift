//
//  Util.swift
//  BuenPrecio
//
//  Created by ignisit on 8/17/17.
//  Copyright © 2017 ignisit. All rights reserved.
//

import UIKit


class Util: NSObject {
    static let shared = Util()
    
    public var viewsHolder:CommonViewsContainController?
    public var homeViewCtrl:ViewController?

    public func toBool(_ val:Any?) -> Bool!{
        if let boolVal = val as? Bool {
            return boolVal
        } else if let strVal = val as? NSString {
            return strVal.boolValue
        }
        return false
    }
    
    func updateView(txtField: UITextField, imgStr: String) {
        let vw = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
        vw.backgroundColor = UIColor.clear
        
        let imageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        imageView.image = UIImage.init(named: imgStr)
        imageView.tintColor = UIColor.clear
        Util.shared.changeImageColor(imageV: imageView, color: UIColor.lightGray)
        
        vw.addSubview(imageView)
        
        txtField.leftView = vw
        txtField.leftViewMode = UITextFieldViewMode.always
        
        txtField.layer.borderWidth = 1.0
        txtField.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func changeImageColor(imageV: UIImageView, color:UIColor) {
        let templateImage = imageV.image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        imageV.image = templateImage
        imageV.tintColor = color
    }
    
}
