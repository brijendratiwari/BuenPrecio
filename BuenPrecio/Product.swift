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
        descrip = data.value(forKey: "description") as! String
        image = data.value(forKey: "image") as! String
        name = data.value(forKey: "name") as! String
        price = data.value(forKey: "price") as! NSNumber
        quantity = data.value(forKey: "quantity") as! NSNumber
        special = HELPER.toBool(data.value(forKey: "special"))
        subcategory = data.value(forKey: "subcategory") as! String
        id = key
    }
}
