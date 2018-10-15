//
//  CNUserProfileHeader.swift
//  CaffeNapoli
//
//  Created by Kev1 on 4/2/18.
//  Copyright © 2018 Kev1. All rights reserved.
//

import UIKit
import Firebase
protocol CNUserProfileHeaderDelegate {
    func didChangeToListView()
    func didChangeToGridView()
    func updateProfilePhoto()
    func showEditProfileController()
    func getMyPosts(posts: Int)
    func getMyFollowers()
    func getFollowing()
}

class CNUserProfileHeader: UICollectionViewCell {
     var delegate : CNUserProfileHeaderDelegate?
    fileprivate func showEditProfileController() {
        
        delegate?.showEditProfileController()
        
    }
    
    // MARK : USER
    var user : User? {
        // To know when they are set because they are empty in the begining
        didSet {
            //            print("Did set \(String(describing: user?.username))")
            // SINCE ITS SET WE WILL MAKE THE URLSESSION CALL
            
            guard let profileImageUrl = user?.profileImageURL else { return }
            profileImageView.loadImage(urlString: profileImageUrl)
            usernameLabel.text = user?.username
            // users Posts
            // get users following
            // get users followers
            // Follow / Unfollow
            
            setupEditFollowButton()
            
        }
    }
    
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
//                    self.editProfileFollowButton.setTitle("Unfollow", for: .normal)
                    
                    self.editProfileFollowButton.setTitle("Stop Watching", for: .normal)
                    
                    
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
        if editProfileFollowButton.titleLabel?.text == "Stop Watching" {
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
            
        } else if editProfileFollowButton.titleLabel?.text == "Watch"{
            
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
            
        } else {
            print("Trying to open edit profile controller")
            showEditProfileController()
            
        }
        
    }
    
    fileprivate func setupFollowStyle() {
//        self.editProfileFollowButton.setTitle("Follow", for: .normal)
         self.editProfileFollowButton.setTitle("Watch", for: .normal)
//        self.editProfileFollowButton.backgroundColor = UIColor.rgb(displayP3Red: 17, green: 154, blue: 237) //bg
        self.editProfileFollowButton.backgroundColor = UIColor.tabBarBlue()
        self.editProfileFollowButton.setTitleColor(.white, for: .normal)// text color
        self.editProfileFollowButton.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
        delegate?.getFollowing()
        
    }
    
    fileprivate func setupUnfollowStyle() {
//        self.editProfileFollowButton.setTitle("Unfollow", for: .normal)
        self.editProfileFollowButton.setTitle("Stop Watching", for: .normal)
        self.editProfileFollowButton.backgroundColor = .white //bg
        self.editProfileFollowButton.setTitleColor(.black, for: .normal)// text color
        self.editProfileFollowButton.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
        delegate?.getFollowing()
        
    }
    
    
    
    
//    var delegate : UserProfileHeaderDelegate?
    //Let manually add our views
    lazy var  profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.layer.borderColor = UIColor.NavBarYellow().cgColor
        iv.layer.borderWidth = 4
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(updatePhoto)))
        return iv
    }()
    @objc  func updatePhoto() {
        delegate?.updateProfilePhoto()
        print("Trying to update photo from Header")
    }
    
    // USERNAME LABEL
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .center
//        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //
    lazy var postLabel: UILabel = {
        let label = UILabel()
        print("label is set")
        let attributedText = NSMutableAttributedString(string: "01\n", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "My Stories", attributes:[NSAttributedStringKey.foregroundColor:UIColor.lightGray, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)]))

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
        attributedText.append(NSAttributedString(string: "Watchers", attributes:[NSAttributedStringKey.foregroundColor:UIColor.lightGray, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)]))
        
        label.attributedText = attributedText
        //label.text = "11 \nposts"
        // label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    //
//    var followingLabel: UILabel?
    lazy var followingLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "Watching", attributes:[NSAttributedStringKey.foregroundColor:UIColor.lightGray, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)]))

        label.attributedText = attributedText
