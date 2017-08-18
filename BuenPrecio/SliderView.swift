//
//  SliderView.swift
//  BuenPrecio
//
//  Created by Ignis IT  on 09/08/17.
//  Copyright © 2017 ignisit. All rights reserved.
///Users/sanjay/Desktop/BuenPrecio/BuenPrecio/SliderView.swift:24:7: Type 'SliderView' does not conform to protocol 'UITableViewDataSource'

import UIKit
import FirebaseAuth

protocol sliderNavigationDelegate: class {
    func swipeMenuOnTouchEnded(valStr: NSString)
}

class SliderView: UIView, UITableViewDataSource, UITableViewDelegate {
    
    var backGroundView: UIView!
    var frontView: UIView!
    var tableV: UITableView!
    var frontViewX: CGFloat!
    var frm: CGRect!
    
    public var swipMenuDelegate: sliderNavigationDelegate?
    
    var commonC = CommonClass.sharedInstan()
    
    var loggedOutMenuList: NSArray  = [
        ["name":"Inicio", "id":"home", "image":"home"],
        ["name":"Inicio Sesión/Regístrate", "id":"login", "image":"user", "controller": "LoginViewController"],
        ["name":"Contactar", "id":"contact_us", "image":"phone", "controller": ""],
        ["name":"Términos y Condiciones", "id":"terms", "image":"help", "controller": ""]
    ]
    var loggedInMenuList: NSArray   = [
        ["name":"Inicio", "id":"home", "image":"home"],
        ["name":"Mi Perfil", "id":"profile", "image":"signed_user", "controller": "ProfileViewController"],
        ["name":"Pedidos", "id":"orders", "image":"shopping-basket-icon", "controller": ""],
        ["name":"Contactar", "id":"contact_us", "image":"phone", "controller": ""],
        ["name":"Cerrar Sesión", "id":"logout", "image":"logout"],
        ["name":"Términos y Condiciones", "id":"terms", "image":"help", "controller": ""]
    ]
    
    
    
    static var slider : SliderView? = nil
    static func sharedLoader() -> SliderView {
        if SliderView.slider == nil {
            SliderView.slider = SliderView.init()
        }
        return SliderView.slider!
    }
    
    func initSlider(rect: CGRect) {
        
        frm = CGRect.init(x: rect.origin.x, y: 56, width: rect.size.width, height: rect.size.height)
        self.frame = frm
        self.backgroundColor = UIColor.clear
        
        if frontView == nil {
            frontView = UIView.init()
        }
        if tableV == nil {
            tableV = UITableView.init()
        }
        frontViewX = (rect.size.width * 2)/5
        frontView.frame = CGRect.init(x: 0, y: 0, width: (rect.size.width * 2)/5, height: frame.size.height)
        frontView.backgroundColor = UIColor.init(red: 93/255, green: 174/255, blue: 49/255, alpha: 1.0)
        
        tableV.frame = CGRect.init(x: 0, y: 0, width: frontView.frame.size.width, height: frontView.frame.size.height)
        tableV.backgroundColor = UIColor.clear
        tableV.delegate = self
        tableV.dataSource = self
        
        tableV.separatorStyle = UITableViewCellSeparatorStyle.none
        
        
        frontView.addSubview(tableV)
        self.addSubview(frontView)
    }
    
    
    func getMenuItemArr() -> NSArray {
        return ((Auth.auth().currentUser != nil) && (Auth.auth().currentUser?.isEmailVerified)!) ? loggedInMenuList : loggedOutMenuList
    }
    
  
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getMenuItemArr().count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let menuId = ((getMenuItemArr().object(at: indexPath.row) as? NSDictionary)?.value(forKey: "id") as! String)
        
