//
//  CheckOutCell.swift
//  CaffeNapoli
//
//  Created by Kev1 on 2/5/18.
//  Copyright © 2018 Kev1. All rights reserved.
//

import UIKit
import PassKit

protocol CheckOutCellDelegate {
    func didBuyProduct(for cell: CheckOutCell, product: Product) // parameter tell which post we are clicking on
}


class CheckOutCell : UITableViewCell {
    var delegate : CheckOutCellDelegate?
    
    var product: Product? {
        didSet {
            guard let product = product else { return }
            print("product price is:",product.price ?? "")
            
        }
    }
    
    
    lazy var checkOutButton : UIButton = {
        let button = UIButton(type: .system)
        //        button.setTitle("BUY $120", for: .normal)
        //        button.titleLabel?.font = UIFont.init(name: "Avenir Next Condensed ", size: 15)
        //        button.titleLabel?.textColor = .white
        //        button.tintColor = .white
        
        //        button.backgroundColor = UIColor.tabBarBlue()
//        button.setImage(#imageLiteral(resourceName: "ApplePayBTN_64pt__black_textLogo_"), for: .normal)
        button.setTitle("CHECKOUT", for: .normal)
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //        backgroundColor = .green
        addSubview(checkOutButton)
        checkOutButton.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 12, paddingRight: 12, width: 50, height: 34)
        
        checkOutButton.centerXAnchor .constraint(equalTo: centerXAnchor).isActive = true
        checkOutButton.centerYAnchor .constraint(equalTo: centerYAnchor).isActive = true
       
    }
    
    
}

