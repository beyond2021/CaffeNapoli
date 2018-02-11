//
//  ProductDetailMoreCell.swift
//  CaffeNapoli
//
//  Created by Kev1 on 1/20/18.
//  Copyright © 2018 Kev1. All rights reserved.
//

import UIKit

class ProductDetailMoreCell: UITableViewCell {
    let productDetailsLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.init(name: "Avenir Next Condensed Demi Bold", size: 15)
        label.text = "PRODUCT DETAILS"
        label.textColor = UIColor.tabBarBlue()
        return label
    }()
    let rightArrowImageView : CustomImageView = {
        let iv = CustomImageView()
        iv.image = #imageLiteral(resourceName: "forward-50")
        return iv
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(productDetailsLabel)
       
//        rightArrowImageView.anchor(top: nil, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: 36, height: 36)
//
        
        
        
        productDetailsLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 16, paddingLeft: 12, paddingBottom: 16.5, paddingRight: 0, width: 101.5, height: 0)
        
    }
    
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//            addSubview(productDetailsLabel)
//        addSubview(rightArrowImageView)
//        rightArrowImageView.anchor(top: nil, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: 36, height: 36)
//        
//        
//        
//        
//            productDetailsLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 16, paddingLeft: 12, paddingBottom: 16.5, paddingRight: 0, width: 101.5, height: 0)
//    
//        
//    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
