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
        
       
        Util.shared.updateView(txtField: emailId, imgStr: "mail")
        Util.shared.updateView(txtField: userEmail, imgStr: "mail")
        Util.shared.updateView(txtField: password, imgStr: "lock")
        Util.shared.updateView(txtField: userPassword, imgStr: "lock")
        Util.shared.updateView(txtField: userName, imgStr: "user-icon")
    }
  
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    @IBAction func userLogin(_ sender: UIButton) {
        if ((Util.shared.isValidEmail(testStr: emailId.text!)) == true) && (password.text?.characters.count)! > 4 {
            Login.shared.signIn(email: emailId.text, password: password.text)
        }
        else if ((Util.shared.isValidEmail(testStr: emailId.text!)) == false) {
            Login.shared.showAlert(title: "Login Error!", message: "Invalid Email")
        }
        else {
            Login.shared.showAlert(title: "Login Error!", message: "Password Should Be more than 4 digit")
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
        if ((Util.shared.isValidEmail(testStr: userEmail.text!)) == true) && ((userPassword.text?.characters.count)! > 4) && (userName.text?.characters.count)! > 2 {
            Login.shared.createUser(email: userEmail.text, password: userPassword.text, name: userName.text)
        }
        else if ((Util.shared.isValidEmail(testStr: userEmail.text!)) == false) {
            Login.shared.showAlert(title: "Signup Error!", message: "Invalid Email")
        }
        else if (userName.text?.characters.count)! < 3 {
            Login.shared.showAlert(title: "Signup Error!", message: "Please enter user name")
        }
        else {
            Login.shared.showAlert(title: "Signup Error!", message: "Password Should Be more than 4 digit")
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
