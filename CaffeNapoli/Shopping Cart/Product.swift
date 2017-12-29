//
//  Shoe.swift
//  Nike+Research
//
//  Created by Duc Tran on 3/19/17.
//  Copyright © 2017 Developers Academy. All rights reserved.
//

import UIKit

class Product
{
    var uid: String?
    var name: String?
    var images: [UIImage]?
    var price: Double?
    var description: String?
    var detail: String?
    
    init(uid: String, name: String, images: [UIImage], price: Double, description: String, detail: String)
    {
        self.uid = uid
        self.name = name
        self.images = images
        self.price = price
        self.description = description
        self.detail = detail
    }
    
    class func fetchShoes() -> [Product]
    {
        var products = [Product]()
        
        // 1
        var productImages = [UIImage]()
        for i in 1...8 {
            productImages.append(UIImage(named: "s\(i)")!)
        }
        let product1 = Product(uid: "875942-100", name: "NIKE AIR MAX 1 ULTRA 2.0 FLYKNIT", images: productImages, price: 180, description: "LIGHTER THAN EVER! The Nike Air Max 1 Ultra 2.0 Flyknit Men's Shoe updates the iconic original with an ultra-lightweight upper while keeping the plush, time-tested Max Air cushioning.", detail: "LIGHTER THAN EVER! The Nike Air Max 1 Ultra 2.0 Flyknit Men's Shoe updates the iconic original with an ultra-lightweight upper while keeping the plush, time-tested Max Air cushioning.")
        products.append(product1)
        
        // 2
        var product2Images = [UIImage]()
        for i in 1...7 {
            product2Images.append(UIImage(named: "t\(i)")!)
        }
        let product2 = Product(uid: "880843-003", name: "NIKE FREE RN FLYKNIT 2017", images: product2Images, price: 120, description: "The Nike Free RN Flyknit 2017 Men's Running Shoe brings you miles of comfort with an exceptionally flexible outsole for the ultimate natural ride. Flyknit fabric wraps your foot for a snug, supportive fit while a tri-star outsole expands and flexes to let your foot move naturally.", detail: "The Nike Free RN Flyknit 2017 Men's Running Shoe brings you miles of comfort with an exceptionally flexible outsole for the ultimate natural ride. Flyknit fabric wraps your foot for a snug, supportive fit while a tri-star outsole expands and flexes to let your foot move naturally.")
        products.append(product2)
        
        
        // 3
        var product3Images = [UIImage]()
        for i in 1...6 {
            product3Images.append(UIImage(named: "j\(i)")!)
        }
        let product3 = Product(uid: "384664-113", name: "AIR JORDAN 6 RETRO", images: product3Images, price: 190, description: "The Air Jordan 6 Retro Men's Shoe celebrates a championship heritage with design lines and plush cushioning inspired by the ground-breaking hoops original.", detail: "The Air Jordan 6 Retro Men's Shoe celebrates a championship heritage with design lines and plush cushioning inspired by the ground-breaking hoops original.")
        products.append(product3)
        
        // 4
        var product4Images = [UIImage]()
        for i in 1...6 {
            product4Images.append(UIImage(named: "f\(i)")!)
        }
        let product4 = Product(uid: "805144-852", name: "TECH FLEECE WINDRUNNER", images: product4Images, price: 130, description: "The Nike Sportswear Tech Fleece Windrunner Men's Hoodie is redesigned for cooler weather with smooth, engineered fleece that offers lightweight warmth. Bonded seams lend a modern update to the classic chevron design.", detail: "The Nike Sportswear Tech Fleece Windrunner Men's Hoodie is redesigned for cooler weather with smooth, engineered fleece that offers lightweight warmth. Bonded seams lend a modern update to the classic chevron design.")
        products.append(product4)
        
        return products
    }
}

























