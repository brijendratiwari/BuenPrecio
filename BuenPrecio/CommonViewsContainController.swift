//
//  CommonViewsContainController.swift
//  BuenPrecio
//
//  Created by ignisit on 8/23/17.
//  Copyright © 2017 ignisit. All rights reserved.
//

import UIKit

class CommonViewsContainController: UIViewController {

    
    @IBOutlet var categoriesDisplayView: CategoriesDisplayView!
     @IBOutlet var productView: ProductView!
    @IBOutlet weak var categoryView: CategoryView!
    
    @IBOutlet var cartView: CartView!
    @IBOutlet var cartProductView: CartProductView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
