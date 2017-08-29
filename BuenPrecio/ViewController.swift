//
//  ViewController.swift
//  BuenPrecio
//
//  Created by ignisit on 8/5/17.
//  Copyright © 2017 ignisit. All rights reserved.
//

import UIKit
import SwiftLoader
import FirebaseAuth



class ViewController: UIViewController, sliderNavigationDelegate, UIGestureRecognizerDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var pageBgImg: UIImageView!
    
    @IBOutlet var menuBtn: UIButton!
    @IBOutlet var searchBtn: UIButton!
    @IBOutlet var leftArrowBtn: UIButton!
    @IBOutlet var rightArrowBtn: UIButton!
    @IBOutlet weak var prevcatLbl: UILabel!
    @IBOutlet weak var currentCatLbl: UILabel!
    @IBOutlet weak var currentCatFld: UITextField!
    @IBOutlet weak var nextCatLbl: UILabel!
    
    @IBOutlet var productDetailView: ProductDetailView!
    
    @IBOutlet weak var cartView: UIImageView!
    
    @IBOutlet weak var productContainerView: ProductContainerView!
    
    @IBOutlet weak var productContainerViewHeight: NSLayoutConstraint!
    
    
    
    var slider: SliderView!
    var commonC = CommonClass.sharedInstan()
    var catPicker: UIPickerView!
    
    var currentCategoryIndex = -1
    var allCategories = [Category]()
    var featuredProducts:[Product]?
    
    var handle:AuthStateDidChangeListenerHandle?
    
    
    var isShowFeaturedProduct = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.cartView.isUserInteractionEnabled = true
        let swipeUpgesture = UISwipeGestureRecognizer.init(target: self, action: #selector(cartSelect(sender:)))
        swipeUpgesture.direction = UISwipeGestureRecognizerDirection.up
//        self.cartView.addGestureRecognizer(swipeUpgesture)
            
        Util.shared.viewsHolder = self.storyboard?.instantiateViewController(withIdentifier: "CommonViewsContainController") as? CommonViewsContainController
        Util.shared.homeViewCtrl = self
        
        // category view
        Util.shared.viewsHolder?.categoriesDisplayView.loadData(onView: self.view)
        Util.shared.viewsHolder?.categoriesDisplayView.subscribeFor(subCategorySelect: { (subCategory) in
            for index in  0..<self.allCategories.count {
                let cat = self.allCategories[index]
                if cat.name == subCategory.category {
                    self.currentCategoryIndex = index
                    break
                }
            }
            self.updateCategoryViewer(animate: true, subCategory: subCategory)
        })
        
        // cart View
        Util.shared.viewsHolder?.cartView.loadData(onView: self.view)

        
        self.productContainerView.containerType = ProductContainerView.ContainerType.TwoLine
        self.productContainerView.mainView = self.view
        self.productContainerView.cartView = self.cartView
        
        
        self.productContainerView.subscribeForProductView(callBack: { (productView) in
            self.view.bringSubview(toFront: self.productDetailView)
            self.productDetailView.showProduct(product: productView.product)
        })
        
        
        
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            self.slider.tableV.reloadData()
            
            if (Auth.auth().currentUser != nil) && (Auth.auth().currentUser?.isEmailVerified)! {
                let lastViewController = self.navigationController?.viewControllers.last
                if lastViewController is LoginViewController {
                    self.navigationController?.popViewController(animated: false)
                    //                    let vc: UIViewController = (self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController" as String))!
                    //                    self.navigationController?.pushViewController(vc, animated: false)
                }
                
            }
        }
        
        // Do any additional setup after loading the view, typically from a nib.
        slider = SliderView.sharedLoader()
        let frm = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
        self.slider.initSlider(rect: frm)
        self.slider.transform = CGAffineTransform.init(translationX: -(self.view.frame.size.width + 56), y: 0)
        self.slider.swipMenuDelegate = self
        self.view.addSubview(slider)
        
        
        
        catPicker = UIPickerView.init()
        catPicker.dataSource = self
        catPicker.delegate = self
        
        SwiftLoader.show(animated: true)
        
        ReadData.shared.getAllfeaturedProducts { (products) in
            SwiftLoader.hide()
            self.featuredProducts = products
            
            ReadData.shared.getCategories { (categories) in
                SwiftLoader.hide()
                
                if categories.count > 0 {
                    if self.currentCategoryIndex == -1 {
                        if categories.count > 1 {
                            self.currentCategoryIndex = 1
                        } else {
                            self.currentCategoryIndex = 0
                        }
                    }
                   
                    self.allCategories = categories
                }
                self.updateCategoryViewer(animate: false)
            }
        }
        
       
        
    }
    @IBAction func showCatList(_ sender: Any) {
//        currentCatFld.becomeFirstResponder()
        Util.shared.viewsHolder?.categoriesDisplayView.openView(onView: Util.shared.homeViewCtrl!.view, withAnimation: true)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        productDetailView.frame = self.view.bounds
        productDetailView.isHidden = true
        self.view.addSubview(productDetailView)
        
    }
    
    func cartSelect(sender:UISwipeGestureRecognizer) {
        Util.shared.viewsHolder?.cartView.openView(onView: self.view, withAnimation: true)
        
    }
    
    
    deinit {
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == currentCatFld {
            if textField.text?.characters.count == 0 {
                catPicker.selectRow(0, inComponent: 0, animated: true)
            }
            else {
                catPicker.selectRow(currentCategoryIndex , inComponent: 0, animated: true)
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.allCategories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.allCategories[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentCategoryIndex = row
        self.updateCategoryViewer(animate: false)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Category Manage
    func currentCatView(visible:Bool) {
        self.currentCatLbl.alpha = CGFloat(visible ? 1 : 0)
    }
    
    func previousCatView(visible:Bool) {
        self.prevcatLbl.alpha = CGFloat(visible ? 1 : 0)
        self.leftArrowBtn.alpha = CGFloat(visible ? 1 : 0)
    }
    
    func nextCatView(visible:Bool) {
        self.nextCatLbl.alpha = CGFloat(visible ? 1 : 0)
        self.rightArrowBtn.alpha = CGFloat(visible ? 1 : 0)
    }
    
    func updateCategoryViewer(animate:Bool) {
            self.updateCategoryViewer(animate: animate, subCategory: nil)
    }
    
    func updateCategoryViewer(animate:Bool, subCategory:SubCategory?) {
        if isShowFeaturedProduct {
            self.pageBgImg.image = UIImage.init(named: "home_bg.png")
            self.productContainerView.containerType = ProductContainerView.ContainerType.OneLine
        } else {
            self.pageBgImg.image = UIImage.init(named: "gradientImage.png")
            self.productContainerView.containerType = ProductContainerView.ContainerType.TwoLine
        }
        
        
        let animateTime = animate ? 0.3 : 0
        UIView.animate(withDuration: animateTime, animations: {
            self.previousCatView(visible: false)
            self.nextCatView(visible: false)
            self.currentCatView(visible: false)
        })
        
        if self.currentCategoryIndex > 0 {
            self.prevcatLbl.text = allCategories[currentCategoryIndex-1].name
            UIView.animate(withDuration: animateTime, animations: {
                self.previousCatView(visible: true)
            })
        }
        if self.currentCategoryIndex < (allCategories.count-1) {
            self.nextCatLbl.text = allCategories[currentCategoryIndex+1].name
            UIView.animate(withDuration: animateTime, animations: {
                self.nextCatView(visible: true)
            })
        }
        
        UIView.animate(withDuration: animateTime, animations: {
            self.currentCatView(visible: true)
        })
        
        productContainerView.resetData()
        
        
        
        if isShowFeaturedProduct {
            self.productContainerView.products = featuredProducts!
            self.productContainerView.arrangeProducts()
            currentCatLbl.text = "Productos Destacad"
        } else {
            currentCatLbl.text = allCategories[currentCategoryIndex].name
            
            if subCategory != nil {
                self.productContainerView.products = subCategory?.products
                self.productContainerView.arrangeProducts()
            } else {
                self.productContainerView.products = allCategories[currentCategoryIndex].subCat[0].products
                self.productContainerView.arrangeProducts()
            }
        }
    }
    
    
    @IBAction func previouscategory(_ sender: Any) {
        if self.currentCategoryIndex > 0 {
            isShowFeaturedProduct = false
            self.currentCategoryIndex -= 1
            updateCategoryViewer(animate: true)
        }
    }
    
    
    @IBAction func nextCategory(_ sender: Any) {
        if self.currentCategoryIndex < (allCategories.count-1) {
            isShowFeaturedProduct = false
            self.currentCategoryIndex += 1
            updateCategoryViewer(animate: true)
        }
    }
    
    
    @IBAction func clickMenubtn(_ sender: UIButton) {
        menuBtn.isSelected = !menuBtn.isSelected
        if self.commonC.isSliderRemove {
            self.slider.tableV.reloadData()
            
            UIView.animate(withDuration: 0.25, animations: {
                self.slider.transform = CGAffineTransform.init(translationX: 0, y: 0)
                
                //                self.searchBtn.isUserInteractionEnabled = false
                //                self.leftArrowBtn.isUserInteractionEnabled = false
                //                self.rightArrowBtn.isUserInteractionEnabled = false
                self.commonC.isSliderRemove = false
            })
        }
        else{
            UIView.animate(withDuration: 0.25, animations: {
                self.slider.transform = CGAffineTransform.init(translationX: -(self.view.frame.size.width + 56), y: 0)
                
                self.searchBtn.isUserInteractionEnabled = true
                self.leftArrowBtn.isUserInteractionEnabled = true
                self.rightArrowBtn.isUserInteractionEnabled = true
                self.commonC.isSliderRemove = true
            }, completion: { (success) in
            })
        }
    }
    
    // Slider Menu delegate methods
    func swipeMenuOnTouchEnded(valStr: NSString) {
        let vc: UIViewController = (self.storyboard?.instantiateViewController(withIdentifier: valStr as String))!
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func homeButtonPressed() {
        isShowFeaturedProduct = true
        if allCategories.count > 1 {
            self.currentCategoryIndex = 1
        } else {
            self.currentCategoryIndex = 0
        }
        updateCategoryViewer(animate: true)
    }
    
    @IBAction func openSearchView(_ sender: UIButton) {
        let vc: UIViewController = (self.storyboard?.instantiateViewController(withIdentifier: "SearchViewController"))!
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    // Touches
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
    }
    
}

