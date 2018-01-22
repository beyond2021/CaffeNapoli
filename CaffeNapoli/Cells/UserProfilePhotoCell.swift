//
//  UserProfilePotoCell.swift
//  CaffeNapoli
//
//  Created by Kev1 on 10/30/17.
//  Copyright © 2017 Kev1. All rights reserved.
//

import UIKit
class UserProfilePhotoCell: UICollectionViewCell {
    //load the imge into the cell here
    var post: Post? {
        didSet {
            guard let imageURL = post?.imageUrl else { return }
            
            photoImageView.loadImage(urlString: imageURL)
//            print(post?.imageUrl ?? "") // when set
            print(1)
            //load the image using URLSession

        }
    } // it startys off as nil so optional
    //
    let photoImageView : CustomImageView = {
        let iv = CustomImageView()
//        iv.backgroundColor = .red
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    //
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(photoImageView)
        backgroundColor = UIColor.cellBGColor()
        photoImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
