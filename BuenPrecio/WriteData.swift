//
//  WriteData.swift
//  BuenPrecio
//
//  Created by ignisit on 8/17/17.
//  Copyright © 2017 ignisit. All rights reserved.
//

import UIKit
import FirebaseDatabase

class WriteData: NSObject {
    static let shared = WriteData()

    var ref: DatabaseReference = Database.database().reference()

    func createUser(uid:String, email:String?, name:String?, completion: @escaping (Bool, String) -> Void) {
        self.ref.child("Users").child(uid).setValue(["email": email!, "name":name ?? "", "userType":1]) { (error, dr) in
            if let err = error {
                completion(false, err.localizedDescription)
            } else {
                completion(true, "")
            }
        }
    }
    
    func updateUser(uid:String, email:String?, name:String?, phone:String?, completion: @escaping (Bool, String) -> Void) {
        self.ref.child("Users").child(uid).updateChildValues(["email": email!, "name":name ?? "", "phone":phone ?? ""]) { (error, dr) in
            if let err = error {
                completion(false, err.localizedDescription)
            } else {
                completion(true, "")
            }
        }
    }
}
