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
    static func facebookBlue() -> UIColor {
        return UIColor.rgb(displayP3Red: 67, green: 103, blue: 178)
        
    }

    static func tabBarBlue() -> UIColor {
        return UIColor.rgb(displayP3Red: 46, green: 76, blue: 88)
        
    }
    static func NavBarYellow() -> UIColor {
        return UIColor.rgb(displayP3Red: 211, green: 203, blue: 145)
        
    }
    static func cellBGColor() -> UIColor {
        return UIColor.rgb(displayP3Red: 230, green: 225, blue: 197)
        
    }
    static func tabBarButtonColor() -> UIColor {
        return UIColor.rgb(displayP3Red: 188, green: 211, blue: 241)
        
    }
    
    static func cellButtonsColor() -> UIColor {
        return UIColor.rgb(displayP3Red: 127, green: 163, blue: 236)
        
    }
    
    static func napoliGold() -> UIColor {
        return UIColor.rgb(displayP3Red: 138, green: 118, blue: 76)
    }
    static func napoliGreen() -> UIColor {
        return UIColor.rgb(displayP3Red: 2, green: 144, blue: 72)
    }
    
    static func mainBlue() -> UIColor {
        
        return UIColor.rgb(displayP3Red: 17, green: 154, blue: 237)
       
        
    }
    static func buttonUnselected() -> UIColor {
        return UIColor(white: 0, alpha: 0.2)
        
    }
    
}

extension Date {
    func timeAgoDisplay() -> String {
        let secondsAgo = Int(Date().timeIntervalSince(self))
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        let month = 4 * week
        
        let quotient: Int
        let unit: String
        if secondsAgo < minute {
        quotient = secondsAgo
            unit = "second"
        } else if secondsAgo < hour {
           quotient = secondsAgo / minute
            unit = "min"
            
        } else if secondsAgo < day {
            quotient = secondsAgo / hour
            unit = "hour"
        } else if secondsAgo < week {
            quotient = secondsAgo / day
            unit = "day"
            
        } else if secondsAgo < month {
            quotient = secondsAgo / week
            unit = "week"
            
        } else  {
            quotient = secondsAgo / month
            unit = "month"
            
        }
        return "\(quotient) \(unit)\(quotient == 1 ? "" : "s") ago"
        
    }
}

extension UIImage {
    func imageWithInsets(insets: UIEdgeInsets) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(
            CGSize(width: self.size.width + insets.left + insets.right,
                   height: self.size.height + insets.top + insets.bottom), false, self.scale)
        let _ = UIGraphicsGetCurrentContext()
        let origin = CGPoint(x: insets.left, y: insets.top)
        self.draw(at: origin)
        let imageWithInsets = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return imageWithInsets
    }
}

