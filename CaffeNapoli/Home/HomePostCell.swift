//
//  HomePostCell.swift
//  CaffeNapoli
//
//  Created by Kev1 on 10/31/17.
//  Copyright © 2017 Kev1. All rights reserved.
//

import UIKit
import HCSStarRatingView
import  AVFoundation
protocol HomePostCellDelegate {
    func didTapComment(post: Post) // parameter tell which post we are clicking on
    // likes
    func didLike(for cell: HomePostCell) // to hold like state
    //show more
    func showMore(post: Post, sender : HomePostCell)
    
}


class HomePostCell: UICollectionViewCell {
    //
    var delegate : HomePostCellDelegate?
    // post to fill this cell
    var post: Post?{
        didSet {
            // like button
            likeButton.setImage( post?.hasLiked == true ? #imageLiteral(resourceName: "blLikeSel").withRenderingMode(.alwaysOriginal) :#imageLiteral(resourceName: "blLikeUn").withRenderingMode(.alwaysOriginal), for: .normal) // tenerary operator
            // This says if hasLiked is true use image selected else use image unselected
            
           // print(post?.imageUrl)
            guard let postImageUrl = post?.imageUrl else { return }
            photoImageView.loadImage(urlString: postImageUrl)
//            print("Fb user is :", post?.user.fbUsername)
            
            if post?.user.username == "" {
                usernameLabel.text = post?.user.fbUsername
            } else {
                usernameLabel.text = post?.user.username
                
            }
//            usernameLabel.text = post?.user.username
            guard let profileImageUrl = post?.user.profileImageURL else { return }
            userProfileImageView.loadImage(urlString: profileImageUrl)
//            captionLabel.text = post?.caption
            setupAttributedCaption()
          
        }
    } //needs to be nil in the beginning
    
    fileprivate func setupAttributedCaption() {
        guard let post = self.post else { return }
        //Attributed text
//        print("Fb user is :", post.user.fbUsername)
        var attrText = ""
        if post.user.username == "" {
//            print("Facebook user", post.user.fbUsername)
            attrText = post.user.fbUsername!
            
        } else {
            print("Regular user", post.user.username)
            attrText = post.user.username
            
        }
        
        let attributedText = NSMutableAttributedString(string: attrText, attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14),NSAttributedStringKey.foregroundColor : UIColor.red])
//        attributedText.append(NSAttributedString(string: " \(post.caption)", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize:14),NSAttributedStringKey.foregroundColor : UIColor.white]))
//         attributedText.append(NSAttributedString(string: " \(post.caption)", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize:14)]))
        
