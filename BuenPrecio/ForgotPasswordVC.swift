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
        
        Util.shared.updateView(txtField: emailField, imgStr: "mail")
    }
    
    
    @IBAction func recoverPassword(_ sender: UIButton) {
        if Util.shared.isValidEmail(testStr: emailField.text!) == true {
           Login.shared.resetPassword(email: emailField.text!)
        }
        else {
            Login.shared.showAlert(title: "Alert!", message: "Please enter valid email address")
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
