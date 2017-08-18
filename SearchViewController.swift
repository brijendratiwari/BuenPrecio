//
//  SearchViewController.swift
//  BuenPrecio
//
//  Created by Ignis IT  on 12/08/17.
//  Copyright © 2017 ignisit. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate {
    @IBOutlet var exampleLbl: UILabel!
    @IBOutlet var productSearchBar: UISearchBar!
    @IBOutlet var searchResultVwLeadingSpaceConst: NSLayoutConstraint!
    @IBOutlet var productView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        exampleLbl.layer.borderColor = UIColor.white.cgColor
        exampleLbl.layer.borderWidth = 2.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        productView.transform = CGAffineTransform.init(translationX: self.view.frame.size.width + 20, y: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let txtFld: UITextField = productSearchBar.value(forKey: "searchField") as! UITextField
        txtFld.backgroundColor = UIColor.white
        txtFld.textColor = UIColor.init(red: 93/255, green: 174/255, blue: 49/255, alpha: 1.0)
        txtFld.clearButtonMode = UITextFieldViewMode.never
        txtFld.font = UIFont.boldSystemFont(ofSize: 20)
        txtFld.attributedPlaceholder = NSAttributedString.init(string: "¿QUÉ ESTÁS BUSCANDO?", attributes: [NSForegroundColorAttributeName: UIColor.init(red: 93/255, green: 174/255, blue: 49/255, alpha: 1.0)])
        txtFld.frame = productSearchBar.bounds
        txtFld.layer.borderWidth = 0.0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        
//        productView.isHidden = false
//        UIView.animate(withDuration: 1.25, animations: {
//            self.productView.transform = CGAffineTransform.init(translationX: 0, y: 0)
//        })
        
        if let searchText = searchBar.text, (searchBar.text?.characters.count)! > 0 {
            productSearchBar.endEditing(true)
            let vc: SearchResultViewController = (self.storyboard?.instantiateViewController(withIdentifier: "SearchResultViewController" as String))! as! SearchResultViewController
            vc.searchString = searchText
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    @IBAction func productSearch(_ sender: UIButton) {
//        productSearchBar.endEditing(true)
//        productView.isHidden = false
//        UIView.animate(withDuration: 0.25, animations: {
//            self.productView.transform = CGAffineTransform.init(translationX: 0, y: 0)
//        })
        
        searchBarSearchButtonClicked(productSearchBar)
    }
    
    @IBAction func gotoHome(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
