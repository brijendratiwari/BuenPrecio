//
//  SearchResultViewController.swift
//  BuenPrecio
//
//  Created by ignisit on 8/18/17.
//  Copyright © 2017 ignisit. All rights reserved.
//

import UIKit
import SwiftLoader
import Toast_Swift

class SearchResultViewController: UIViewController {

    @IBOutlet weak var productContainerView: ProductContainerView!
    @IBOutlet weak var searchLabel: UILabel!
   var searchString:String?
    
    @IBOutlet weak var cartView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.productContainerView.containerType = ProductContainerView.ContainerType.TwoLine
        
        
        if let searchString = searchString {
            searchLabel.text = searchString
            
            
            
            SwiftLoader.show(animated: true)
            productContainerView.resetData()
            productContainerView.mainView = self.view
            productContainerView.cartView = cartView
            
            ReadData.shared.searchProduct(keyword: searchString) { (products) in
                SwiftLoader.hide()
                
                if products.count == 0 {
//                    self.view.makeToast("Product not available")
                    self.view.makeToast("Producto no disponible", duration: 2, position: ToastPosition.center)
                    
                }
                self.productContainerView.products = products
                self.productContainerView.arrangeProducts()
                self.productContainerView.subscribeForProductSelect(callBack: { (productView) in
//                    self.productContainerView.showProduct(product: productView.product)
                })
            }
        }
        
        // Do any additional setup after loading the view.
    }

    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
