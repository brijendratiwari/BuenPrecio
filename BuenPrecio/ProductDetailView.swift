//
//  ProductDetailView.swift
//  BuenPrecio
//
//  Created by ignisit on 8/17/17.
//  Copyright © 2017 ignisit. All rights reserved.
//

import UIKit
import SDWebImage

class ProductDetailView: UIView {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var productImage: UIImageView!
   
    @IBOutlet weak var closePopUpBtn: UIButton!
    
    override func layoutSubviews() {
        closePopUpBtn.layer.cornerRadius = closePopUpBtn.frame.size.height/2
        closePopUpBtn.layer.masksToBounds = true
    }
  
    func showProduct(product:Product) {
        titleLbl.text = product.name
        descriptionTextView.text = product.descrip
        priceLbl.text = "\(product.price!) $"
     
        self.productImage.sd_setImage(with: NSURL.init(string: product.image) as URL?, placeholderImage: UIImage.init(named: "no-image.png"), options: SDWebImageOptions.continueInBackground) { (img, error, cahcheType, url)  in
            
        }
        
        self.isHidden = false
    }
    
    @IBAction func addTocart(_ sender: Any) {
    }

    @IBAction func closePopup(_ sender: Any) {
        self.isHidden = true
    }
}
