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
            productImages.append(UIImage(named: "p\(i)")!)
        }
        let product1 = Product(uid: "875942-100", name: "Margherita", images: productImages, price: 25, description: "The pizza Margherita is just over a century old and is named after HM Queen Margherita of Italy, wife of King Umberto I and first Queen of Italy. It's made using toppings of tomato, mozzarella cheese, and fresh basil, which represent the red, white, and green of the Italian flag..", detail: "Calzone means 'stocking' in Italian and is a turnover that originates from Italy. Shaped like a semicircle, the calzone is made of dough folded over and filled with the usual pizza ingredients.")
        products.append(product1)
        
        // 2
        var product2Images = [UIImage]()
        for i in 1...7 {
            product2Images.append(UIImage(named: "o\(i)")!)
        }
        let product2 = Product(uid: "880843-003", name: "Natural Olive Oil", images: product2Images, price: 30, description: "Rich, beautiful, and fragrant, olive oil is much like wine -- taste is a matter of personal preference. The many variables that go into the production of olive oil yield dramatic differences in color, aroma, and flavor. And several names are used to differentiate all of these versions, which you'll learn about here.", detail: "Because of olive oil's high monounsaturated fat content, it can be stored longer than most other oils -- as long as it's stored properly. Oils are fragile and need to be treated gently to preserve their healthful properties and to keep them from becoming a health hazard full of free radicals..")
        products.append(product2)
        
        
        // 3
        var product3Images = [UIImage]()
        for i in 1...6 {
            product3Images.append(UIImage(named: "w\(i)")!)
        }
        let product3 = Product(uid: "384664-113", name: "Essenzia di Caiarossa Rosso di Toscano IGT", images: product3Images, price: 107, description: "Beginning in 2009, Caiarossa decided to make a special red blend in select extraordinary vintages — 2009, 2011 and 2012 thus far — that would show the “essence” of their estate. The current release, 2009, is ripe and rich with dark fruits and earthy syrah flavors. But if you plan to carry a bottle back with you, bring a large suitcase; Essenzia is only sold in magnums.", detail: "This winery is well-known in the US for its extraordinary nebbiolo reds, but even the Marchesi’s other wines are hardly ordinary. Its chardonnay from the Langhe region is made in stainless steel but gains additional texture and flavors through extended time on its lees, the pieces of grapes and spent yeast cells that drop to the bottom after fermentation..")
        products.append(product3)
        
        // 4
        var product4Images = [UIImage]()
        for i in 1...6 {
            product4Images.append(UIImage(named: "to\(i)")!)
        }
        let product4 = Product(uid: "805144-852", name: "REAL AUTHENTIC ITALIAN TOMATO SAUCE", images: product4Images, price: 20, description: "Bolognese-- rich meat sauce flavored with chicken livers, wine, vegetables and nutmeg. Served with butter and grated cheese; sometimes cream is added to the sauce. Also called ragu in parts of Italy other than Bologna;", detail: "This homemade spaghetti sauce recipe was passed down from my Sicilian grandma. It has been used for generations and you can't mess it up! It is really easy and tastes SO much better than the store bought sauce. You can do this in a crockpot too – in fact it is one of our favorite dump recipes.")
        products.append(product4)
        
        return products
    }
}

