//        label.text = "11 \nposts"
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
        //        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
        // Draw the border around the buttom
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 3
        button.addTarget(self, action: #selector(handleEditProfileOrFollow), for: .touchUpInside)
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //backgroundColor = . blue
        // Add our views here
        addSubview(profileImageView)
//        profileImageView.anchor(top: topAnchor, left: nil, bottom: nil, right: self.rightAnchor, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 80, height: 80)
        profileImageView.anchor(top: topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 80, height: 80)
        profileImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        profileImageView.layoutCornerRadiusAndShadow(cornerRadius: 80/2)

        addSubview(usernameLabel)
        //Anchor Username label. Notice the order or crash will occur
        usernameLabel.anchor(top: profileImageView.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, paddingTop: 4, paddingLeft:12, paddingBottom: 0, paddingRight: 12, width: 0, height: 30)
//        usernameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        //
        setupUserStatsView()
        //EDIT PROFILE BUTTON
        addSubview(editProfileFollowButton)
        editProfileFollowButton.anchor(top: followersLabel.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, paddingTop: 2, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 40)
//        getMyPosts()
//        getMyFollowers()
//        getFollowing()
//        setupAttributedCaption()

    }
    var posts : Int?{
        didSet{
            print("The headerv post is now set",posts)
//            guard let posts = posts else { return }
//            let attributedText = NSMutableAttributedString(string: "11\n", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
//            attributedText.append(NSAttributedString(string: "My Stories", attributes:[NSAttributedStringKey.foregroundColor:UIColor.lightGray, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)]))
//
//            postLabel.attributedText = attributedText
            setupAttributedCaption()
            
            
        }
      
    }
    var following : Int? = 0 {
        didSet {
            guard let following = following else { return }
            print("The following is set in the header and is", following)
//            followingLabel.text = "\(following)"
            var attText = 0
            if following == 0 {
                attText = 0
            } else {
                attText = following
                
            }

            let attributedText = NSMutableAttributedString(string: "\(following)\n", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
            attributedText.append(NSAttributedString(string: "Watching", attributes:[NSAttributedStringKey.foregroundColor:UIColor.lightGray, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)]))

//            followingLabel.attributedText = attributedText
            
            
            followingLabel.text = "\(following)"
            self.setNeedsDisplay()
            self.followingLabel.setNeedsDisplay()
            
            
        }
    }
    
    
    fileprivate func setupAttributedCaption() {
        guard let posts = self.posts else { return }
        //Attributed text
        //        print("Fb user is :", post.user.fbUsername)
        var attrText = ""
//        if post.user.username == "" {
//            //            print("Facebook user", post.user.fbUsername)
//            attrText = post.user.name!
//
//        } else {
//            print("Regular user", post.user.username)
//            attrText = post.user.username!
//
//        }
        
        let attributedText = NSMutableAttributedString(string: "11\n", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "My Stories", attributes:[NSAttributedStringKey.foregroundColor:UIColor.lightGray, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)]))
        
        postLabel.attributedText = attributedText
        postLabel.text = "Regular text"
//        setNeedsDisplay()
    }
    
    
    
    
    
    
    
    
    var userID:  String?
    fileprivate func getMyPosts(){
        print("Getting MyPosts from header")
//        delegate?.getMyPosts(posts: 0)
    }
    fileprivate func getMyFollowers(){
        print("Getting MyFollowers from header")
        delegate?.getMyFollowers()
        
    }
    fileprivate func getFollowing(){
        print("Getting Following from header")
        delegate?.getFollowing()
    }
    
    fileprivate func setupUserStatsView(){
      
        // !1 : Create the stackView
        let stackView = UIStackView(arrangedSubviews: [postLabel, followersLabel, followingLabel])
        // 1b: setup the stackView
        stackView.axis = .horizontal //
        //        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        // make default gray = tintColor
//        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        
        // 2: Add it to cell
        addSubview(stackView)
        stackView.anchor(top: usernameLabel.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, paddingTop: 4, paddingLeft: 20, paddingBottom: 20, paddingRight: 0, width: 0, height: 50)
//        stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
/*
 addSubview(followingLabel)
        followingLabel.translatesAutoresizingMaskIntoConstraints = false
        followingLabel.anchor(top: usernameLabel.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, paddingTop: 4, paddingLeft: 100, paddingBottom: 0, paddingRight: 100, width: 0, height: 50)
         followingLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
 */
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func awakeFromNib() {
        self.contentView.autoresizingMask = [UIViewAutoresizing.flexibleWidth , UIViewAutoresizing.flexibleHeight]
    }
}
