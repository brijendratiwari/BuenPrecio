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
    
    
    override func layoutSubviews() {
        priceLbl.layer.borderWidth = 2
        priceLbl.layer.borderColor = UIColor.white.cgColor
        
        if (UIApplication.shared.keyWindow?.bounds.width)! < CGFloat(500) {
            priceLbl.font = UIFont.systemFont(ofSize: 11)
        }
    }
    
    func setProduct(product:Product) {
        self.product = product
        self.priceLbl.text = "\(product.price!) $"
        
        self.photoImgV.sd_setImage(with: NSURL.init(string: product.image) as URL?, placeholderImage: UIImage.init(named: "no-image.png"), options: SDWebImageOptions.continueInBackground) { (img, error, cahcheType, url)  in
            
        }
    }
    
    private func scaleAnimation(scaleFrom:CGFloat, scaleTo:CGFloat, animationTime:Double, callBack: @escaping (Void)->Void) {
        UIView.animate(withDuration: animationTime, animations: {
            self.photoImgV.transform = CGAffineTransform.init(scaleX: scaleFrom, y: scaleFrom)
            self.priceLbl.transform =  CGAffineTransform.init(scaleX: scaleFrom, y: scaleFrom)
        }) { (status) in
            UIView.animate(withDuration: animationTime, animations: {
                self.photoImgV.transform = CGAffineTransform.init(scaleX: scaleTo, y: scaleTo)
                self.priceLbl.transform = CGAffineTransform.init(scaleX: scaleTo, y: scaleTo)
            }) { (status ) in
                callBack()
            }
        }
    }
    
    func pickAnimation() {
        let scaleFrom:CGFloat = 1.3
        let scaleTo:CGFloat = 1.1
        let animationTime = 0.2
        scaleAnimation(scaleFrom: scaleFrom, scaleTo: scaleTo, animationTime: animationTime) { () in
            
        }
    }
    
    
    func leaveAnimation(callBack: @escaping (Void)->Void) {
        let scaleFrom:CGFloat = 0.6
        let scaleTo:CGFloat = 1
        let animationTime = 0.3
        scaleAnimation(scaleFrom: scaleFrom, scaleTo: scaleTo, animationTime: animationTime) { () in
            callBack()
        }
    }
    
    func moveToCartAnimation(cartView:UIView, callBack: @escaping (Void)->Void) {
        cartView.superview?.bringSubview(toFront: cartView)
        
        UIView.animate(withDuration: 0.4, animations: {
            self.center = CGPoint.init(x: cartView.center.x, y: cartView.frame.origin.y)
        }) { (status) in
            
            let scaleTo:CGFloat = 2
            UIView.animate(withDuration: 0.3, animations: {
                self.photoImgV.transform = CGAffineTransform.init(scaleX: scaleTo, y: scaleTo)
//                self.priceLbl.transform = CGAffineTransform.init(scaleX: scaleTo, y: scaleTo)
            }) { (status) in
                let scaleToX:CGFloat = 0.2
                let scaleToY:CGFloat = 0.4
                UIView.animate(withDuration: 0.8, animations: {
                    self.center = CGPoint.init(x: cartView.center.x, y: cartView.center.y)
                    self.photoImgV.transform = CGAffineTransform.init(scaleX: scaleToX, y: scaleToY)
                    self.priceLbl.transform = CGAffineTransform.init(scaleX: 0, y: 0)
                }) { (status) in
                    callBack()
                }
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
                clone.photoImgV.image = self.photoImgV.image?.copy() as! UIImage
            }
        }
        return clone
    }
}

