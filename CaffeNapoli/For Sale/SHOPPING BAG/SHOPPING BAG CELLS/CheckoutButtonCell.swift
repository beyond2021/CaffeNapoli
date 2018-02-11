//
//  CheckoutButtonCell.swift
//  CaffeNapoli
//
//  Created by Kev1 on 1/1/18.
//  Copyright © 2018 Kev1. All rights reserved.
//

import UIKit
import Stripe

protocol CheckoutButtonCellDelegate {
    func didBuyProduct(for cell: CheckoutButtonCell, product: Product) // parameter tell which post we are clicking on
}

class CheckoutButtonCell: UITableViewCell {
    
    var delegate : CheckoutButtonCellDelegate?
    var product: Product? {
        didSet {
            guard let product = product else { return }
            print("product price is:",product.price ?? "")
            
        }
    }
    
    lazy var checkoutButton : UIButton = {
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
        guard let product = product else { return }
        delegate?.didBuyProduct(for: self, product: product)
 
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //        backgroundColor = .green
        addSubview(checkoutButton)
        checkoutButton.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 7, paddingLeft: 120, paddingBottom: 7, paddingRight: 120, width: 0, height: 30.5)
        checkoutButton.layoutCornerRadiusAndShadow(cornerRadius: 4)
     
    }

    
}
//// Setup add card view controller
//let addCardViewController = STPAddCardViewController()
//addCardViewController.delegate = self
//
//// Present add card view controller
//let navigationController = UINavigationController(rootViewController: addCardViewController)
//present(navigationController, animated: true)

