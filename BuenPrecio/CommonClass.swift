//
//  CommonClass.swift
//  BuenPrecio
//
//  Created by Ignis IT  on 10/08/17.
//  Copyright © 2017 ignisit. All rights reserved.
//

import UIKit

class CommonClass: NSObject {
    
    public var selectedIndex: NSInteger = 0
    public var isSliderRemove: Bool = true
    
    static var common : CommonClass? = nil
    static func sharedInstan() -> CommonClass {
        if CommonClass.common == nil {
            CommonClass.common = CommonClass.init()
        }
        return CommonClass.common!
    }

}
