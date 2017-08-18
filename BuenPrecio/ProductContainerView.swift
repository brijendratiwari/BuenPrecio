//
//  ProductCollectionView.swift
//  BuenPrecio
//
//  Created by ignisit on 8/16/17.
//  Copyright © 2017 ignisit. All rights reserved.
//

import UIKit

class ProductContainerView: UIView  {
    
    @IBOutlet var productScrollView: UIScrollView!
    
    @IBOutlet var productView: ProductView!
    
    @IBOutlet var leftArrowBtn: UIButton!
    @IBOutlet var rightArrowBtn: UIButton!
    
    
    public var products:Array<Product>! = []
    public var productsViewObjArr:Array<ProductView>! = []
    
    private var currentPage = 0
    private var totalPage = 1
    
    private var currentProductView:ProductView?
    private var movedProductView:ProductView?

    private var productSelectCallback:((ProductView)->Void)?
    
    override func layoutSubviews() {
        arrowButtonVisibility()
        productScrollView.isUserInteractionEnabled = false
    }
    
    func arrowButtonVisibility() {
        if totalPage > 1 {
            if currentPage == 0 {
                leftArrowBtn.alpha = CGFloat(0)
            } else {
                leftArrowBtn.alpha = CGFloat(1)
            }
            
            if currentPage == totalPage-1 {
                rightArrowBtn.alpha = CGFloat(0)
            } else {
                rightArrowBtn.alpha = CGFloat(1)
            }
        } else {
             leftArrowBtn.alpha = CGFloat(0)
             rightArrowBtn.alpha = CGFloat(0)
        }
    }
    
    func resetData() {
        products.removeAll()
        productsViewObjArr.forEach { $0.removeFromSuperview() }
        productsViewObjArr.removeAll()
        currentProductView = nil
        movedProductView = nil
        currentPage = 0
        totalPage = 1
        productScrollView.setContentOffset(CGPoint(x:0, y:0), animated: false)
        productScrollView.contentSize = CGSize.init(width: 0, height: 0)
        arrowButtonVisibility()
    }
    
    func arrangeProducts() {
        
        addGesture()

        var x:CGFloat = 0
        let itemSize:CGFloat = 130
        let maxItem:CGFloat = 4
        let scrollWidth = productScrollView.bounds.width
        let xgap = (scrollWidth - (itemSize*maxItem))/2
        
        var itemCount:Int = 0
        
        totalPage = (Int(products.count) / Int(maxItem)) + ((Int(products.count) % Int(maxItem) == 0) ? 0 : 1)
        arrowButtonVisibility()
        
        if Int(products.count-itemCount) >= Int(maxItem){
            x += xgap
        } else {
            let newXgap = (scrollWidth - (itemSize*CGFloat(products.count-itemCount)))/2
            x += newXgap
        }
        
        for product in products {
            itemCount += 1
            
            let newView = self.productView.copyView()
            newView.frame.origin.x = x
            newView.setProduct(product: product)
            self.productScrollView.addSubview(newView)
            self.productsViewObjArr.append(newView)
            
            x += itemSize
            if Int(itemCount) % Int(maxItem) == 0 {
                x += xgap
                if Int(products.count-itemCount) >= Int(maxItem){
                    x += xgap
                } else {
                    let newXgap = (scrollWidth - (itemSize*CGFloat(products.count-itemCount)))/2
                    x += newXgap
                }
            }
        }
  
        productScrollView.contentSize = CGSize.init(width: x+itemSize, height: itemSize)
    }
    
   
    @IBAction func previousProduct(_ sender: UIButton) {
        if currentPage > 0 {
            currentPage -= 1
            arrowButtonVisibility()
        }
        changePage()
    }
    
    
    @IBAction func nextproduct(_ sender: UIButton) {
        if currentPage < totalPage-1 {
            currentPage += 1
            arrowButtonVisibility()
        }
        changePage()
    }
    
    func changePage() {
        let x = CGFloat(currentPage) * productScrollView.frame.size.width
        productScrollView.setContentOffset(CGPoint(x:x, y:0), animated: true)
    }
    
    func subscribeForProductSelect(callBack: @escaping (ProductView)->Void) {
        self.productSelectCallback = callBack
    }
    
    func addGesture() {
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(productSelect(sender:)))
        tapGesture.numberOfTapsRequired = 2
        tapGesture.cancelsTouchesInView = false
        self.addGestureRecognizer(tapGesture)
    }
    
    func productSelect(sender:UITapGestureRecognizer) {
        currentProductView = nil
        
        let location = sender.location(in: self)
        for productView in productsViewObjArr {
            let rect = productScrollView.convert(productView.frame, to: self)
            if rect.contains(location){
                currentProductView = productView
                break
            }
        }
        
        if currentProductView != nil && self.productSelectCallback != nil {
            self.productSelectCallback!(currentProductView!)
        }
    }
    
  
  
}
