//
//  ItemCell.swift
//  CaffeNapoli
//
//  Created by Kev1 on 12/31/17.
//  Copyright © 2017 Kev1. All rights reserved.
//

import UIKit

class ItemCell : UITableViewCell {
    
    var product: Product! {
        didSet {
            self.updateUI()
        }
    }
    
    func updateUI()
    {
        productImageView.image = product.images?.first
        productNameLabel.text = product.name
        productPriceLabel.text = "$\(product.price!)"
    }
    
    let productNameLabel : UILabel = {
        let label = UILabel()
        label.text = "NIKE FREE RN FLYNKIT 2017 MEN'S RUNNING SHOE"
        label.font = UIFont.init(name: "Avenir Next Condensed Demi Bold", size: 15)
        label.numberOfLines = 2
        
        return label
    }()
    
    let productPriceLabel : UILabel = {
        let label = UILabel()
        label.text = "$120"
        label.font = UIFont.init(name: "Avenir Next Regular", size: 12)
        label.textColor = UIColor.rgb(displayP3Red: 104, green: 104, blue: 104)
        label.textAlignment = .center
        
        return label
    }()
    let removeButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Remove", for: .normal)
        button.titleLabel?.textColor = UIColor.rgb(displayP3Red: 104, green: 104, blue: 104)
        
        return button
        
    }()
    let productImageView : CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.image = #imageLiteral(resourceName: "s1")
        return iv
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(productImageView)
        productImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 8, paddingLeft: 13, paddingBottom: 14, paddingRight: 0, width: 96, height: 96)
        let stackView = UIStackView(arrangedSubviews: [productNameLabel, productPriceLabel,removeButton])
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.spacing = 0
        stackView.axis = .vertical
        addSubview(stackView)
        stackView.anchor(top: topAnchor, left: productImageView.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 13, paddingLeft: 12, paddingBottom: 13, paddingRight: 8, width: 0, height: 0)
        
    }
}
