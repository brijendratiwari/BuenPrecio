//
//  Category.swift
//  BuenPrecio
//
//  Created by ignisit on 8/14/17.
//  Copyright © 2017 ignisit. All rights reserved.
//

import UIKit

class Category: NSObject {
    var name:String! = nil
    var id:String! = nil
    
    init(data:NSDictionary, key:String) {
        super.init()
        name = data.value(forKey: "name") as! String
        id = key
    }
    
}
