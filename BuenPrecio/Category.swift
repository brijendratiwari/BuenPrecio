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
    var imageUrl:String! = nil
    var id:String! = nil
    var subCat = [SubCategory]()
    
    init(data:NSDictionary, key:String) {
        super.init()
        id = key
        
        if let imageVal = data.value(forKey: "image") {
            imageUrl = imageVal as! String
        }
        
        if let nameVal = data.value(forKey: "name") {
            name = nameVal as! String
        }
//        else {
//            let ky: String = data.allKeys[0] as! String
//
//            if data.value(forKey: ky) is NSDictionary {
//                let subCatDict: NSDictionary = data.value(forKey: ky) as! NSDictionary
//                print(subCatDict.allKeys)
//                
//                let dict: NSMutableArray = NSMutableArray.init()
//                
//                for arr in subCatDict {
//                    name = arr.value as! String
//                    id = arr.key as! String
//                    dict.add(["name": name, "id": id])
//                }
//                subCat = dict
//            }
//            
//        }
        
        ReadData.shared.getSubcategories(forCategory: name) { (subCategories) in
            self.subCat = subCategories
        }
    }
    
}
