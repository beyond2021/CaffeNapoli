//
//  SuggestionCollectionViewCell.swift
//  CaffeNapoli
//
//  Created by Kev1 on 12/27/17.
//  Copyright © 2017 Kev1. All rights reserved.
//

import UIKit

class SuggestionCollectionViewCell: UICollectionViewCell {
    
    var image: UIImage! {
        didSet {
            self.imageView.image = image
            self.setNeedsLayout()
        }
        
    }
    
    let imageView : UIImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .red
        
       return iv
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .purple
        addSubview(imageView)
        imageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
