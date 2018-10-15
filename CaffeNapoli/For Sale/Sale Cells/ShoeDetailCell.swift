//
//  ShoeDetailCell.swift
//  CaffeNapoli
//
//  Created by Kev1 on 12/26/17.
//  Copyright © 2017 Kev1. All rights reserved.
//

import UIKit
class ShoeDetailCell: UITableViewCell {
   
//    var routeNumber: UILabel!
//    var routeName: UILabel!
    var product : Product?
    
    let productNameLabel : UILabel = {
        let label = UILabel()
        label.text = "NIKE FREE RN FLKNIT 2017"
        label.textAlignment = .center
        label.font = UIFont.init(name: "Avenir Next Condensed ", size: 17)
        return label
    }()
    let productDescriptionLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "The Nike Air Max 1 Ultra 2.0 Flyknit Men's Shoe updates the iconic original with an ultra-lightweight upper while keeping the plush, time-tested Max Air cushioning."
        label.font = UIFont.init(name: "Avenir Next Regualer ", size: 12)
        label.textColor = UIColor.rgb(displayP3Red: 104, green: 104, blue: 104)
        return label
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//         backgroundColor = .yellow
        addSubview(productNameLabel)
        addSubview(productDescriptionLabel)
        productDescriptionLabel.anchor(top: productNameLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 35, paddingLeft: 8, paddingBottom: 25.5, paddingRight: 8, width: 0, height: 0)
        
       
        productNameLabel.anchor(top: topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 25, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 165, height: 23.5)
        productNameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code

    }

    
    
}
