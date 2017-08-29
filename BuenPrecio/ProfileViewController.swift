//
//  ProfileViewController.swift
//  BuenPrecio
//
//  Created by Ignis IT  on 10/08/17.
//  Copyright © 2017 ignisit. All rights reserved.
//

import UIKit
import FirebaseAuth
import SwiftLoader

class ProfileViewController: UIViewController {
    
    @IBOutlet var userName: UITextField!
    @IBOutlet var userEmail: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var phoneNo: UITextField!
    
    var user:User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        SwiftLoader.show(animated: true)
        ReadData.shared.getUser(uid: (Auth.auth().currentUser?.uid)!) { (userData) in
            
            SwiftLoader.hide()
            print("User \(userData.description)")
            self.user = User.init(data: userData, key: (Auth.auth().currentUser?.uid)!)
            
            self.userName.text = self.user?.name
            self.userEmail.text = self.user?.email
            self.phoneNo.text = self.user?.phone
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Util.shared.updateView(txtField: userName, imgStr: "ic_person")
        Util.shared.updateView(txtField: userEmail, imgStr: "ic_email")
        Util.shared.updateView(txtField: password, imgStr: "ic_lock_outline")
        Util.shared.updateView(txtField: phoneNo, imgStr: "ic_phone")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateUserData() {
        SwiftLoader.show(animated: true)
        WriteData.shared.updateUser(uid: (self.user?.id)!, email: self.userEmail.text, name: self.userName.text, phone: self.phoneNo.text, completion: { (status, message) in
            SwiftLoader.hide()
            if status {
                Login.shared.showAlert(title: "Profile Success!", message: "User profile updated successfully.")
            } else {
                Login.shared.showAlert(title: "Profile Error!", message: message)
            }
        })
    }
    
    func promptTheUser(completion:@escaping (AuthCredential)->Void) {
        let alert = UIAlertController(title: "Authentication!", message: "Enter email and password.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Signin", style: UIAlertActionStyle.default, handler: { (alertAction) in
            let emailField = alert.textFields![0]
            let passwordField = alert.textFields![1]
            
            let credential: AuthCredential = EmailAuthProvider.credential(withEmail: emailField.text!, password: passwordField.text!)
            completion(credential)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        alert.addTextField { (textField) in
            textField.placeholder = "Email"
            textField.text = Auth.auth().currentUser?.email
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Password"
            textField.isSecureTextEntry = true
        }
        
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: {
            
        })
    }
    
    @IBAction func updateUserProfile(_ sender: UIButton) {
        if ((userName.text?.characters.count)! > 2) && (Util.shared.isValidEmail(testStr: userEmail.text!) == true) && ((phoneNo.text?.characters.count)! == 10) {
            
            if let pass = password.text, (password.text?.characters.count)! > 0 {
                if ((password.text?.characters.count)! > 4)  {
                    
                    let user = Auth.auth().currentUser
                    self.promptTheUser(completion: { (credential) in
                        
                        SwiftLoader.show(animated: true)
                        
                        user?.reauthenticate(with: credential) { error in
                            if let error = error {
                                SwiftLoader.hide()
                                Login.shared.showAlert(title: "Profile Error!", message: error.localizedDescription)
                            } else {
                                Auth.auth().currentUser?.updatePassword(to: pass, completion: { (error) in
                                    
                                    SwiftLoader.hide()
                                    
                                    if let err = error {
                                        Login.shared.showAlert(title: "Profile Error!", message: err.localizedDescription)
                                    } else {
                                        self.updateUserData()
                                    }
                                })
                            }
                        }
                    })
                } else {
                    Login.shared.showAlert(title: "Profile Error!", message: "password should be more then 4 digit")
                }
                
            } else {
                self.updateUserData()
            }
        }
        else if ((userName.text?.characters.count)! < 3) {
            Login.shared.showAlert(title: "Profile Error!", message: "Please enter valid username")
        }
        else if (Util.shared.isValidEmail(testStr: userEmail.text!) == false) {
            Login.shared.showAlert(title: "Profile Error!", message: "Please enter valid email address")
        }
        else if ((phoneNo.text?.characters.count)! != 10) {
            Login.shared.showAlert(title: "Profile Error!", message: "Please enter vaild phone number")
        }
        
    }
    
    @IBAction func gotoHome(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}
