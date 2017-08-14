//
//  ViewController.swift
//  BuenPrecio
//
//  Created by ignisit on 8/5/17.
//  Copyright © 2017 ignisit. All rights reserved.
// 

import UIKit

class ViewController: UIViewController, sliderNavigationDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet var menuBtn: UIButton!
    @IBOutlet var searchBtn: UIButton!
    @IBOutlet var leftArrowBtn: UIButton!
    @IBOutlet var rightArrowBtn: UIButton!
    @IBOutlet var productDetailView: UIView!
    @IBOutlet var firstProduct: UIView!
    @IBOutlet var secondProduct: UIView!
    @IBOutlet var thirdProduct: UIView!
    @IBOutlet var forthProduct: UIView!
    @IBOutlet var closePopUpBtn: UIButton!
    
    var slider: SliderView!
    var commonC = CommonClass.sharedInstan()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        slider = SliderView.sharedLoader()
        let frm = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
        self.slider.initSlider(rect: frm)
        self.slider.transform = CGAffineTransform.init(translationX: -(self.view.frame.size.width + 56), y: 0)
        self.slider.swipMenuDelegate = self
        self.view.addSubview(slider)
        
        let firsttapGR = UITapGestureRecognizer(target: self, action: #selector(showFirstProductDetail))
        firsttapGR.delegate = self
        firsttapGR.numberOfTapsRequired = 2
        firstProduct.addGestureRecognizer(firsttapGR)
        
        let secondtapGR = UITapGestureRecognizer(target: self, action: #selector(showSecondProductDetail))
        secondtapGR.delegate = self
        secondtapGR.numberOfTapsRequired = 2
        secondProduct.addGestureRecognizer(secondtapGR)
        
        let thirdtapGR = UITapGestureRecognizer(target: self, action: #selector(showThirdProductDetail))
        thirdtapGR.delegate = self
        thirdtapGR.numberOfTapsRequired = 2
        thirdProduct.addGestureRecognizer(thirdtapGR)
        
        let forthtapGR = UITapGestureRecognizer(target: self, action: #selector(showForthProductDetail))
        forthtapGR.delegate = self
        forthtapGR.numberOfTapsRequired = 2
        forthProduct.addGestureRecognizer(forthtapGR)
        
        closePopUpBtn.layer.cornerRadius = closePopUpBtn.frame.size.height/2
        closePopUpBtn.layer.masksToBounds = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        productDetailView.frame = self.view.bounds
        productDetailView.isHidden = true
        self.view.addSubview(productDetailView)
        
    }
    
    func showFirstProductDetail() {
        productDetailView.isHidden = false
    }
    
    func showSecondProductDetail() {
        productDetailView.isHidden = false
    }
    
    func showThirdProductDetail() {
        productDetailView.isHidden = false
    }
    
    func showForthProductDetail() {
        productDetailView.isHidden = false
    }
    
    func firstProductLongGes() {
        
    }
    
    
    @IBAction func closeProductDetailPage(_ sender: UIButton) {
        productDetailView.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickMenubtn(_ sender: UIButton) {
        menuBtn.isSelected = !menuBtn.isSelected
        if self.commonC.isSliderRemove {
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
}

