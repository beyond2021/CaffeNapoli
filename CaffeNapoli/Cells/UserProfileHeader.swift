//
//  UserProfileHeader.swift
//  CaffeNapoli
//
//  Created by Kev1 on 10/14/17.
//  Copyright © 2017 Kev1. All rights reserved.
//

import UIKit
import Firebase

protocol UserProfileHeaderDelegate {
    func didChangeToListView()
    func didChangeToGridView()
}

class UserProfileHeader: UICollectionViewCell {
    //delegation
    var delegate : UserProfileHeaderDelegate?
    
    // MARK : USER
    var user : User? {
        // To know when they are set because they are empty in the begining
        didSet {
//            print("Did set \(String(describing: user?.username))")
            // SINCE ITS SET WE WILL MAKE THE URLSESSION CALL
 
            guard let profileImageUrl = user?.profileImageURL else { return }
            profileImageView.loadImage(urlString: profileImageUrl)
            usernameLabel.text = user?.username
            // Follow / Unfollow

            setupEditFollowButton()
            
        }
    }
    //LOGIC
    
    //MARK:- Following
    fileprivate func setupEditFollowButton() {
        // Current user or not check
        //!: get the current user
        guard let currentLoggedUserId = Auth.auth().currentUser?.uid else {
            return
        }
        //2: get the user we pass into the header
        guard let userId = user?.uid else { return }
        // chcek button for follow
       
        //3: check for equality since we have both here
        if currentLoggedUserId == userId {
              //  editProfileButton.setTitle("Edit Profile", for: .normal)
        } else {
            //check if following
            //1: get to following node
            Database.database().reference().child("following").child(currentLoggedUserId).child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
                //
//                print(snapshot.value)
                // checking for 1
                if let isFollowing = snapshot.value as? Int, isFollowing == 1 {
                    
//                    self.setupUnfollowStyle()
                    self.editProfileFollowButton.setTitle("Unfollow", for: .normal)
                    
                    
                    
                    
                } else {
                   self.setupFollowStyle()
                    
                }
                
                
            }, withCancel: { (err) in
                //
               
                    print("Failed to check if following:", err)
                
            })
            
       
            
        }
      
    }
    
    @objc func handleEditProfileOrFollow() {
        print("Execute edit profile / follow / unfollow logic")
        // Follow User Logic
        guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else { return }
        guard let userId = user?.uid else { return }
        //1: introduce a following node. .database() gets us to the root of the tree. We are building out a little branch
        if editProfileFollowButton.titleLabel?.text == "Unfollow" {
            // do unfollow here
            Database.database().reference().child("following").child(currentLoggedInUserId).child(userId).removeValue(completionBlock: { (error, ref) in
                //
                if let err = error {
                    print("Failed to unfollow user:", err)
                    return
                }
                //success
                print("Successfully unfollowed user: ", self.user?.username ?? "")
                //button logic
                self.setupFollowStyle()
            })
            
        } else {
            
            // do follow here
            let followingRef = Database.database().reference().child("following").child(currentLoggedInUserId)
            let values = [userId : 1 ]
            followingRef.updateChildValues(values) { (error, ref) in
                //
                if let err = error {
                    print("Fail to follow user :", err)
                    return // get out of completion block
                }
                //success
                print("Successfully followed user: ", self.user?.username ?? "")
                self.setupUnfollowStyle()
                
            }
            
            
        }
        
       
    }
    
    fileprivate func setupFollowStyle() {
        self.editProfileFollowButton.setTitle("Follow", for: .normal)
        self.editProfileFollowButton.backgroundColor = UIColor.rgb(displayP3Red: 17, green: 154, blue: 237) //bg
        self.editProfileFollowButton.setTitleColor(.white, for: .normal)// text color
        self.editProfileFollowButton.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
    }
    
    fileprivate func setupUnfollowStyle() {
        self.editProfileFollowButton.setTitle("Unfollow", for: .normal)
        self.editProfileFollowButton.backgroundColor = .white //bg
        self.editProfileFollowButton.setTitleColor(.black, for: .normal)// text color
        self.editProfileFollowButton.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
        
    }
    
    
    //Let manually add our views
    let profileImageView: CustomImageView = {
        
        let iv = CustomImageView()
        ////iv.backgroundColor = .red
        return iv
        
    }()
    //The bottom StackView
    lazy var gridButton: UIButton = {
      let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "grid"), for: .normal)
       // button.tintColor = UIColor(white: 0, alpha: 0.1)
        button.addTarget(self, action: #selector(changeToGridView), for: .touchUpInside)
        return button
        
    }()
    lazy var listButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "list"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        button.addTarget(self, action: #selector(changeToListView), for: .touchUpInside)
        return button
        
    }()
    // Button States
    @objc func changeToListView() {
        print("switching to list view")
        listButton.tintColor = .mainBlue()
        gridButton.tintColor = .buttonUnselected()
        delegate?.didChangeToListView()
        
        
    }
    @objc func changeToGridView() {
        print("switching to grid view")
        gridButton.tintColor = .mainBlue()
        listButton.tintColor = .buttonUnselected()
        delegate?.didChangeToGridView()
    }
    
    
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
    lazy var editProfileFollowButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit Profile", for: .normal)
        button.setTitleColor(.black, for: .normal)// Text color for the button
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        // Draw the border around the buttom
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 3
        button.addTarget(self, action: #selector(handleEditProfileOrFollow), for: .touchUpInside)
        
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
        addSubview(editProfileFollowButton)
        editProfileFollowButton.anchor(top: postLabel.bottomAnchor, left: postLabel.leftAnchor, bottom: nil, right: followingLabel.rightAnchor, paddingTop: 2, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 34)
        
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
    

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
