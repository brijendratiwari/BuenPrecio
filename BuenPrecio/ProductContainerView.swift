//
//  ProductCollectionView.swift
//  BuenPrecio
//
//  Created by ignisit on 8/16/17.
//  Copyright © 2017 ignisit. All rights reserved.
//

import UIKit


class ProductContainerView: UIView  {
    public enum ContainerType {
        case OneLine
        case TwoLine
    }
    private let DRAWER_TAG_1 = 111
    private let DRAWER_TAG_2 = 112
    
    
    var containerType:ContainerType? = ContainerType.OneLine
    
    @IBOutlet var productScrollView: UIScrollView!
    
    
    
    @IBOutlet var leftArrowBtn: UIButton!
    @IBOutlet var rightArrowBtn: UIButton!
    
    
    public var products:Array<Product>! = []
    public var productsViewObjArr:Array<ProductView>! = []
    public var mainView:UIView!
    public var cartView: UIView?
    
    private var currentPage = 0
    private var totalPage = 1
    
    private var currentProductView:ProductView?
    private var movedProductView:ProductView?
    
    private var productSelectCallback:((ProductView)->Void)?
    private var productViewCallback:((ProductView)->Void)?
    private var productMoveDownCallback:((ProductView)->Void)?

    private var isSwipeDown:Bool = false
    
    private var moveProductInProgress:Bool = false
    
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
        movedProductView = nil
        currentPage = 0
        totalPage = 1
        productScrollView.setContentOffset(CGPoint(x:0, y:0), animated: false)
        productScrollView.contentSize = CGSize.init(width: 0, height: 0)
        arrowButtonVisibility()
        
