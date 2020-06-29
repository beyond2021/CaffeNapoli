//
//  PhotoSelectorHeader.swift
//  CaffeNapoli
//
//  Created by Kev1 on 10/25/17.
//  Copyright © 2017 Kev1. All rights reserved.
//

import UIKit

class PhotoSelectorHeader: UICollectionViewCell {
    //
    let photoImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
//        imageView.backgroundColor = .cyan
        imageView.backgroundColor = UIColor.cellBGColor()
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(photoImageView)
        photoImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
