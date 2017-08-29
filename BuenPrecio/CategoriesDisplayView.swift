//
//  CategoryView.swift
//  BuenPrecio
//
//  Created by ignisit on 8/23/17.
//  Copyright © 2017 ignisit. All rights reserved.
//

import UIKit

class CategoriesDisplayView: UIView , CategoryViewDelegate{
    @IBOutlet public var categoryScrollView: UIScrollView!
  
    
    @IBOutlet weak var cancelButton: UIButton!
   
    
    private var subCategorySelectCallback:((SubCategory)->Void)?
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    func loadData(onView:UIView) {
        //        categoryView.removeFromSuperview()
        self.frame = onView.bounds
        onView.addSubview(self)
        self.isHidden = true

        self.backgroundColor = UIColor.white
        
        ReadData.shared.getCategories { (categories) in
            
            self.categoryScrollView.subviews.forEach({$0.removeFromSuperview()})
            Util.shared.viewsHolder?.categoryView.alpha = 1

            let frame =  onView.bounds
            var indexCount:CGFloat = 0
            let xGap:CGFloat = 20
            let yGap:CGFloat = 20
            var contentSizeWidth:CGFloat = 0
            
            for category in categories {
                indexCount += 1
                if let newCatView = Util.shared.viewsHolder?.categoryView.copyView() {
                    self.categoryScrollView.addSubview(newCatView)
                    newCatView.delegate = self
                    newCatView.frame.size.width = frame.width/3
                    newCatView.frame.size.height = frame.height
                    newCatView.frame.origin.x = contentSizeWidth
                    newCatView.frame.origin.y = yGap
                    newCatView.categoryIndexLbl.text = "\(Int(indexCount))"
                    newCatView.loadData(category: category)
                    contentSizeWidth = newCatView.frame.maxX + xGap
                }
                
            }
            self.categoryScrollView.contentSize = CGSize.init(width: contentSizeWidth, height: 0)
            Util.shared.viewsHolder?.categoryView.alpha = 0
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
    
    func subscribeFor(subCategorySelect:@escaping ((SubCategory)->Void)) {
        self.subCategorySelectCallback = subCategorySelect
    }
    
    
    @IBAction func cancelView(_ sender: Any) {
        UIView.animate(withDuration: 0.3, animations: {
            self.frame.origin.y = (self.superview?.frame.width)!
        }) { (status) in
            self.isHidden = true
        }
        
    }
    
    //CategoryViewDelegate
    
    func subCategorySelected(subCategory: SubCategory) {
        self.cancelView(cancelButton)
        
        if let callBack = subCategorySelectCallback {
            callBack(subCategory)
        }
    }
}
