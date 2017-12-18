//
//  ShoppingCartController.swift
//  CaffeNapoli
//
//  Created by Kev1 on 12/14/17.
//  Copyright © 2017 Kev1. All rights reserved.
//

import UIKit

class ShoppingCartController: UIViewController {
    
    let dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "right_arrow_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(dismissCart), for: .touchUpInside)
        
        return button
    }()
    
    let cartLabel: UILabel = {
        let label = UILabel()
        label.text = "Shopping Cart Goes Here"
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
        
        
    }()
    
    
    @objc func dismissCart() {
        print("Dismissing cart....")
        dismiss(animated: true, completion: nil)
        
    }
    
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.napoliGold()
        view.addSubview(cartLabel)
        cartLabel.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width - 20, height: 50)
        cartLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cartLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        view.addSubview(dismissButton)
        dismissButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 24, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 50, height: 50)
    }
}
