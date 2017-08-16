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
    var subCat: NSArray!
    
    init(data:NSDictionary, key:String) {
        super.init()
        let ky: String = data.allKeys[0] as! String
        if ky == "name" {
            name = data.value(forKey: "name") as! String
            id = key
        }
        else {
            var subCatDict: NSDictionary = data.value(forKey: ky) as! NSDictionary
            print(subCatDict.allKeys)
            
            let dict: NSMutableArray = NSMutableArray.init()
            
            for arr in subCatDict {
                name = arr.value as! String
                id = arr.key as! String
                dict.add(["name": name, "id": id])
            }
            subCatDict = ["subcategory":dict]
        }
    }
    
}
