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
extension UIView {
    func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?,paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width : CGFloat, height: CGFloat ){
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
            
        }
        
        //        self.topAnchor.constraint(equalTo: top!, constant: paddingTop).isActive = true
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let right = right {
            self.rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
            
        }
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
            
        }
    }
    
}
