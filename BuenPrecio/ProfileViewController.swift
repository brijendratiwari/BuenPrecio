//
//  ProfileViewController.swift
//  BuenPrecio
//
//  Created by Ignis IT  on 10/08/17.
//  Copyright © 2017 ignisit. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet var userName: UITextField!
    @IBOutlet var userEmail: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var phoneNo: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let arr: NSArray = [userName, userEmail, password, phoneNo]
        
        for txt in arr {
            (txt as AnyObject).layer.borderWidth = 1.0
            (txt as AnyObject).layer.borderColor = UIColor.lightGray.cgColor
        }
        self.updateView(txtField: userName, imgStr: "user-icon")
        self.updateView(txtField: userEmail, imgStr: "mail")
        self.updateView(txtField: password, imgStr: "lock")
        self.updateView(txtField: phoneNo, imgStr: "receiver")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateView(txtField: UITextField, imgStr: String) {
        
        var val: NSInteger = 20
        
        if txtField == phoneNo {
            val = 30
        }
        
        let vw = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
        vw.backgroundColor = UIColor.clear
        
        let imageView = UIImageView(frame: CGRect(x: 10, y: 10, width: val, height: 20))
        imageView.image = UIImage.init(named: imgStr)
        imageView.tintColor = UIColor.clear
        
        vw.addSubview(imageView)
        
        txtField.leftView = vw
        txtField.leftViewMode = UITextFieldViewMode.always
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    @IBAction func updateUserProfile(_ sender: UIButton) {
        if ((userName.text?.characters.count)! > 2) && (self.isValidEmail(testStr: userEmail.text!) == true) && ((phoneNo.text?.characters.count)! == 10) && ((password.text?.characters.count)! > 4) {
            
        }
        else if ((userName.text?.characters.count)! < 3) {
            print("Please enter valid username")
        }
        else if (self.isValidEmail(testStr: userEmail.text!) == false) {
            print("Please enter valid email address")
        }
        else if ((phoneNo.text?.characters.count)! != 10) {
            print("Please enter vaild phone number")
        }
        else {
            print("password should be more then 4 digit")
        }
    }
    
    @IBAction func gotoHome(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }

}
