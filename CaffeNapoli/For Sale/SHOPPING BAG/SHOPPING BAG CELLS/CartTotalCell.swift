//
//  CartTotalCell.swift
//  CaffeNapoli
//
//  Created by Kev1 on 1/1/18.
//  Copyright © 2018 Kev1. All rights reserved.
//

import UIKit
class CartTotalCell: UITableViewCell {
    let totalLabel : UILabel = {
        let label = UILabel()
        label.text = "TOTAL"
        label.font = UIFont.init(name: "Avenir Next Condensed", size: 17)
        label.textAlignment = .left
        return label
    }()
    let totalValueLabel : UILabel = {
        let label = UILabel()
        label.text = "$120.00"
        label.font = UIFont.init(name: "Avenir Next Demi Bold", size: 15)
        label.textColor = .black
        label.textAlignment = .right
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let stackView = UIStackView(arrangedSubviews: [totalLabel, totalValueLabel])
        addSubview(stackView)
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.distribution = .equalCentering
        stackView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 13, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 24.5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
