//
//  BuyButtonCell.swift
//  CaffeNapoli
//
//  Created by Kev1 on 12/27/17.
//  Copyright © 2017 Kev1. All rights reserved.
//

import UIKit
import PassKit

protocol BuyButtonCellDelegate {
    func didBuyProduct(for cell: BuyButtonCell, product: Product) // parameter tell which post we are clicking on
}


class BuyButtonCell : UITableViewCell {
     var delegate : BuyButtonCellDelegate?
    
    var product: Product? {
        didSet {
            guard let product = product else { return }
            print("product price is:",product.price ?? "")
           
        }
    }
    
    
    lazy var buyButton : PKPaymentButton = {
        let button = PKPaymentButton(paymentButtonType: .buy, paymentButtonStyle: .black)
//        button.setTitle("BUY $120", for: .normal)
//        button.titleLabel?.font = UIFont.init(name: "Avenir Next Condensed ", size: 15)
//        button.titleLabel?.textColor = .white
//        button.tintColor = .white

//        button.backgroundColor = UIColor.tabBarBlue()
//        button.setImage(#imageLiteral(resourceName: "ApplePayBTN_64pt__black_textLogo_"), for: .normal)
        button.addTarget(self, action: #selector(handleBuyWithApplePay), for: .touchUpInside)
        return button
        
    }()
    @objc fileprivate func handleBuyWithApplePay() {
        print("Trying to buy product")
//        delegate?.didBuyProduct()
        guard let product = product else { return }
        delegate?.didBuyProduct(for: self, product: product)
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        backgroundColor = .green
        addSubview(buyButton)
        buyButton.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 12, paddingRight: 12, width: 160, height: 34)
        
        buyButton.centerXAnchor .constraint(equalTo: centerXAnchor).isActive = true
        buyButton.centerYAnchor .constraint(equalTo: centerYAnchor).isActive = true
        
//        let cv = CartCurvedView(frame: frame)
//        cv.backgroundColor = .yellow
//        buyButton.addSubview(cv)
//        cv.anchor(top: buyButton.topAnchor, left: buyButton.leftAnchor, bottom: buyButton.bottomAnchor, right: buyButton.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
    }

    
}
