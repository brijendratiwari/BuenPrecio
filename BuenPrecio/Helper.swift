//
//  Helper.swift
//  BuenPrecio
//
//  Created by ignisit on 8/14/17.
//  Copyright © 2017 ignisit. All rights reserved.
//

import UIKit

class Helper: NSObject {
    
    public func toBool(_ val:Any?) -> Bool!{
        if let boolVal = val as? Bool {
            return boolVal
        } else if let strVal = val as? NSString {
            return strVal.boolValue
        }
        return false
    }

}

let HELPER = Helper.init()
