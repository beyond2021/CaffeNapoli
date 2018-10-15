//
//  ProductDetailCell.swift
//  CaffeNapoli
//
//  Created by Kev1 on 12/27/17.
//  Copyright © 2017 Kev1. All rights reserved.
//

import UIKit
class ProductDetailCell: UITableViewCell {
    //
    let productNameLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.init(name: "Avenir Next Condensed Demi Bold", size: 15)
        label.text = "PRODUCT DETAILS"
        label.textColor = UIColor.tabBarBlue()
        return label
    }()
    
    let productDescriptionLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.text = "The Nike Air Max 1 Ultra 2.0 Flyknit Men's Shoe updates the iconic original with an ultra-lightweight upper while keeping the plush, time-tested Max Air cushioning."
        label.font = UIFont.init(name: "Avenir Next Regualer ", size: 12)
//        label.textColor = UIColor.rgb(displayP3Red: 104, green: 104, blue: 104)
        label.textColor = UIColor.tabBarBlue()
        return label
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(productNameLabel)
        addSubview(productDescriptionLabel)
        productDescriptionLabel.anchor(top: productNameLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 35, paddingLeft: 8, paddingBottom: 25.5, paddingRight: 8, width: 0, height: 0)
        
        
        productNameLabel.anchor(top: topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 25, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 165, height: 23.5)
        productNameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
    }
    var product: Product? {
        didSet {
            guard let product = product else { return }
            print("product name is:",product.name ?? "")
            self.updateUI()
            
        }
    }
    
    func updateUI()
    {
        guard let product = product else { return }
        productNameLabel.text = product.name
        productDescriptionLabel.text = product.description
    }
    
    
}

