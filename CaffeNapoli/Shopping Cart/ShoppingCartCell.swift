//
//  ShoppingCartCell.swift
//  CaffeNapoli
//
//  Created by Kev1 on 12/26/17.
//  Copyright © 2017 Kev1. All rights reserved.
//

import UIKit

class ShoppingCartCell: UICollectionViewCell {
    
    let productImageView : CustomImageView = {
        let iv = CustomImageView ()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .red
        iv.image = #imageLiteral(resourceName: "s1")
        return  iv
        
    }()
    let productNameLabel : UILabel = {
        let label = UILabel()
        label.text = "NIKE FREE RN FLKNIT 2017"
        label.font = UIFont.init(name: "Avenir Next Condensed Regular", size: 16)
        return label
    
    }()
    let productPriceLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.init(name: "Avenir Next Regular ", size: 13)
        label.text = "$120"
        return label
    }()
    
    
    
    
    var product: Product! {
        didSet {
            self.updateUI()
        }
    }
    
    func updateUI()
    {
        productImageView.image = product.images?.first
        productNameLabel.text = product.name
        if let price = product.price {
            productPriceLabel.text = "$\(price)"
        } else {
            productPriceLabel.text = ""
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.rgb(displayP3Red: 227, green: 227, blue: 227)
        addSubview(productImageView)
        addSubview(productNameLabel)
        addSubview(productPriceLabel)
        productPriceLabel.anchor(top: productNameLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 4, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 0, height: 18)
        productNameLabel.anchor(top: productImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 4, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 0, height: 24)
        productImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: frame.width)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
