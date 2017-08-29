//
//  CartView.swift
//  BuenPrecio
//
//  Created by ignisit on 8/25/17.
//  Copyright © 2017 ignisit. All rights reserved.
//

import UIKit

class CartView: UIView {
    @IBOutlet public var productScrollView: UIScrollView!
    
    
    @IBOutlet weak var cancelButton: UIButton!
    
    
    func loadData(onView:UIView) {
        //        categoryView.removeFromSuperview()
        self.frame = onView.bounds
        onView.addSubview(self)
        self.isHidden = true
        
        
        ReadData.shared.getCategories { (categories) in
            
            self.productScrollView.subviews.forEach({$0.removeFromSuperview()})
            Util.shared.viewsHolder?.cartProductView.alpha = 1
            
            let frame =  self.productScrollView.bounds
            var indexCount:CGFloat = 0
            let xGap:CGFloat = 20
            let yGap:CGFloat = 0
            var contentSizeWidth:CGFloat = 0
            
            for category in categories {
                indexCount += 1
                if let newCatView = Util.shared.viewsHolder?.cartProductView.copyView() {
                    self.productScrollView.addSubview(newCatView)
                    newCatView.frame.size.width = frame.width/3
                    newCatView.frame.size.height = frame.height - yGap
                    newCatView.frame.origin.x = contentSizeWidth
                    newCatView.frame.origin.y = yGap
                    contentSizeWidth = newCatView.frame.maxX + xGap
                }
                
            }
            self.productScrollView.contentSize = CGSize.init(width: contentSizeWidth, height: 0)
            Util.shared.viewsHolder?.cartProductView.alpha = 0
        }
    }
    
    func openView(onView:UIView, withAnimation:Bool) {
        self.isHidden = false
        onView.bringSubview(toFront: self)
        if withAnimation {
            self.frame.origin.y = onView.frame.width
            UIView.animate(withDuration: 0.15, animations: {
                self.frame.origin.y = 0
            })
        }
    }
    
  
    
    @IBAction func cancelView(_ sender: Any) {
        UIView.animate(withDuration: 0.5, animations: {
            self.frame.origin.y = (self.superview?.frame.height)!
        }) { (status) in
            self.isHidden = true
        }
        
    }

}
