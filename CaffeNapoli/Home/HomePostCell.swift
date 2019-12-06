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
    func didLike(for cell: HomePostCell, post:Post) // to hold like state
    //show more
    func showMore(post: Post, sender : HomePostCell)
    func swipeRightForCamera()
    func handlePinch(sender:UIPinchGestureRecognizer, imageView:UIImageView)
    func didUnlike(for cell: HomePostCell, post:Post)
    func updatelikescount( for post: Post, likesCount: String)
}


class HomePostCell: UICollectionViewCell {
    //
    var delegate : HomePostCellDelegate?
    // post to fill this cell
    var post: Post?{
        didSet {
            
            print(post?.hasLiked)
            //get the likes for this post

           
            
            guard let postImageUrl = post?.imageUrl else { return }
            photoImageView.loadImage(urlString: postImageUrl)
            if post?.user.username == "" {
                usernameLabel.text = post?.user.name
            } else {
                usernameLabel.text = post?.user.username
            }
            usernameLabel.text = post?.user.username
            guard let profileImageUrl = post?.user.profileImageURL else { return }
            userProfileImageView.loadImage(urlString: profileImageUrl)
//            captionLabel.text = post?.caption
            setupAttributedCaption()
            // Get the likes for this post
            guard let likesCount = post?.likesCount else { return}
            if Int(truncating: likesCount) > 0 {
                likeButton.setImage(#imageLiteral(resourceName: "icons8-heart-filled-50").withRenderingMode(.alwaysOriginal), for: .normal)            } else {
                 likeButton.setImage(#imageLiteral(resourceName: "icons8-heart-50").withRenderingMode(.alwaysOriginal), for: .normal)
                
            }
            
//            if  post?.hasLiked == true {
//                likeButton.setImage(#imageLiteral(resourceName: "icons8-heart-filled-50").withRenderingMode(.alwaysOriginal), for: .normal)
//            } else {
//                likeButton.setImage(#imageLiteral(resourceName: "icons8-heart-50").withRenderingMode(.alwaysOriginal), for: .normal)
//            }
//
           
         
                  /*
                likeButton.setImage( post?.hasLiked  == true ? #imageLiteral(resourceName: "icons8-heart-filled-50").withRenderingMode(.alwaysOriginal) :#imageLiteral(resourceName: "icons8-heart-50").withRenderingMode(.alwaysOriginal), for: .normal)
 */
                      
            
            
//            print("Post likes count: \(likesCount)")
            let likesAttributeText = NSMutableAttributedString(string: " Like", attributes: [NSAttributedString.Key.font: UIFont(name: "ClearSans-Bold", size: 16)!,NSAttributedString.Key.foregroundColor : UIColor.darkText])
                   likesAttributeText.append(NSAttributedString(string: " \(String(describing: likesCount))", attributes: [NSAttributedString.Key.font: UIFont(name: "UninstaW00-DemiBold", size: 16)!, NSAttributedString.Key.foregroundColor : UIColor.bytesBlueTextColor]))
                   
            self.likeLabel.attributedText = likesAttributeText
          
        }
    } //needs to be nil in the beginning
    
    fileprivate func setupAttributedCaption() {
        guard let post = self.post else { return }
        //Attributed text
//        print("Fb user is :", post.user.fbUsername)
        var attrText = ""
        if post.user.username == "" {
//            print("Facebook user", post.user.fbUsername)
            attrText = post.user.name!
            
        } else {
//            print("Regular user", post.user.username)
            attrText = post.user.username!
        }
        let attributedText = NSMutableAttributedString(string: attrText, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14),NSAttributedString.Key.foregroundColor : UIColor.lightRed])
        attributedText.append(NSAttributedString(string: " \(post.caption)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize:14),NSAttributedString.Key.foregroundColor : UIColor.tableViewBackgroundColor]))
        attributedText.append(NSAttributedString(string: "\n\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 4)]))
        let timeAgoDisplay = post.creationDate.timeAgoDisplay()
        // date
        attributedText.append(NSAttributedString(string: timeAgoDisplay, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20), NSAttributedString.Key.foregroundColor : UIColor.darkText]))
        captionLabel.attributedText = attributedText
        
        
        let nameTimeAttributeText = NSMutableAttributedString(string: attrText, attributes: [NSAttributedString.Key.font: UIFont(name: "ClearSans-Bold", size: 20)!,NSAttributedString.Key.foregroundColor : UIColor.darkText])
//        nameTimeAttributeText.append(NSAttributedString(string: "\n\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 4)]))
        nameTimeAttributeText.append(NSAttributedString(string: "  ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 4)]))
        nameTimeAttributeText.append(NSAttributedString(string: "• ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize:16),NSAttributedString.Key.foregroundColor :  UIColor.bytesBlueTextColor]))
//        let timeAgoDisplay = post.creationDate.timeAgoDisplay()
        // date
        nameTimeAttributeText.append(NSAttributedString(string: timeAgoDisplay, attributes: [NSAttributedString.Key.font: UIFont(name: "UninstaW00-DemiBold", size: 16)!, NSAttributedString.Key.foregroundColor : UIColor.bytesBlueTextColor]))
        usernameLabel.attributedText = nameTimeAttributeText
        
        // setup Replies
        let repliesAttributeText = NSMutableAttributedString(string: "Solutions", attributes: [NSAttributedString.Key.font: UIFont(name: "ClearSans-Bold", size: 16)!,NSAttributedString.Key.foregroundColor : UIColor.darkText])
        repliesAttributeText.append(NSAttributedString(string: " 28", attributes: [NSAttributedString.Key.font: UIFont(name: "UninstaW00-DemiBold", size: 16)!, NSAttributedString.Key.foregroundColor : UIColor.bytesBlueTextColor]))

        repliesLabel.attributedText = repliesAttributeText
        
        // setup shares
        let sharesAttributeText = NSMutableAttributedString(string: "Shares", attributes: [NSAttributedString.Key.font: UIFont(name: "ClearSans-Bold", size: 16)!,NSAttributedString.Key.foregroundColor : UIColor.darkText])
        sharesAttributeText.append(NSAttributedString(string: " 4", attributes: [NSAttributedString.Key.font: UIFont(name: "UninstaW00-DemiBold", size: 16)!, NSAttributedString.Key.foregroundColor : UIColor.bytesBlueTextColor]))
        
        sharesLabel.attributedText = sharesAttributeText
        
        
    }
    
    
    //MARK: - Profile ImageView
    //
    let userProfileImageView : CustomImageView = {
        let iv = CustomImageView()
//        iv.layer.borderColor = UIColor.NavBarYellow().cgColor
//        iv.layer.borderColor = UIColor.tableViewBackgroundColor.cgColor
//        iv.layer.borderWidth = 4
//        iv.layer.shadowColor = UIColor.tableViewBackgroundColor.cgColor
//        iv.layer.shadowRadius = 4
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        
        return iv
    }()
    //
    let photoImageView : CustomImageView = {
        let iv = CustomImageView()
        iv.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(handlePinch)))
        iv.isUserInteractionEnabled = true
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 8
        
//        contentView.layer.masksToBounds = true
       return iv
    }()
    //
    @objc func handlePinch(sender:UIPinchGestureRecognizer){
        print("Handling Pinch")
        
       
        
    }
    
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
//        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.font = UIFont.boldSystemFont(ofSize: 20)
//        label.textColor = UIColor.tabBarBlue()
        label.textColor = UIColor.black
        return label
    }()
    //
    //MARK: - Options Button
    lazy var optionsButton : UIButton = {
        let button = UIButton(type: .system)
//        button.setTitle("•••", for: .normal)
//        button.setImage(#imageLiteral(resourceName: "blMore").withRenderingMode(.alwaysOriginal), for: .normal)
        button.setImage(#imageLiteral(resourceName: "cellShareEM").withRenderingMode(.alwaysOriginal), for: .normal)
        button.setImage(#imageLiteral(resourceName: "cellShareSEL"), for: .selected)
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
      button.setImage(#imageLiteral(resourceName: "icons8-heart-50").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handlelike), for: .touchUpInside)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
//    lazy var likeLabel : UILabel = {
//        let label = UILabel()
//        label.text = "Like 280"
//        return label
//    }()
    
    //
    lazy var commentButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage( #imageLiteral(resourceName: "icons8-topic-50").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleComment), for: .touchUpInside)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    lazy var repliesButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage( #imageLiteral(resourceName: "icons8-topic-50").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleComment), for: .touchUpInside)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    let repliesLabel : UILabel = {
        let label = UILabel()
        label.text = "Replies 25"
        return label
    }()
    
    
    
    //
    let sharesButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "icons8-forward-arrow-50").withRenderingMode(.alwaysOriginal), for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    let sharesLabel : UILabel = {
        let label = UILabel()
        label.text = "Shares 4"
        return label
    }()
    
    //
   lazy var moreButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "icons8-more-48").withRenderingMode(.alwaysOriginal), for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    @objc func handleComment() {
        guard let post = self.post else { return }
        delegate?.didTapComment(post: post)
    }
    
    @objc func handlelike() {
        guard let post = self.post else { return }
        delegate?.didLike(for: self, post: post)// which cell was like = self
    }
    @objc func handleUnlike() {
        guard let post = self.post else { return }
        delegate?.didUnlike(for: self, post: post)// which cell was like = self
    }
    
    // MARK:- Caption Label
    let captionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        
//        backgroundColor = UIColor.cellBGColor()
        //
        addSubview(userProfileImageView)
        addSubview(usernameLabel)
//        addSubview(optionsButton)
        addSubview(photoImageView)
        //
        userProfileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: photoImageView.topAnchor, right: nil, paddingTop: 6, paddingLeft: 10, paddingBottom: 8, paddingRight: 0, width: 60, height: 60)
//        userProfileImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        userProfileImageView.layoutCornerRadiusAndShadow(cornerRadius: 60/2)
        //
        usernameLabel.anchor(top: topAnchor, left: userProfileImageView.rightAnchor, bottom: photoImageView.topAnchor, right:nil, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        usernameLabel.centerYAnchor.constraint(equalTo: userProfileImageView.centerYAnchor).isActive = true
        //
//        optionsButton.anchor(top: topAnchor, left: nil, bottom: photoImageView.topAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 44, height: 0)
        photoImageView.anchor(top: userProfileImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        //nil for bottom anchor leaves space for bottom buttons // make pic square
        photoImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        // animation
     setupActionButtons()
        //Caption
        
        
//        addSubview(captionLabel)
//        captionLabel.anchor(top: likeButton.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
        
        
        
//        addSubview(ratingsView)
//        ratingsView.anchor(top: photoImageView.bottomAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: 200, height: 30)
        let swipeToCamera = UISwipeGestureRecognizer(target: self, action: #selector(swipeRightForCamera))
        swipeToCamera.direction = .right
        addGestureRecognizer(swipeToCamera)
        
        
        
        //
        //userinteraction StackView
//        let redView = UIView()
//        redView.backgroundColor = .red
//        let blueView = UIView()
//        blueView.backgroundColor = .blue
//        let yellowView = UIView()
//        yellowView.backgroundColor = .yellow
//        let greenView = UIView()
//        greenView.backgroundColor = .green
//
//        let interActiveStackView = UIStackView(arrangedSubviews: [redView, blueView, yellowView, greenView])
//        interActiveStackView.distribution = .equalSpacing
//        interActiveStackView.axis = .horizontal
        
//        addSubview(interActiveStackView)
//        interActiveStackView.anchor(top: photoImageView.bottomAnchor, left: leftAnchor, bottom: nil
//            , right: rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 40)
        
        
        
    }
    
    @objc fileprivate func swipeRightForCamera(){
        print("Trying to swipe right from home cell")
        delegate?.swipeRightForCamera()
    }
    
    fileprivate func setupActionButtons(){
//        let stackView = UIStackView(arrangedSubviews: [likeButton, commentButton,sendMessageButton])
//        stackView.distribution = .fillEqually
//        addSubview(stackView)
//        stackView.anchor(top: photoImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 120, height: 50)
        
        
        
        
        
        
                let likeStackView = UIStackView(arrangedSubviews: [likeButton, likeLabel])
                let repliesStackView = UIStackView(arrangedSubviews: [repliesButton, repliesLabel])
                let sharesStackView = UIStackView(arrangedSubviews: [sharesButton, sharesLabel])
                let moreStackView = UIStackView(arrangedSubviews: [moreButton])
        
                let interActiveStackView = UIStackView(arrangedSubviews: [likeStackView, repliesStackView, sharesStackView, moreStackView])
                interActiveStackView.distribution = .equalSpacing
                interActiveStackView.axis = .horizontal

                addSubview(interActiveStackView)
                interActiveStackView.anchor(top: photoImageView.bottomAnchor, left: leftAnchor, bottom: nil
                    , right: rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 40)
        
        
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var bombSoundEffect: AVAudioPlayer?
    //MARK: - Interaction Labels
    // like
    lazy var likeLabel: UILabel = {
        let label = UILabel()
        print("label is set")
//        let likes = post
        let post = self.post
        let likesCount = post?.likesCount
//        let likesCount = post.li
//        let attributedText = NSMutableAttributedString(string: "", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
//        attributedText.append(NSAttributedString(string: "Like", attributes:[NSAttributedString.Key.foregroundColor:UIColor.bytesDarkTextColor, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)]))
        //
//        let likesAttributeText = NSMutableAttributedString(string: " Like", attributes: [NSAttributedString.Key.font: UIFont(name: "ClearSans-Bold", size: 16)!,NSAttributedString.Key.foregroundColor : UIColor.darkText])
//        likesAttributeText.append(NSAttributedString(string: " \(String(describing: likesCount))", attributes: [NSAttributedString.Key.font: UIFont(name: "UninstaW00-DemiBold", size: 16)!, NSAttributedString.Key.foregroundColor : UIColor.bytesBlueTextColor]))
//
//       label.attributedText = likesAttributeText
        

        
//        label.attributedText = attributedText
       
        label.numberOfLines = 1
//        label.textAlignment = .center
        return label
    }()
    
    
    
    
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
