//
//  CommentsCell.swift
//  CaffeNapoli
//
//  Created by Kev1 on 12/6/17.
//  Copyright © 2017 Kev1. All rights reserved.
//

import UIKit

class CommentsCell: UICollectionViewCell {
    // reference to the comment
    var comment: Comment? {
        didSet {
            //
            guard let comment = comment else { return }
            //NS
            
            let username = comment.user.username ?? "No username"
            let userComment = comment.text
            
            let attributedText = NSMutableAttributedString(string: username, attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14),NSAttributedStringKey.foregroundColor : UIColor.red])
            attributedText.append(NSAttributedString(string: " " + userComment, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize:14)]))
            
            
            
//            print(comment?.text)
            textView.attributedText = attributedText
            let profileImageUrl = comment.user.profileImageURL
            // load up the image
            profileImageView.loadImage(urlString: profileImageUrl)
            
        }
        
    }
    
//    let textLabel : UILabel = {
//        let label = UILabel()
//        label .font = UIFont.systemFont(ofSize: 14)
//        label.numberOfLines = 0
////        label.backgroundColor = .lightGray
//        return label
//
//    }()
    
    let textView : UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 14)
        tv.isScrollEnabled = false
        //        label.backgroundColor = .lightGray
        return tv
        
    }()
    
    
    //
    let profileImageView : CustomImageView = {
        let iv = CustomImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .blue
       return iv
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        backgroundColor = .yellow
        addSubview(textView)
        addSubview(profileImageView)
        textView.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 4, paddingBottom: 4, paddingRight: 4, width: 0, height: 0)
        //
        profileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        profileImageView.layer.cornerRadius = 40 / 2
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
