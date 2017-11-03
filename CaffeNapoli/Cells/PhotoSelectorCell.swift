//
//  PhotoSelectorCell.swift
//  CaffeNapoli
//
//  Created by Kev1 on 10/25/17.
//  Copyright © 2017 Kev1. All rights reserved.
//

import UIKit

class PhotoSelectorCell: UICollectionViewCell {
    // ImageView for cell
    let photoImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        
        return imageView
    }()
    
    
    // Methods to overide in UICollectionViewCell
    override init(frame: CGRect) {
        super.init(frame: frame)
//        backgroundColor = .brown
        addSubview(photoImageView)
        photoImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