        addGesture()

    }
    
    func arrangeProducts() {
        if let imgView = productScrollView.superview?.viewWithTag(DRAWER_TAG_1) {
            imgView.removeFromSuperview()
        }
        if let imgView = productScrollView.superview?.viewWithTag(DRAWER_TAG_2) {
            imgView.removeFromSuperview()
        }
        
        
        var x:CGFloat = 0
        var y:CGFloat = 0
        
        var itemSize:CGFloat = 110
        let maxItem:CGFloat = 4
        let maxRow:CGFloat = (containerType == ContainerType.OneLine ? 1 : 2)
        let verticalItemGap:CGFloat = 10
        var topYGap:CGFloat = 0
        
        let scrollWidth = productScrollView.bounds.width
        let scrollHeight = productScrollView.bounds.height
        
        
        var itemHGap:CGFloat = 0
        
        if scrollWidth < 500 {
            itemSize = (containerType == ContainerType.OneLine ? 120 : 95)
        } else {
            itemSize = (containerType == ContainerType.OneLine ? 140 : 110)
           itemHGap = 15
        }
        topYGap = (scrollHeight - (itemSize*maxRow))/2
        
        let xgap = (scrollWidth - (itemSize*maxItem) - (itemHGap*(maxItem-1)))/2
        
        
        var itemCount:Int = 0
        
        totalPage = (Int(products.count) / Int(maxItem*maxRow)) + ((Int(products.count) % Int(maxItem*maxRow) == 0) ? 0 : 1)
        arrowButtonVisibility()
        
        x = xgap
        y = topYGap
        
        var rowCount:CGFloat = 0
        
        
        let hspace:CGFloat = 0
        let bottomSpace:CGFloat = 0
        let drawerHeight = itemSize / 2 + 10
        
        let drawerImgView1 = UIImageView.init(frame: CGRect.init(x: (productScrollView.frame.origin.x) + hspace, y: (productScrollView.frame.origin.y) + topYGap+(itemSize - drawerHeight - bottomSpace), width: scrollWidth - (hspace*2), height: drawerHeight))
        drawerImgView1.image = UIImage.init(named: "drawer.png")
        let drawerImgView2 = UIImageView.init(frame: CGRect.init(x: (productScrollView.frame.origin.x) + hspace, y: (productScrollView.frame.origin.y) + (topYGap + itemSize + verticalItemGap) + (itemSize - drawerHeight - bottomSpace), width: scrollWidth - (hspace*2), height: drawerHeight))
        drawerImgView2.image = UIImage.init(named: "drawer.png")
        drawerImgView1.tag = DRAWER_TAG_1
        drawerImgView2.tag = DRAWER_TAG_2
        
        
        productScrollView.superview?.addSubview(drawerImgView1)
        if containerType == ContainerType.TwoLine {
            productScrollView.superview?.addSubview(drawerImgView2)
        }
        productScrollView.superview?.bringSubview(toFront: productScrollView)
        
        for product in products {
            itemCount += 1
            
            if let newView = Util.shared.viewsHolder?.productView.copyView() {
                newView.frame.origin.x = x
                newView.frame.origin.y = y
                newView.frame.size.width = itemSize
                newView.frame.size.height = itemSize
                
                newView.setProduct(product: product)
                self.productScrollView.addSubview(newView)
                self.productsViewObjArr.append(newView)
            }
            
            x += itemSize
            
            if Int(itemCount) % Int(maxItem) == 0 {
                rowCount += 1
                
                if rowCount >= maxRow {
                    //                        let drawerImgView1 = UIImageView.init(frame: CGRect.init(x: (x + xgap + hspace), y: topYGap+(itemSize - drawerHeight - bottomSpace), width: scrollWidth - (hspace*2), height: drawerHeight))
                    //                        drawerImgView1.image = UIImage.init(named: "drawer.png")
                    //                        let drawerImgView2 = UIImageView.init(frame: CGRect.init(x: (x + xgap + hspace), y: topYGap + itemSize + verticalItemGap + (itemSize - drawerHeight - bottomSpace), width: scrollWidth - (hspace*2), height: drawerHeight))
                    //                        drawerImgView2.image = UIImage.init(named: "drawer.png")
                    //                        productScrollView.addSubview(drawerImgView1)
                    //                        productScrollView.addSubview(drawerImgView2)
                    
                    rowCount = 0
                    y = topYGap
                    x += xgap*2
                    
                    
                    
                } else {
                    y = y + itemSize + verticalItemGap
                    x = x - ((itemSize*maxItem) + (itemHGap*(maxItem-1)))
                }
            } else {
                x += itemHGap
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
    
    func subscribeForProductView(callBack: @escaping (ProductView)->Void) {
        self.productViewCallback = callBack
    }
    
    func subscribeForProductMoveDown(callBack: @escaping (ProductView)->Void) {
        self.productMoveDownCallback = callBack
    }
    
    
    func addGesture() {
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(productView(sender:)))
        tapGesture.numberOfTapsRequired = 2
        tapGesture.cancelsTouchesInView = false
        self.addGestureRecognizer(tapGesture)
        
        let longPressGesture = UILongPressGestureRecognizer.init(target: self, action: #selector(productView(sender:)))
        longPressGesture.minimumPressDuration = 0.5
        longPressGesture.cancelsTouchesInView = false
        self.addGestureRecognizer(longPressGesture)
        
        let swipeGesture = UISwipeGestureRecognizer.init(target: self, action: #selector(productMoved(sender:)))
        swipeGesture.direction = UISwipeGestureRecognizerDirection.down
        swipeGesture.cancelsTouchesInView = false
        self.addGestureRecognizer(swipeGesture)
    }
    
    func productSelect(sender:UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.began {
            
            print("Product select")
            
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
    
    func productView(sender:UITapGestureRecognizer) {
        
        let location = sender.location(in: self)
        for productView in productsViewObjArr {
            let rect = productScrollView.convert(productView.frame, to: self)
            if rect.contains(location){
                currentProductView = productView
                break
            }
        }
        
        if currentProductView != nil && self.productViewCallback != nil {
            self.productViewCallback!(currentProductView!)
        }
    }
    
    func productMoved(sender: UISwipeGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.ended {
            
            let location = sender.location(in: self)
            for productView in productsViewObjArr {
                let rect = productScrollView.convert(productView.frame, to: self)
                if rect.contains(location){
                    self.isSwipeDown = true
                    break
                }
            }
            
            
        }
        
        print("Swipe Gesture")
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        print("touchesBegan")
        
        var viewFound:ProductView? = nil
        
        let location = touches.first?.location(in: self)
        for productView in productsViewObjArr {
            let rect = productScrollView.convert(productView.frame, to: self)
            if rect.contains(location!){
                viewFound = productView
                break
            }
        }
        
        if viewFound != nil && !moveProductInProgress{
            moveProductInProgress = true
            currentProductView = viewFound
            movedProductView = currentProductView?.copyView()
            currentProductView?.alpha = 0
            let rectByMainView = currentProductView?.superview?.convert((movedProductView?.frame)!, to: mainView)
            movedProductView?.frame = rectByMainView!
            mainView.addSubview(movedProductView!)
            movedProductView?.pickAnimation()
            
            if self.productSelectCallback != nil {
                self.productSelectCallback!(currentProductView!)
            }

        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        if moveProductInProgress {
            if isSwipeDown {
                isSwipeDown = false
                movedProductView?.moveToCartAnimation(cartView: cartView!, callBack: { () in
                    self.movedProductView?.removeFromSuperview()
                    self.movedProductView = nil
                    self.currentProductView?.alpha = 1
                    self.currentProductView?.leaveAnimation {
                        if self.currentProductView != nil && self.productMoveDownCallback != nil {
                            self.productMoveDownCallback!(self.currentProductView!)
                        }
                        self.moveProductInProgress = false
                    }
                })
            } else if (currentProductView != nil) {
                movedProductView?.leaveAnimation {
                    self.movedProductView?.removeFromSuperview()
                    self.currentProductView?.alpha = 1
                    self.movedProductView = nil
                    self.moveProductInProgress = false
                }
            }
        }
    }
}
