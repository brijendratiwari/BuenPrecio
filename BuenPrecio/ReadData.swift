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
        ref.child("Products").queryOrderedByValue().queryStarting(atValue: keyword.lowercased(), childKey: "name").observe(DataEventType.value, with: { (snapshot) in
            var arr = [Product]()
            if snapshot.exists() {
                for child in snapshot.children {
                    let child = child as! DataSnapshot
                    if let product = child.value as? [String: AnyObject] {
                        let productObj = Product.init(data: product as NSDictionary, key: child.key)
                        
                        if let name = productObj.name {
                            if (name as String).lowercased().contains(keyword.lowercased()) {
                                arr.append(productObj)
                            }
                        }
                    }
                }
            }
            subscribe(arr)
            
        })
    }
    
    func getCategories(subscribe: @escaping (_ categories:[Category]) -> Void) {
        ref.child("Category").observe(DataEventType.value, with: { (snapshot) in
            var arr = [Category]()
            
            for child in snapshot.children {
                let child = child as! DataSnapshot
                if let category = child.value as? [String: AnyObject] {
                    arr.append(Category.init(data: category as NSDictionary, key: child.key))
                }
            }
            
            subscribe(arr)
        }) { (error) in
            subscribe([Category]())
            print(error.localizedDescription)
        }
    }
    
    
    func getAllfeaturedProducts(subscribe: @escaping (_ categories:[Product]) -> Void) {
        ref.child("Products").queryOrdered(byChild: "special").queryEqual(toValue: true).observe(DataEventType.value, with: { (snapshot) in
            var arr = [Product]()
            
            for child in snapshot.children {
                let child = child as! DataSnapshot
                if let product = child.value as? [String: AnyObject] {
                    arr.append(Product.init(data: product as NSDictionary, key: child.key))
                }
            }
            
            subscribe(arr)
        }) { (error) in
            subscribe([Product]())
            print(error.localizedDescription)
        }
    }
    
    func getAllSubcategories(subscribe: @escaping (_ categories:[SubCategory]) -> Void) {
        ref.child("Subcategory").observe(DataEventType.value, with: { (snapshot) in
            let response = snapshot.value as? NSDictionary
            var arr = [SubCategory]()
            
            
            for child in snapshot.children {
                let child = child as! DataSnapshot
                if let subCategory = child.value as? [String: AnyObject] {
                    arr.append(SubCategory.init(data: subCategory as NSDictionary, key: child.key))
                }
            }
            
            
            subscribe(arr)
        }) { (error) in
            subscribe([SubCategory]())
            print(error.localizedDescription)
        }
    }
    
    func getSubcategories(forCategory:String, subscribe: @escaping (_ categories:[SubCategory]) -> Void) {
        ref.child("Subcategory").queryOrdered(byChild: "category").queryEqual(toValue: forCategory).observe(DataEventType.value, with: { (snapshot) in
            var arr = [SubCategory]()
            
            for child in snapshot.children {
                let child = child as! DataSnapshot
                if let subCategory = child.value as? [String: AnyObject] {
                    arr.append(SubCategory.init(data: subCategory as NSDictionary, key: child.key))
                }
            }
            subscribe(arr)
            
        }) { (error) in
            subscribe([SubCategory]())
            print(error.localizedDescription)
        }
    }
    
    func getAllProducts(subscribe: @escaping (_ categories:[Product]) -> Void) {
        ref.child("Products").observe(DataEventType.value, with: { (snapshot) in
            var arr = [Product]()
            
            for child in snapshot.children {
                let child = child as! DataSnapshot
                if let product = child.value as? [String: AnyObject] {
                    arr.append(Product.init(data: product as NSDictionary, key: child.key))
                }
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
            var arr = [Product]()
            
            for child in snapshot.children {
                let child = child as! DataSnapshot
                if let product = child.value as? [String: AnyObject] {
                    arr.append(Product.init(data: product as NSDictionary, key: child.key))
                }
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