        if menuId == "logout" || menuId == "home" {
            UIView.animate(withDuration: 0.25, animations: {
                self.transform = CGAffineTransform.init(translationX: -((self.frontViewX * 2.5) + 56), y: 0)
            }, completion: { (success) in
                self.commonC.isSliderRemove = true
            })
            if menuId == "logout" {
                Login.shared.signOut()
            }
        }
        else {
            if let controller = ((getMenuItemArr().object(at: indexPath.row) as? NSDictionary)?.value(forKey: "controller") as? String) {
                UIView.animate(withDuration: 0.25, animations: {
                    self.transform = CGAffineTransform.init(translationX: -((self.frontViewX * 2.5) + 56), y: 0)
                }, completion: { (success) in
                    self.commonC.isSliderRemove = true
                    if controller.characters.count > 0 {
                        self.swipMenuDelegate?.swipeMenuOnTouchEnded(valStr: controller as NSString)
                    }
                })
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "Cell")
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        if commonC.selectedIndex == indexPath.row {
            cell.backgroundColor = UIColor.init(red: 248/255, green: 215/255, blue: 29/255, alpha: 1.0)
        }
        else {
            cell.backgroundColor = UIColor.clear
        }
        
        let icon = UIImageView.init(frame: CGRect.init(x: 24, y: 17, width: 16, height: 16))
        icon.backgroundColor = UIColor.clear
        icon.image = UIImage.init(named: (getMenuItemArr().object(at: indexPath.row) as? NSDictionary)?.value(forKey: "image") as! String)
        
        let titleStr = UILabel.init(frame: CGRect.init(x: 50, y: 10, width: cell.frame.size.width - 50, height: 30))
        titleStr.backgroundColor = UIColor.clear
        titleStr.textColor = UIColor.white
        titleStr.font = UIFont.systemFont(ofSize: 14)
        titleStr.text = ((getMenuItemArr().object(at: indexPath.row) as? NSDictionary)?.value(forKey: "name") as! String)
        
        cell.addSubview(icon)
        cell.addSubview(titleStr)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    var startinpoint: CGFloat = 0.0
    var minimumPoint: CGFloat = 0.0
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        let touch: UITouch = touches.first!
        let point: CGPoint = touch.location(in: self)
        startinpoint = point.x
        minimumPoint = startinpoint
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        let touch: UITouch = touches.first!
        let point: CGPoint = touch.location(in: self)
        let xNewpoint: CGFloat = point.x
        
        if xNewpoint < startinpoint {
            print("*****************")
            print(startinpoint)
            print("/////////////////")
            print(xNewpoint)
            print("$$$$$$$$$$$$$$$$$")
            let diff: CGFloat = xNewpoint - startinpoint
            
            print(diff)
            
            if diff > (-frontViewX) {
                frontView.transform = CGAffineTransform.init(translationX: diff, y: 0)
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        
        let touch: UITouch = touches.first!
        let point: CGPoint = touch.location(in: self)
        let xNewpoint: CGFloat = point.x
        let diff: CGFloat = startinpoint - xNewpoint
        
        if (xNewpoint < startinpoint) && diff > frontView.frame.size.height/2 {
            UIView.animate(withDuration: 0.2, animations: {
                self.frontView.transform = CGAffineTransform.init(translationX: -self.frontViewX, y: 0)
                
            }, completion: { (success) in
                self.commonC.isSliderRemove = true
                self.removeFromSuperview()
            })
        }
        else {
            self.commonC.isSliderRemove = false
            frontView.transform = CGAffineTransform.init(translationX: 0, y: 0)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        let touch: UITouch = touches.first!
        let point: CGPoint = touch.location(in: self)
        let xNewpoint: CGFloat = point.x
        let diff: CGFloat = startinpoint - xNewpoint
        
        if (xNewpoint < startinpoint) && diff > frontView.frame.size.height/2 {
            UIView.animate(withDuration: 0.2, animations: {
                self.frontView.transform = CGAffineTransform.init(translationX: -self.frontViewX, y: 0)
                
            }, completion: { (success) in
                self.commonC.isSliderRemove = true
                self.removeFromSuperview()
            })
        }
        else {
            self.commonC.isSliderRemove = false
            frontView.transform = CGAffineTransform.init(translationX: 0, y: 0)
        }
    }
}
