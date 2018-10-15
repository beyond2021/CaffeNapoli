//
//  CartDetailCell.swift
//  CaffeNapoli
//
//  Created by Kev1 on 1/1/18.
//  Copyright © 2018 Kev1. All rights reserved.
//

import UIKit
class CartDetailCell: UITableViewCell {
    
    let subTotalLabel : UILabel = {
        let label = UILabel()
        label.text = "SUBTOTAL"
        label.font = UIFont.init(name: "Avenir Next Condensed", size: 17)
        return label
    }()
    let subtotalPriceLabel : UILabel = {
        let label = UILabel()
        label.text = "$120.00"
        label.font = UIFont.init(name: "Avenir Next Regular", size: 15)
        label.textColor = .black
        label.textAlignment = .right
        return label
    }()
    let estimatedShippingLabel : UILabel = {
        let label = UILabel()
        label.text = "ESTIMATED SHIPPING & HANDLING"
        label.font = UIFont.init(name: "Avenir Next Condensed", size: 17)
        return label
    }()
    let estimatedShippingValueLabel : UILabel = {
        let label = UILabel()
        label.text = "FREE"
        label.font = UIFont.init(name: "Avenir Next Regular", size: 15)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    let taxLabel : UILabel = {
        let label = UILabel()
        label.text = "TAX"
        label.font = UIFont.init(name: "Avenir Next Condensed", size: 12)
        return label
    }()
    let taxValueLabel : UILabel = {
        let label = UILabel()
        label.text = "$12.00"
        label.font = UIFont.init(name: "Avenir Next Regular", size: 17)
        label.textColor = .black
        label.textAlignment = .right
        return label
    }()
    //
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let subTotalStackView = UIStackView(arrangedSubviews: [subTotalLabel, subtotalPriceLabel])
        subTotalStackView.axis = .horizontal
        subTotalStackView.alignment = .center
        subTotalStackView.spacing = 8
        subTotalStackView.distribution = .equalCentering
        addSubview(subTotalStackView)
        subTotalStackView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 13, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 24)
        let shippingStackView = UIStackView(arrangedSubviews: [estimatedShippingLabel, estimatedShippingValueLabel])
        shippingStackView.axis = .horizontal
        shippingStackView.alignment = .center
        shippingStackView.spacing = 0
        shippingStackView.distribution = .fill
        addSubview(shippingStackView)
        shippingStackView.anchor(top:subTotalStackView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 2, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 23)
        let taxStackView = UIStackView(arrangedSubviews: [taxLabel,taxValueLabel])
        taxStackView.axis = .horizontal
        taxStackView.alignment = .fill
        taxStackView.spacing = 0
        taxStackView.distribution = .fill
        addSubview(taxStackView)
        taxStackView.anchor(top:shippingStackView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 2.5, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 24.5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
