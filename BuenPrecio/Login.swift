//
//  Login.swift
//  BuenPrecio
//
//  Created by ignisit on 8/17/17.
//  Copyright © 2017 ignisit. All rights reserved.
//

import UIKit

import FirebaseAuth
import SwiftLoader

class Login: NSObject {
    static let shared = Login()
    
    func createUser(email:String?, password:String?, name:String?) {
        if email == nil || password == nil || name == nil {
            showAlert(title: "Signup Error!", message: "All fields are required.")
        } else {
            
            SwiftLoader.show(animated: true)
            
            Auth.auth().createUser(withEmail: email!, password: password!) { (user, error) in
                if user == nil {
                    SwiftLoader.hide()
                    self.showAlert(title: "Signup Error!", message: error.unsafelyUnwrapped.localizedDescription)
                } else {
                    let user = Auth.auth().currentUser
                    if let user = user {
                        let changeRequest = user.createProfileChangeRequest()
                        
                        changeRequest.displayName = name
                        changeRequest.commitChanges { error in
                            if let err = error {
                                SwiftLoader.hide()
                                self.showAlert(title: "Signup Error!", message: err.localizedDescription)
                            } else {
                                WriteData.shared.createUser(uid: user.uid, email: user.email, name: user.displayName, completion: { (status, message) in
                                    SwiftLoader.hide()
                                    if !(user.isEmailVerified) {
                                        self.sendEmailVerification()
                                    }
                                })
                            }
                        }
                    } else {
                        SwiftLoader.hide()
                    }
                }
            }
        }
    }
    
    func signIn(email:String?, password:String?) {
        if email == nil || password == nil {
            showAlert(title: "Login Error!", message: "All fields are required.")
        } else {
            SwiftLoader.show(animated: true)
            
            Auth.auth().signIn(withEmail: email!, password: password!) { (user, error) in
                SwiftLoader.hide()
                
                if let err = error {
                    self.showAlert(title: "Login Error!", message: err.localizedDescription)
                } else {
                    if !(user?.isEmailVerified)! {
                        self.sendEmailVerification()
                    }
                }
            }
        }
    }
    
    
    func sendEmailVerification() {
        SwiftLoader.show(animated: true)
        
        Auth.auth().currentUser?.sendEmailVerification { (error) in
            SwiftLoader.hide()
            if let err = error {
                self.showAlert(title: "Email Confirmation Sent Error!", message: err.localizedDescription)
            } else {
                self.showAlert(title: "Email Confirmation Sent!", message: "An email confirmation has been sent to: \(Auth.auth().currentUser?.email! ?? "")")
            }
        }
    }
    
    func signOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    func resetPassword(email:String?) {
        if email == nil {
            showAlert(title: "Login Error!", message: "Email required.")
        } else {
            SwiftLoader.show(animated: true)
            
            Auth.auth().sendPasswordReset(withEmail: email!) { (error) in
                SwiftLoader.hide()
                
                if let err = error {
                    self.showAlert(title: "Password Reset Sent Error!", message: err.localizedDescription)
                } else {
                    self.showAlert(title: "Password Reset Sent!", message: "A password reset email has been sent to: \(email ?? "")")
                }
            }
        }
    }
    
    func showAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: {
            
        })
    }
}
