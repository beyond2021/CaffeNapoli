//
//  UserSearchCell.swift
//  CaffeNapoli
//
//  Created by Kev1 on 11/9/17.
//  Copyright © 2017 Kev1. All rights reserved.
//

import Foundation
import UIKit

class UserSearchCell: UICollectionViewCell {
    //Populating
    var user : User? {
        didSet {
            //When set we have everything for a user
            usernameLabel.text = user?.username
            guard let urlString = user?.profileImageURL else { return }
            profileImageView.loadImage(urlString: urlString)
        }
    }// Starts out as nil. filled in cellFroItem
    
    let profileImageView : CustomImageView = {
        let iv = CustomImageView()
//        iv.backgroundColor = .red
        iv.image = #imageLiteral(resourceName: "avatar2")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    //
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
//        backgroundColor = .yellow
        backgroundColor = UIColor.cellBGColor()
        addSubview(profileImageView)
        addSubview(usernameLabel)
        // How to center Image in cell
        profileImageView.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        profileImageView.layer.cornerRadius = 50 / 2 // round the corner
        usernameLabel.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        //separator line
        let separatorView = UIView()
        separatorView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        addSubview(separatorView)
        separatorView.anchor(top: nil, left: usernameLabel.leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
