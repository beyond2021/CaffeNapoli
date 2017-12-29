//
//  BuyButtonCell.swift
//  CaffeNapoli
//
//  Created by Kev1 on 12/27/17.
//  Copyright © 2017 Kev1. All rights reserved.
//

import UIKit
class BuyButtonCell : UITableViewCell {
    lazy var buyButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("BUY $120", for: .normal)
        button.titleLabel?.font = UIFont.init(name: "Avenir Next Condensed ", size: 15)
        button.titleLabel?.textColor = .white
        button.tintColor = .white
        button.backgroundColor = UIColor.darkText
        button.addTarget(self, action: #selector(handleBuy), for: .touchUpInside)
        return button
        
    }()
    @objc fileprivate func handleBuy() {
        print("Trying to buy product")
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        backgroundColor = .green
        addSubview(buyButton)
        buyButton.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 12, paddingLeft: 12, paddingBottom: 12, paddingRight: 12, width: 0, height: 40.5)
        
    }

    
}