        attributedText.append(NSAttributedString(string: " \(post.caption)", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize:14),NSAttributedStringKey.foregroundColor : UIColor.tabBarBlue()]))
        
        attributedText.append(NSAttributedString(string: "\n\n", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 4)]))
        
        let timeAgoDisplay = post.creationDate.timeAgoDisplay()
        
        // date
        attributedText.append(NSAttributedString(string: timeAgoDisplay, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor : UIColor.cellButtonsColor()]))

        captionLabel.attributedText = attributedText
    }
    
    
    //MARK: - Profile ImageView
    //
    let userProfileImageView : CustomImageView = {
        let iv = CustomImageView()
//        iv.layer.borderColor = UIColor.white.cgColor
        iv.layer.borderColor = UIColor.NavBarYellow().cgColor
        iv.layer.borderWidth = 4
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    //
    let photoImageView : CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        //iv.backgroundColor = .blue
       return iv
    }()
    //
    
    let ratingsView : HCSStarRatingView = {
        let view = HCSStarRatingView()
        view.maximumValue = 5
        view.minimumValue = 0
        view.backgroundColor = .clear
        view.value = 0
        view.tintColor = UIColor.cellButtonsColor()
        view.addTarget(self, action: #selector(ratingsValueChanged), for: .valueChanged)
        
        
        return view
    }()
    
    @objc func ratingsValueChanged() {
        print("ratings value changed...")
//        playAudio(sound: "star", ext: "wav")
    }
    
    //MARK: - Username label
    let usernameLabel : UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.font = UIFont.boldSystemFont(ofSize: 16)
//        label.textColor = .white
        label.textColor = UIColor.tabBarBlue()
        return label
    }()
    //
    //MARK: - Options Button
    lazy var optionsButton : UIButton = {
        let button = UIButton(type: .system)
//        button.setTitle("•••", for: .normal)
        button.setImage(#imageLiteral(resourceName: "blMore").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(showMore), for: .touchUpInside)
        return button
        
    }()
    @objc private func showMore(){
       print("showing more")
        guard let post = self.post else { return }
        delegate?.showMore(post: post, sender:self)
        
    }
    //
    // Like Button
    lazy var likeButton : UIButton = {
        let button = UIButton(type: .system)
      button.setImage(#imageLiteral(resourceName: "blLikeUn").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handlelike), for: .touchUpInside)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    //
    lazy var commentButton : UIButton = {
        let button = UIButton(type: .system)
//        button.setImage(#imageLiteral(resourceName: "comment").withRenderingMode(.alwaysOriginal), for: .normal)
        button.setImage( #imageLiteral(resourceName: "blMessUn").withRenderingMode(.alwaysOriginal), for: .normal)
        
        button.addTarget(self, action: #selector(handleComment), for: .touchUpInside)
        
//        button.setTitleColor(.black, for: .normal)
        
         button.setTitleColor(.white, for: .normal)
        return button
    }()
    //
    let sendMessageButton : UIButton = {
        let button = UIButton(type: .system)
//        button.setImage(#imageLiteral(resourceName: "send2").withRenderingMode(.alwaysOriginal), for: .normal)
        button.setImage(#imageLiteral(resourceName: "blShareUn").withRenderingMode(.alwaysOriginal), for: .normal)
        
//        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    //
    let bookmarkButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "blBookmarkUn").withRenderingMode(.alwaysOriginal), for: .normal)
        
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    @objc func handleComment() {
       print("Trying to show comments ......")
        //show a new controller
        // tricky
        // custom delegation
        //protocol
        guard let post = self.post else { return }
        delegate?.didTapComment(post: post) // from delegate protocol // delegate setin home contr cellforItem
//        delegate?.didTapComment()
        
    }
    
    @objc func handlelike() {
//        print("Like coming from cell......")
        delegate?.didLike(for: self)// which cell was like = self
        
    }
    
    
    
    // MARK:- Caption Label
    let captionLabel: UILabel = {
        let label = UILabel()
//        //Attributed text
//        let attributedText = NSMutableAttributedString(string: "Username", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
//        attributedText.append(NSAttributedString(string: " Some cation text that will perhaps wrap on to the next line", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize:14)]))
//
//
//
//        attributedText.append(NSAttributedString(string: "\n\n", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 4)]))
//
//
//            // date
//        attributedText.append(NSAttributedString(string: "1 week ago ", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor : UIColor.gray]))
//        label.attributedText = attributedText
//        label.text = "SOMETHING FOR NOW"
       // label.font = UIFont.boldSystemFont(ofSize: 14)
        label.numberOfLines = 0
//        label.backgroundColor = .yellow
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
 
        backgroundColor = UIColor.cellBGColor()
//        backgroundColor = .white
        //
        addSubview(userProfileImageView)
        addSubview(usernameLabel)
        addSubview(optionsButton)
        addSubview(photoImageView)
        //
//        userProfileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: photoImageView.topAnchor, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 0, width: 40, height: 40)
//        userProfileImageView.layer.cornerRadius = 40 / 2
//        userProfileImageView.layer.masksToBounds = true
        //
        userProfileImageView.anchor(top: topAnchor, left: nil, bottom: photoImageView.topAnchor, right: nil, paddingTop: 6, paddingLeft: 6, paddingBottom: 8, paddingRight: 0, width: 60, height: 60)
        userProfileImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
//        userProfileImageView.layer.cornerRadius = 8 //60 / 2
//        userProfileImageView.layer.masksToBounds = true
        userProfileImageView.layoutCornerRadiusAndShadow(cornerRadius: 60/2)
        
        //
        
//        usernameLabel.anchor(top: topAnchor, left: userProfileImageView.rightAnchor, bottom: photoImageView.topAnchor, right: optionsButton.leftAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        //
        usernameLabel.anchor(top: topAnchor, left: leftAnchor, bottom: photoImageView.topAnchor, right: optionsButton.leftAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        //
        optionsButton.anchor(top: topAnchor, left: nil, bottom: photoImageView.topAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 44, height: 0)
        
        
        photoImageView.anchor(top: userProfileImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        //nil for bottom anchor leaves space for bottom buttons // make pic square
        photoImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        // animation
        
        
        
        
       setupActionButtons()
        //Caption
        addSubview(captionLabel)
        captionLabel.anchor(top: likeButton.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
        addSubview(ratingsView)
        ratingsView.anchor(top: photoImageView.bottomAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: 200, height: 30)
        
    }
    fileprivate func setupActionButtons(){
        let stackView = UIStackView(arrangedSubviews: [likeButton, commentButton,sendMessageButton])
        stackView.distribution = .fillEqually
        addSubview(stackView)
        stackView.anchor(top: photoImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 120, height: 50)
        //
//        addSubview(bookmarkButton)
//        bookmarkButton.anchor(top: photoImageView.bottomAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 40, height: 50)
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var bombSoundEffect: AVAudioPlayer?
}

extension HomePostCell {
    
    func playAudio(sound: String, ext: String) {
        let url = Bundle.main.url(forResource: sound, withExtension: ext)!
        do {
            bombSoundEffect = try AVAudioPlayer(contentsOf: url)
            guard let bombSound = bombSoundEffect else { return }
            bombSound.prepareToPlay()
            bombSound.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
