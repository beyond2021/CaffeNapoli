//
//  BuyButtonCell.swift
//  CaffeNapoli
//
//  Created by Kev1 on 12/27/17.
//  Copyright © 2017 Kev1. All rights reserved.
//

import UIKit
protocol BuyButtonCellDelegate {
    func didBuyProduct(for cell: BuyButtonCell) // parameter tell which post we are clicking on
}


class BuyButtonCell : UITableViewCell {
     var delegate : BuyButtonCellDelegate?
    
    lazy var buyButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("BUY $120", for: .normal)
        button.titleLabel?.font = UIFont.init(name: "Avenir Next Condensed ", size: 15)
        button.titleLabel?.textColor = .white
        button.tintColor = .white
//        button.backgroundColor = UIColor.darkText
        button.backgroundColor = UIColor.tabBarBlue()
        button.addTarget(self, action: #selector(handleBuy), for: .touchUpInside)
        return button
        
    }()
    @objc fileprivate func handleBuy() {
        print("Trying to buy product")
//        delegate?.didBuyProduct()
        delegate?.didBuyProduct(for: self)
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        backgroundColor = .green
        addSubview(buyButton)
        buyButton.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 12, paddingLeft: 12, paddingBottom: 12, paddingRight: 12, width: 0, height: 40.5)
        
//        let cv = CartCurvedView(frame: frame)
//        cv.backgroundColor = .yellow
//        buyButton.addSubview(cv)
//        cv.anchor(top: buyButton.topAnchor, left: buyButton.leftAnchor, bottom: buyButton.bottomAnchor, right: buyButton.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
    }

    
}
