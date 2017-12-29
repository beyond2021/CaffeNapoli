//
//  SuggestionCollectionViewCell.swift
//  CaffeNapoli
//
//  Created by Kev1 on 12/27/17.
//  Copyright © 2017 Kev1. All rights reserved.
//

import UIKit

class SuggestionCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .purple
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
