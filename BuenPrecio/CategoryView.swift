//
//  CategoryView.swift
//  BuenPrecio
//
//  Created by ignisit on 8/23/17.
//  Copyright © 2017 ignisit. All rights reserved.
//

import UIKit

protocol CategoryViewDelegate: class {
    func subCategorySelected(subCategory:SubCategory)
    
}

class CategoryView: UIView , UITableViewDelegate, UITableViewDataSource{

    public weak var delegate:CategoryViewDelegate?
    
    
    @IBOutlet var categoryIndexLbl:UILabel!
    @IBOutlet var categoryNameLbl:UILabel!
    @IBOutlet var categoryImageLbl:UIImageView!
    @IBOutlet var subCategoryTableView:UITableView!
    
    func copyView<T: CategoryView>() -> T {
        
        categoryIndexLbl.tag = 11
        categoryNameLbl.tag = 22
        categoryImageLbl.tag = 33
        subCategoryTableView.tag = 44
        
        let clone = NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: self)) as! T

        clone.categoryIndexLbl = clone.viewWithTag(categoryIndexLbl.tag) as! UILabel
        clone.categoryNameLbl = clone.viewWithTag(categoryNameLbl.tag) as! UILabel
        clone.categoryImageLbl = clone.viewWithTag(categoryImageLbl.tag) as! UIImageView
        clone.subCategoryTableView = clone.viewWithTag(subCategoryTableView.tag) as! UITableView
        
   
        return clone
    }
    
    private var subCategories:Array = [SubCategory]()
    
    func loadData(category:Category) {
        self.subCategoryTableView.delegate = self
        self.subCategoryTableView.dataSource = self
        
        categoryNameLbl.text = category.name
        categoryImageLbl.sd_setImage(with: NSURL.init(string: category.imageUrl)! as URL) { (image, error, cacheType, url) in
            
        }
        ReadData.shared.getSubcategories(forCategory: category.name) { (subCategories) in
            self.subCategories = subCategories
            self.subCategoryTableView.reloadData()
        }
    }


    
    // Table View Delegate and datasource
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView.init()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subCategories.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell")
        let subCat = subCategories[indexPath.row]
        
        if let nameLabel = (cell?.viewWithTag(11) as? UILabel) {
            nameLabel.text = subCat.name
        }
        
        if let arrowImageview = cell?.viewWithTag(22) as? UIImageView {
            Util.shared.changeImageColor(imageV: arrowImageview, color: UIColor.gray)
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedSubCat = subCategories[indexPath.row]
        if delegate != nil {
            if delegate?.subCategorySelected != nil {
                delegate?.subCategorySelected(subCategory: selectedSubCat)
            }
        }
    }
    
    
}
