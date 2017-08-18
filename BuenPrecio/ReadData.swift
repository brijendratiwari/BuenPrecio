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
    static let shared = ReadData()
    
    var ref: DatabaseReference = Database.database().reference()
    
    
    func searchProduct(keyword:String, subscribe: @escaping (_ products:[Product]) -> Void) {
        ref.child("Products").queryOrdered(byChild: "name").queryStarting(atValue: keyword.lowercased()).observe(DataEventType.value, with: { (snapshot) in
            var arr = [Product]()
            if let response = snapshot.value as? NSDictionary {
                
                for (key, value) in response {
                    let product = value as! NSDictionary
                    arr.append(Product.init(data: product, key: key as! String))
                }
                
            }
            subscribe(arr)
           
        })
    }
    
    func getCategories(subscribe: @escaping (_ categories:[Category]) -> Void) {
        ref.child("Category").observe(DataEventType.value, with: { (snapshot) in
            let response = snapshot.value as? NSDictionary
            var arr = [Category]()
            
            for (key, value) in response! {
                let category = value as! NSMutableDictionary
                arr.append(Category.init(data: category, key: key as! String))
            }
            subscribe(arr)
        }) { (error) in
            subscribe([Category]())
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
            subscribe([SubCategory]())
            print(error.localizedDescription)
        }
    }
    
    func getSubcategories(forCategory:String, subscribe: @escaping (_ categories:[SubCategory]) -> Void) {
        ref.child("Subcategory").queryOrdered(byChild: "category").queryEqual(toValue: forCategory).observe(DataEventType.value, with: { (snapshot) in
            let response = snapshot.value as? NSDictionary
            var arr = [SubCategory]()
            
            for (key, value) in response! {
                let subCategory = value as! NSMutableDictionary
                arr.append(SubCategory.init(data: subCategory, key: key as! String))
            }
            subscribe(arr)
        }) { (error) in
            subscribe([SubCategory]())
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
            subscribe([Product]())
            print(error.localizedDescription)
        }
    }
    
    func getProducts(forCategory:String, subscribe: @escaping (_ categories:[Product]) -> Void) {
        getSubcategories(forCategory: forCategory) { (subCategories) in
            
            var arr = [Product]()
            
            var subCategoryCounts = 0
            
            for subCategory in subCategories {
                self.getProducts(forSubcategory: subCategory.name, subscribe: { (products) in
                    subCategoryCounts += 1
                    for product in products {
                        arr.append(product)
                    }
                    
                    if subCategoryCounts == subCategories.count {
                        subscribe(arr)
                    }
                })
            }
        }
    }
    
    
    func getProducts(forSubcategory:String, subscribe: @escaping (_ categories:[Product]) -> Void) {
        ref.child("Products").queryOrdered(byChild: "subcategory").queryEqual(toValue: forSubcategory).observe(DataEventType.value, with: { (snapshot) in
            let response = snapshot.value as? NSDictionary
            var arr = [Product]()
            
            for (key, value) in response! {
                let product = value as! NSMutableDictionary
                arr.append(Product.init(data: product, key: key as! String))
            }
            subscribe(arr)
        }) { (error) in
            subscribe([Product]())
            print(error.localizedDescription)
        }
    }
    
    func getUser(uid:String, subscribe: @escaping (_ categories:NSDictionary) -> Void) {
        ref.child("Users").child(uid).observe(DataEventType.value, with: { (snapshot) in
            let response = snapshot.value as? NSDictionary
            subscribe(response!)
        }) { (error) in
            subscribe(NSDictionary.init())
            print(error.localizedDescription)
        }
    }
    
}
