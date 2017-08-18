//
//  ProductView.swift
//  BuenPrecio
//
//  Created by ignisit on 8/16/17.
//  Copyright © 2017 ignisit. All rights reserved.
//

import UIKit
import SDWebImage



class ProductView: UIView {
    @IBOutlet var priceLbl: UILabel!
    
    @IBOutlet var photoImgV: UIImageView!
    
    var product:Product!
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    func setProduct(product:Product) {
        self.product = product
        self.priceLbl.text = "\(product.price!) $"
       
        self.photoImgV.sd_setImage(with: NSURL.init(string: product.image) as URL?, placeholderImage: UIImage.init(named: "no-image.png"), options: SDWebImageOptions.continueInBackground) { (img, error, cahcheType, url)  in
            
        }
    }
    
    
    func pickAnimation() {
        UIView.animate(withDuration: 0.3, animations:{
            self.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        }) {(status) in
            
        }
    }
    
    
    
    func leaveAnimation() {
        UIView.animate(withDuration: 0.3, animations: {
            self.transform = CGAffineTransform.init(scaleX: 0.8, y: 0.8)
        }) { (status) in
            UIView.animate(withDuration: 0.3) {
                self.transform = CGAffineTransform.init(scaleX: 1, y: 1)
            }
        }
    }
    
    
    func copyView<T: ProductView>() -> T {
        let clone = NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: self)) as! T
        
        for view in clone.subviews {
            if view is UILabel {
                clone.priceLbl = view as? UILabel
            }
            if view is UIImageView {
                clone.photoImgV = view as? UIImageView
            }
        }
        return clone
    }
}

