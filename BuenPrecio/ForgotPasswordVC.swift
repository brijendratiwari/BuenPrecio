//
//  ForgotPasswordVC.swift
//  BuenPrecio
//
//  Created by Ignis IT  on 10/08/17.
//  Copyright © 2017 ignisit. All rights reserved.
//

import UIKit

class ForgotPasswordVC: UIViewController {
    
    @IBOutlet var emailField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.updateView(txtField: emailField, imgStr: "mail")
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

    @IBAction func recoverPassword(_ sender: UIButton) {
        if self.isValidEmail(testStr: emailField.text!) == true {
            print("Valid email")
        }
        else {
            print("Please enter valid email address")
        }
    }
    
    @IBAction func gotoLoginPace(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
