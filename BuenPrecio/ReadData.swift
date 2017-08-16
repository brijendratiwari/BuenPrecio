//
//  ReadData.swift
//  BuenPrecio
//
//  Created by ignisit on 8/14/17.
//  Copyright © 2017 ignisit. All rights reserved.
//

import Foundation


import FirebaseDatabase

class ReadData:NSObject {
    var ref: DatabaseReference = Database.database().reference()

    func getCategories(subscribe: @escaping (_ categories:[Category]) -> Void) {
        ref.child("Category").observe(DataEventType.value, with: { (snapshot) in
            let response = snapshot.value as? NSDictionary
            
            print(response)
            
            var arr = [Category]()
            
            for (key, value) in response! {
                let category = value as! NSMutableDictionary
                arr.append(Category.init(data: category, key: key as! String))
            }
            subscribe(arr)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func getAllSubcategories(subscribe: @escaping (_ categories:[SubCategory]) -> Void) {
        ref.child("Subcategory").observe(DataEventType.value, with: { (snapshot) in
            let response = snapshot.value as? NSDictionary
            var arr = [SubCategory]()
            
            for (key, value) in response! {
                let subCategory = value as! NSMutableDictionary
                arr.append(SubCategory.init(data: subCategory, key: key as! String))
            }
            subscribe(arr)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func getSubcategories(forCategory:String, subscribe: @escaping (_ categories:[SubCategory]) -> Void) {
        ref.child("Subcategory").observe(DataEventType.value, with: { (snapshot) in
            let response = snapshot.value as? NSDictionary
            var arr = [SubCategory]()
            
            for (key, value) in response! {
                let subCategory = value as! NSMutableDictionary
                if (subCategory.value(forKey: "category") as! String) == forCategory {
                    arr.append(SubCategory.init(data: subCategory, key: key as! String))
                }
            }
            subscribe(arr)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func getAllProducts(subscribe: @escaping (_ categories:[Product]) -> Void) {
        ref.child("Products").observe(DataEventType.value, with: { (snapshot) in
            let response = snapshot.value as? NSDictionary
            var arr = [Product]()
            
            for (key, value) in response! {
                let product = value as! NSMutableDictionary
                arr.append(Product.init(data: product, key: key as! String))
            }
            subscribe(arr)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func getProducts(forSubcategory:String, subscribe: @escaping (_ categories:[Product]) -> Void) {
        ref.child("Products").observe(DataEventType.value, with: { (snapshot) in
            let response = snapshot.value as? NSDictionary
            var arr = [Product]()
            
            for (key, value) in response! {
                let product = value as! NSMutableDictionary
                if (product.value(forKey: "subcategory") as! String) == forSubcategory {
                    arr.append(Product.init(data: product, key: key as! String))
                }
            }
            subscribe(arr)
        }) { (error) in
            print(error.localizedDescription)
        }
    }

    
    
}
