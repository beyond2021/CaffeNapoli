//
//  CheckoutButtonCell.swift
//  CaffeNapoli
//
//  Created by Kev1 on 1/1/18.
//  Copyright © 2018 Kev1. All rights reserved.
//

import UIKit
class CheckoutButtonCell: UITableViewCell {
    
    lazy var checkoutyButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("CHECKOUT", for: .normal)
        button.titleLabel?.font = UIFont.init(name: "Avenir Next Condensed ", size: 15)
        button.titleLabel?.textColor = .white
        button.tintColor = .white
        button.backgroundColor = UIColor.darkText
        button.addTarget(self, action: #selector(handleCheckout), for: .touchUpInside)
        return button
        
    }()
    @objc fileprivate func handleCheckout() {
        print("checking out...")
 
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //        backgroundColor = .green
        addSubview(checkoutyButton)
        checkoutyButton.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 12, paddingLeft: 12, paddingBottom: 12, paddingRight: 12, width: 0, height: 40.5)
     
    }

    
}
