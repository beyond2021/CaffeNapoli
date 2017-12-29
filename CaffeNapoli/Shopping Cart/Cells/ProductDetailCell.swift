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
    let productDetailLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.init(name: "Avenir Next Condensed Demi Bold", size: 15)
        label.text = "PRODUCT DETAILS"
        return label
    }()
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //        backgroundColor = .green
        addSubview(productDetailLabel)
        productDetailLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 16, paddingLeft: 12, paddingBottom: 16.5, paddingRight: 0, width: 101.5, height: 0)
       
        
        
    }
    
}
