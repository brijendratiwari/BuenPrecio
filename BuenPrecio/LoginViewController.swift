//
//  LoginViewController.swift
//  BuenPrecio
//
//  Created by Ignis IT  on 10/08/17.
//  Copyright © 2017 ignisit. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet var checkBox: UIButton!
    @IBOutlet var forgotPasswordBtn: UIButton!
    @IBOutlet var termBtn: UIButton!
    @IBOutlet var emailId: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var userName: UITextField!
    @IBOutlet var userEmail: UITextField!
    @IBOutlet var userPassword: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let bottomLyr = CALayer.init()
        bottomLyr.frame = CGRect.init(x: 0, y: forgotPasswordBtn.frame.size.height - 1.5, width: forgotPasswordBtn.frame.size.width, height: 1.5)
        bottomLyr.backgroundColor = UIColor.init(red: 93/255, green: 174/255, blue: 49/255, alpha: 1.0).cgColor
        
        let termLyr = CALayer.init()
        termLyr.frame = CGRect.init(x: 0, y: termBtn.frame.size.height - 1.5, width: termBtn.frame.size.width, height: 1.5)
        termLyr.backgroundColor = UIColor.init(red: 93/255, green: 174/255, blue: 49/255, alpha: 1.0).cgColor
        
        
        checkBox.layer.borderColor = UIColor.black.cgColor
        checkBox.layer.borderWidth = 1.0
        
        
        termBtn.layer.addSublayer(termLyr)
        forgotPasswordBtn.layer.addSublayer(bottomLyr)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let arr: NSArray = [emailId, password, userName, userEmail, userPassword]
        for txt in arr {
            (txt as AnyObject).layer.borderWidth = 1.0
            (txt as AnyObject).layer.borderColor = UIColor.lightGray.cgColor
        }
        self.updateView(txtField: emailId, imgStr: "mail")
        self.updateView(txtField: userEmail, imgStr: "mail")
        self.updateView(txtField: password, imgStr: "lock")
        self.updateView(txtField: userPassword, imgStr: "lock")
        self.updateView(txtField: userName, imgStr: "user-icon")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateView(txtField: UITextField, imgStr: String) {
        let vw = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
        vw.backgroundColor = UIColor.clear
        
        let imageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
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

    @IBAction func userLogin(_ sender: UIButton) {
        if ((self.isValidEmail(testStr: emailId.text!)) == true) && (password.text?.characters.count)! > 4 {
            
        }
        else if ((self.isValidEmail(testStr: emailId.text!)) == false) {
            print("Invalid Email")
        }
        else {
            print("Password Should Be more than 4 digit")
        }
    }
    
    @IBAction func tickCheckBox(_ sender: UIButton) {
        checkBox.isSelected = !checkBox.isSelected
        if checkBox.isSelected {
            checkBox.setTitle("", for: UIControlState.normal)
        }
        else {
            checkBox.setTitle("✓", for: UIControlState.normal)
        }
    }
    
    @IBAction func clickTermAndConditions(_ sender: UIButton) {
    }
    
    @IBAction func registerUser(_ sender: UIButton) {
        if ((self.isValidEmail(testStr: userEmail.text!)) == true) && ((userPassword.text?.characters.count)! > 4) && (userName.text?.characters.count)! > 2 {
            
        }
        else if ((self.isValidEmail(testStr: userEmail.text!)) == false) {
            print("Invalid Email")
        }
        else if (userName.text?.characters.count)! < 3 {
            print("Please enter user name")
        }
        else {
            print("Password Should Be more than 4 digit")
        }
    }
    
    @IBAction func forgotPassword(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordVC")
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func gotoHome(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
