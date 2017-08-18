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
    
    @IBOutlet var menuBtn: UIButton!
    @IBOutlet var searchBtn: UIButton!
    @IBOutlet var leftArrowBtn: UIButton!
    @IBOutlet var rightArrowBtn: UIButton!
    @IBOutlet weak var prevcatLbl: UILabel!
    @IBOutlet weak var currentCatLbl: UILabel!
    @IBOutlet weak var currentCatFld: UITextField!
    @IBOutlet weak var nextCatLbl: UILabel!

    @IBOutlet var productDetailView: ProductDetailView!
    @IBOutlet var firstProduct: UIView!
    @IBOutlet var secondProduct: UIView!
    @IBOutlet var thirdProduct: UIView!
    @IBOutlet var forthProduct: UIView!
    
    
    @IBOutlet weak var productContainerView: ProductContainerView!
    
    @IBOutlet weak var productContainerViewHeight: NSLayoutConstraint!
    
    
    var slider: SliderView!
    var commonC = CommonClass.sharedInstan()
    var catPicker: UIPickerView!
    
    var currentCategoryIndex = -1
    var allCategories = [Category]()
    

    var handle:AuthStateDidChangeListenerHandle?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
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
        ReadData.shared.getCategories { (categories) in
            SwiftLoader.hide()
            
            if categories.count > 0 {
                self.allCategories = categories
                if self.currentCategoryIndex == -1 {
                    self.currentCategoryIndex = self.allCategories.count/2
                    self.updateCategoryViewer(animate: false)
                    self.currentCatFld.inputView = self.catPicker
                }
            }
        }
        
    }
    @IBAction func showCatList(_ sender: Any) {
        currentCatFld.becomeFirstResponder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        productDetailView.frame = self.view.bounds
        productDetailView.isHidden = true
        self.view.addSubview(productDetailView)
        
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
        
        currentCatFld.text = allCategories[currentCategoryIndex].name
        currentCatLbl.text = allCategories[currentCategoryIndex].name
        UIView.animate(withDuration: animateTime, animations: {
            self.currentCatView(visible: true)
        })
        
        productContainerView.resetData()
        
        SwiftLoader.show(animated: true)

        ReadData.shared.getProducts(forCategory: allCategories[currentCategoryIndex].name) { (products) in
            SwiftLoader.hide()
            
            self.productContainerView.products = products
            self.productContainerView.arrangeProducts()
            self.productContainerView.subscribeForProductSelect(callBack: { (productView) in
                self.productDetailView.showProduct(product: productView.product)
            })
        }
    }
    
    @IBAction func previouscategory(_ sender: Any) {
        if self.currentCategoryIndex > 0 {
            self.currentCategoryIndex -= 1
            updateCategoryViewer(animate: true)
        }
    }
    
    
    @IBAction func nextCategory(_ sender: Any) {
        if self.currentCategoryIndex < (allCategories.count-1) {
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
                
                self.searchBtn.isUserInteractionEnabled = false
                self.leftArrowBtn.isUserInteractionEnabled = false
                self.rightArrowBtn.isUserInteractionEnabled = false
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
    
    func swipeMenuOnTouchEnded(valStr: NSString) {
        let vc: UIViewController = (self.storyboard?.instantiateViewController(withIdentifier: valStr as String))!
        self.navigationController?.pushViewController(vc, animated: true)
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
    
}

