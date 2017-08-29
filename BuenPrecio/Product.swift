//
//  Product.swift
//  BuenPrecio
//
//  Created by ignisit on 8/14/17.
//  Copyright © 2017 ignisit. All rights reserved.
//

import UIKit


class Product: NSObject {
    var descrip:String! = nil
    var image:String! = nil
    var name:String! = nil
    var price:NSNumber! = nil
    var quantity:NSNumber! = nil
    var special:Bool! = false
    var subcategory:String! = nil
    var id:String! = nil
    
    init(data:NSDictionary, key:String) {
        super.init()
        if let description = data.value(forKey: "description") {
            self.descrip = description as! String
        }
        if let image = data.value(forKey: "image") {
            self.image = image as! String
        }
        if let name = data.value(forKey: "name") {
            self.name = name as! String
        }
        if let price = data.value(forKey: "price") {
            self.price = price as! NSNumber
        }
        if let quantity = data.value(forKey: "quantity") {
            self.quantity = quantity as! NSNumber
        }
        if let special = data.value(forKey: "special") {
            self.special = Util.shared.toBool(special)
        }
        if let subcategory = data.value(forKey: "subcategory") {
            self.subcategory = subcategory as! String
        }

        id = key
    }
}
