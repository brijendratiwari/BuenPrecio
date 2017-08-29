//
//  CartProductView.swift
//  BuenPrecio
//
//  Created by ignisit on 8/25/17.
//  Copyright © 2017 ignisit. All rights reserved.
//

import UIKit

class CartProductView: UIView {
    @IBOutlet weak var removeButton: UIButton!

    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var quantityIncreaseBtn: UIButton!
    @IBOutlet weak var quantityCountLbl: UILabel!
    @IBOutlet weak var quantityDecreaseBtn: UIButton!
    @IBAction func remove(_ sender: Any) {
    }
    
    override func layoutSubviews() {
        Util.shared.changeImageColor(imageV: quantityIncreaseBtn.imageView!, color: UIColor.lightGray)
        Util.shared.changeImageColor(imageV: quantityDecreaseBtn.imageView!, color: UIColor.lightGray)
        Util.shared.changeImageColor(imageV: removeButton.imageView!, color: UIColor.red)
    }
    
    func copyView<T: CartProductView>() -> T {
        
        productPrice.tag = 11
        productImage.tag = 22
        productName.tag = 33
        quantityDecreaseBtn.tag = 44
        quantityCountLbl.tag = 55
        quantityIncreaseBtn.tag = 66
        removeButton.tag = 77
        
        let clone = NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: self)) as! T
        
        clone.productPrice = clone.viewWithTag(productPrice.tag) as! UILabel
        clone.productImage = clone.viewWithTag(productImage.tag) as! UIImageView
        clone.productName = clone.viewWithTag(productName.tag) as! UILabel
        clone.quantityDecreaseBtn = clone.viewWithTag(quantityDecreaseBtn.tag) as! UIButton
        clone.quantityCountLbl = clone.viewWithTag(quantityCountLbl.tag) as! UILabel
        clone.quantityIncreaseBtn = clone.viewWithTag(quantityIncreaseBtn.tag) as! UIButton
        clone.removeButton = clone.viewWithTag(removeButton.tag) as! UIButton

        
        return clone
    }
    
    func loadData(product:Product, quantity:Int) {
        
        productPrice.text = "\(product.price)"
        productName.text = "\(product.name)"
        productPrice.text = "\(product.price)"
        productImage.sd_setImage(with: NSURL.init(string: product.image)! as URL) { (image, error, cacheType, url) in
            
        }

    }

    
    @IBAction func quantityDecrease(_ sender: Any) {
        
    }
    
    @IBAction func quantityIncrease(_ sender: Any) {
        
    }

}
