//
//  Extensions.swift
//  CaffeNapoli
//
//  Created by Kev1 on 10/6/17.
//  Copyright © 2017 Kev1. All rights reserved.
//

import UIKit
extension UIColor {
    static func rgb(displayP3Red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
       return UIColor(displayP3Red: displayP3Red/255, green: green/255, blue: blue/255, alpha: 1)
        
    }
    
}
