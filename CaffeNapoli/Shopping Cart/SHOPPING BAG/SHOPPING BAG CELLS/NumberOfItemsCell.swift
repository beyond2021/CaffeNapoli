//
//  NumberOfItemsCell.swift
//  CaffeNapoli
//
//  Created by Kev1 on 12/31/17.
//  Copyright © 2017 Kev1. All rights reserved.
//

import UIKit
class NumberOfItemsCell: UITableViewCell {
    
    let numberOfItemsLabel : UILabel = {
        let label = UILabel()
        label.text = "1 ITEMS"
        label.font = UIFont.init(name: "Avenir Next Condensed Demi Bold", size: 19)
        
        return label
    }()
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(numberOfItemsLabel)
        numberOfItemsLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 13, paddingLeft: 8, paddingBottom: 13.5, paddingRight: 0, width: 56.5, height: 21.5)
        
    }
    
    
}



