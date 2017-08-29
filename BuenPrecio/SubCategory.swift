//
//  SubCategory.swift
//  BuenPrecio
//
//  Created by ignisit on 8/14/17.
//  Copyright © 2017 ignisit. All rights reserved.
//

import UIKit

class SubCategory: NSObject {
    var name:String! = nil
    var category:String! = nil
    var id:String! = nil
    var products = [Product]()
    
    init(data:NSDictionary, key:String) {
        super.init()
        name = data.value(forKey: "name") as! String
        category = data.value(forKey: "category") as! String
        id = key
        
        ReadData.shared.getProducts(forSubcategory: name) { (products) in
            self.products = products
        }
    }
}
