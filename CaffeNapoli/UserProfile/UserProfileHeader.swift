//
//  UserProfileHeader.swift
//  CaffeNapoli
//
//  Created by Kev1 on 10/14/17.
//  Copyright © 2017 Kev1. All rights reserved.
//

import UIKit
import Firebase

class UserProfileHeader: UICollectionViewCell {
    // MARK : USER
    var user : User? {
        // To know when they are set because they are empty in the begining
        didSet {
            print("Did set \(String(describing: user?.username))")
            // SINCE ITS SET WE WILL MAKE THE URLSESSION CALL
            setUpProfileImage() // AFTER WE OBTAIN THE USER FROM THE USERPROFILECONTROLLER
            // Setup the username here
            usernameLabel.text = user?.username
            
        }
    }
    
    
    
    //Let manually add our views
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        ////iv.backgroundColor = .red
        return iv
        
    }()
    //The bottom StackView
    let gridButton: UIButton = {
      let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "grid"), for: .normal)
       // button.tintColor = UIColor(white: 0, alpha: 0.1)
        return button
        
    }()
    let listButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "list"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
        
    }()
    let bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "ribbon"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
        
    }()
    // USERNAME LABEL
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    //
    let postLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "11\n", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "posts", attributes:[NSAttributedStringKey.foregroundColor:UIColor.lightGray, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)]))
        
        label.attributedText = attributedText
       // label.text = "11 \nposts"
       // label.font = UIFont.boldSystemFont(ofSize: 14)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    //
    let followersLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "followers", attributes:[NSAttributedStringKey.foregroundColor:UIColor.lightGray, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)]))
        
        label.attributedText = attributedText
        //label.text = "11 \nposts"
        // label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    //
    let followingLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "following", attributes:[NSAttributedStringKey.foregroundColor:UIColor.lightGray, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)]))
        
        label.attributedText = attributedText
        //label.text = "11 \nposts"
        // label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    //EDIT PROFILE BUTTON
    let editProfileButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit Profile", for: .normal)
        button.setTitleColor(.black, for: .normal)// Text color for the button
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        // Draw the border around the buttom
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 3
        
        return button
    }()
    
    
    

    //1: There is no viewDidLoad in UIViews
    // TO START DRAWING IN HERE WE HAVE TO
    override init(frame: CGRect) {
        super.init(frame: frame)
        //backgroundColor = . blue
        // Add our views here
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: self.leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 80, height: 80)
        //
        profileImageView.layer.cornerRadius = 80/2
        profileImageView.clipsToBounds = true
        // SETUP BOTTOM TOOLBAR
        setupBottomToolbar()
        //Add username label here
        addSubview(usernameLabel)
        //Anchor Username label. Notice the order or crash will occur
        usernameLabel.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, bottom: gridButton.topAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 0)
        
        //
        setupUserStatsView()
        //EDIT PROFILE BUTTON
        addSubview(editProfileButton)
        editProfileButton.anchor(top: postLabel.bottomAnchor, left: postLabel.leftAnchor, bottom: nil, right: followingLabel.rightAnchor, paddingTop: 2, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 34)
        
    }
    fileprivate func setupUserStatsView(){
        // !1 : Create the stackView
        let stackView = UIStackView(arrangedSubviews: [postLabel, followersLabel, followingLabel])
        // 1b: setup the stackView
        stackView.axis = .horizontal //
        stackView.distribution = .fillEqually
        // make default gray = tintColor
        
        
        // 2: Add it to cell
        addSubview(stackView)
        stackView.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 50)

        
    }
    
    fileprivate func setupBottomToolbar() {
        // 0: create line
        let topDividerView = UIView()
        topDividerView.backgroundColor = .lightGray
        let bottomDividerView = UIView()
        bottomDividerView .backgroundColor = .lightGray
        // !1 : Create the stackView
        let stackView = UIStackView(arrangedSubviews: [gridButton, listButton, bookmarkButton])
        // 1b: setup the stackView
        stackView.axis = .horizontal //
        stackView.distribution = .fillEqually
        // make default gray = tintColor
        
        
        // 2: Add it to cell
        addSubview(stackView)
        addSubview(topDividerView)
        addSubview(bottomDividerView)
        // 3: anchor it
        stackView.anchor(top: nil, left: leftAnchor, bottom: self.bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 9, paddingRight: 0, width: 0, height: 50)
        // Place on top of stack view
        topDividerView.anchor(top: stackView.topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        //Place at stackview's bottom
        bottomDividerView.anchor(top: stackView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        
        
    }
    
    
    fileprivate func setUpProfileImage(){
        
        guard let profileImageURL = user?.profileImageURL else { return }
        
        guard let url = URL(string: profileImageURL) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            // You must check for the error, then construct the im age using data
            if let err = err {
                print("Failed to fetch profile image:", err)
                return
            }
            //With urlsession u should check for response status of 200 [HTTP OK]
            
            //                print(data)
            guard let data = data else { return }
            
            let image = UIImage(data: data)
            // I need to get back to the main UI thread
            DispatchQueue.main.async {
                self.profileImageView.image = image
            }
            
            }.resume()
        

        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
