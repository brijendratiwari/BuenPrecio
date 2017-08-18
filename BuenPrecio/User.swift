//
//  User.swift
//  BuenPrecio
//
//  Created by ignisit on 8/18/17.
//  Copyright © 2017 ignisit. All rights reserved.
//

import UIKit

class User: NSObject {
    var name:String? = ""
    var email:String! = ""
    var userType:String? = ""
    var phone:String? = ""
    var id:String? = ""

    init(data:NSDictionary, key:String) {
        super.init()
        if let name = data.value(forKey: "name") as? String {
            self.name = name
        }
        if let email = data.value(forKey: "email") as? String {
            self.email = email
        }
        if let userType = data.value(forKey: "userType") as? String {
            self.userType = userType
        }
        if let phone = data.value(forKey: "phone") as? String {
            self.phone = phone
        }
        id = key
    }
    
}
