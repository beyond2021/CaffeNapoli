//
//  HomeController.swift
//  CaffeNapoli
//
//  Created by Kev1 on 10/31/17.
//  Copyright © 2017 Kev1. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation
import Lottie
import Social
import Alamofire



/*
{
    "rules": {
        ".read": "auth != null",
        ".write": "auth != null"
    }
}
 */




class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout, HomePostCellDelegate, UIViewControllerTransitioningDelegate, UIActionSheetDelegate{
    func handlePinch(sender: UIPinchGestureRecognizer, imageView: UIImageView) {
        print("Handling for home")
    }
    
   
    
   
    func swipeRightForCamera() {
                print("Showing Camera")
        handleCamera()
    }
    
    
    func showMore(post: Post, sender : HomePostCell) {

     
        print("showing more from home controller")

        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    
        actionSheet.addAction(UIAlertAction(title: "Share to Facebook", style: .default, handler: { (_) in
            print("facebook Action")

        }))
        actionSheet.addAction(UIAlertAction(title: "Share on Instagram", style: .default, handler: { (_) in
            print("Instagram Action")
        }))
        actionSheet.addAction(UIAlertAction(title: "Copy Link", style: .default, handler: { (_) in
            print("Copy  Action")
        }))
        actionSheet.addAction(UIAlertAction(title: "Report", style: .default, handler: { (_) in
            print("Report Action")
        }))
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            print("Cancel button tapped")
        }
        
        actionSheet.addAction(cancel)
        present(actionSheet, animated: true, completion: nil)
 
    }
    
    
    
    let noPostsAvailableLabel: UILabel = {
        let label = UILabel()
        label.text = " No posts available "
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textColor = .white
        return label
    }()
    
    let howToSeePostsLabel: UILabel = {
        let label = UILabel()
        label.text = " Please make sure that you are connected to the internet and create a post by clicking the + button at the bottom or search for and follow users with the search button below "
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .white
        return label
    }()
    

    var posts = [Post]()
    let cellID = "cellID"
//iOS9
//    let refreshControl = UIRefreshControl()
//    let curvedView = CurvedView()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLabels()
        collectionView?.backgroundColor = .white
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateFeed), name:         SharePhotoController.updateFeedNotificationName
            , object: nil)
        collectionView?.register(HomePostCell.self, forCellWithReuseIdentifier: cellID)
//        Refresh Control
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView?.refreshControl = refreshControl
        noPostsAvailableLabel.alpha = 0
        setUpNavigationItems()
//        fetchAllPosts()
        handleRefresh()
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "...", style: .plain, target: self, action: #selector(handleBitcoin))
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 4.5) {
//            self.setupBitcoin()
//        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image:#imageLiteral(resourceName: "bitcoin"), style: .plain, target: self, action: #selector(handleBitcoin))
        
        
    }
   
    
    
    private func  setupLabels() {
        noPostsAvailableLabel.alpha = 1
        howToSeePostsLabel.alpha = 1
        collectionView?.addSubview(noPostsAvailableLabel)
        collectionView?.addSubview(howToSeePostsLabel)
        noPostsAvailableLabel.anchor(top: collectionView?.topAnchor, left: collectionView?.leftAnchor, bottom: nil, right: collectionView?.rightAnchor, paddingTop: 40, paddingLeft: 20, paddingBottom: 0, paddingRight: -20, width: 0, height: 40)
        noPostsAvailableLabel.centerXAnchor.constraint(equalTo: (collectionView?.centerXAnchor)!).isActive = true
        howToSeePostsLabel.anchor(top: noPostsAvailableLabel.bottomAnchor, left: collectionView?.leftAnchor, bottom: nil, right: collectionView?.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: -20, width: 0, height: 60)
        howToSeePostsLabel.centerXAnchor.constraint(equalTo: (collectionView?.centerXAnchor)!).isActive = true
    }
    
    
    @objc func handleUpdateFeed() {
        handleRefresh()
    }
    
    @objc func handleRefresh() {
        print("Handling refresh...")
        playAudio(sound: "Smiling Face With Heart-Shaped Eyes", ext: "wav")
        posts.removeAll()
        collectionView?.reloadData() // stops index out of bounds crash
        fetchAllPosts()
    }
    //
    fileprivate func fetchAllPosts(){
                fetchPosts()
        fetchFollowingUserIds()
//        fetchFacebookUserPost()
    }
    
    
//    Get the user ids of all the people that i am following
    fileprivate func fetchFollowingUserIds() {
//        LOGIC
//        get to following node user ids
        guard let uid = Auth.auth().currentUser?.uid else { return }
    Database.database().reference().child("following").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            //
//            print(snapshot.value)
            //iterate through dictionary of followers
            guard let userIdsDictionary = snapshot.value as? [String : Any] else { return }
            userIdsDictionary.forEach({ (key, value) in
//                 ORYV0lwAeONE639ha7KXcv8IdA12 = 1;
                Database.fetchUserWithUIUD(uid: key, completion: { (user) in
                    // fetch posts
                    self.fetchPostsWithUser(user: user)
                })
            })
        }) { (error) in
            //
            print("Failed to fetch following user ids:", error)
        }
    }
    var myPosts = 0
//     Get the id of the logged in user
//     Fetch Posts from database for this user
    fileprivate func fetchPosts(){
//        print("attempting to fetch post from firebase")
//         Method 1: Observe what is happening at this node (posts-node then uid-node)
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.fetchUserWithUIUD(uid: uid) { (user) in
            self.fetchPostsWithUser(user: user)
        }
    }
    
//    Fetch all posts of the people that this logged in user is folowing
    fileprivate func fetchPostsWithUser(user: User) {
        
//        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        print("Facebook user:", user.uid)
        
        let postReference = Database.database().reference().child("posts").child(user.uid)
        
//         we need all new values at this point
        postReference.observeSingleEvent(of: .value, with: { (postsSnapshot) in
//             stop spinner
            self.collectionView?.refreshControl?.endRefreshing() //iOS 10
//            print(postsSnapshot.value)
//             For us to user our postSnapshot dictionary we get back . we have to cast it from type ANY to Type [String:Any]
            guard let dictionaries =  postsSnapshot.value as? [String: Any] else { return }
//            we are optionally binding this dictionary to postsSnapshot.value
//            to get each dictionary
            dictionaries.forEach({ (key, value) in
//                first cast dictionar as? []
                guard let dictionary = value as? [String: Any] else { return }
//                let dummyUser = User(dictionary: ["username" : "Keevin"])
                var post = Post(user: user, dictionary: dictionary)//var because structs need to be a var to change properties
                post.id = key
//                let post = Post(dictionary: dictionary)
//                here we create each post with a snapshot dictionary we get from firebase
//                Start filling up post array by appending
//                LIKES from Firebase
                guard let currentUserUid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("likes").child(key).child(currentUserUid).observeSingleEvent(of: .value, with: { (snapshot) in
//                    print(snapshot) // expecting 1
//                    creating a like
                    if let value = snapshot.value as? Int, value == 1 {
//                   post has been liked
                        post.hasLiked = true
                    } else {
                        post.hasLiked = false
                    }
                    self.posts.append(post)
                    self.posts.sort(by: { (post1, post2) -> Bool in
                        return post1.creationDate.compare(post2.creationDate ) == .orderedDescending
                    })
//                    stop refreshing
                    if self.posts.count < 1 {
                        self.isFinishedRefreshing = true
                    }
//                     UI
                    self.collectionView?.reloadData()
                }, withCancel: { (err) in
                    print("could not get like info for post", err)
                })
            })
        }) { (error) in
//            get the error from the cancel block if there is any
            print("Failed to fetch posts", error)
        }
    }
    
    fileprivate func setUpNavigationItems() {
//        navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "CaffeNapLogoSmallBlack"))
//        let navController = CustomNavigationController()
        navigationItem.title = "Projects"
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font:UIFont(name:"HelveticaNeue", size: 30) ?? ""]
        } else {
            // Fallback on earlier versions
        }
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "TakeAPic").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleCamera))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "...", style: .plain, target: self, action: #selector(handleBitcoin))
        
    }
    private func setupBitcoin(){
        Alamofire.request("https://api.coindesk.com/v1/bpi/currentprice.json").responseJSON { (response) in
            print(response)
            if let bitcoinJSON = response.result.value {
                // we have good json
                let bitcoinObject : Dictionary = bitcoinJSON as! Dictionary<String, Any> //sets up a dictionay and put in json response object.
//                 print(bitcoinObject)
                let bpiObject : Dictionary = bitcoinObject["bpi"] as! Dictionary<String, Any> // first level bpi
                let usdObject : Dictionary = bpiObject["USD"] as! Dictionary<String, Any>
                let rate : NSNumber = usdObject["rate_float"] as! NSNumber
                let rateFloat: Float = Float(truncating: rate)
                //
                let now = NSDate()
                let df = DateFormatter()
                df.dateFormat = "hh:mm a"
                let result = df.string(from: now as Date)
//                let price = "$3700.00"
                let dateString = result
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Bitcion price at \(dateString) :$\(rateFloat)", style: .plain, target: self, action: #selector(self.handleBitcoin))
               
                
            }
            print("Loading web services")
        }
       
       
        
    }
    
    @objc func handleCamera(){
        let cameraController = CameraController()
        present(cameraController, animated: true, completion: nil)
    }
    
    @objc private func handleBitcoin() {
        print("Handling bitcoin")
    }
//MARK:- DataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if posts.count > 0 {
            noPostsAvailableLabel.alpha = 0
            howToSeePostsLabel.alpha = 0
        } else {
            noPostsAvailableLabel.alpha = 1
        }
        return posts.count
    }
    var isFinishedRefreshing = false
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! HomePostCell
        cell.layer.shadowRadius = 5;
        cell.layer.shadowOpacity = 0.25;
        cell.post = posts[indexPath.item]
            cell.delegate = self
        return cell
     
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //
//        print("I selected :", indexPath.item)
        let post = posts[indexPath.item]
//        print(post.user)
        if post.user.uid == Auth.auth().currentUser?.uid {
            let editPostController = EditPhotoController()
            self.navigationController?.pushViewController(editPostController, animated: true)
        } else {
            return
        }
    }

    
//    Cell sizes
    func collectionView(_ collectionView: UICollectionView,
                                 layout collectionViewLayout: UICollectionViewLayout,
                                 minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //How tall the cell is
        var height: CGFloat = 40 + 8 + 8 // Username UserProfile
        height += view.frame.width
        //
        height += 50// for bottom buttons
        // Caption label
        height += 60
        return CGSize(width: view.frame.width, height: height)
    }
//MARK:-  HomePostCellDelegate Methods
    func didTapComment(post: Post) {
//        print(post.caption)
        let commentsController = CommentsController(collectionViewLayout: UICollectionViewFlowLayout())
//        Pass the post to the commentscontroller here
        commentsController.post = post
//        Push new viewcontroller on to the stack here
        navigationController?.pushViewController(commentsController, animated: true)
    }
    
//MARK:-    Saving the like state logic
    func didLike(for cell: HomePostCell) {
        guard let indexpath = collectionView?.indexPath(for: cell) else { return }
//         get the post
        var post = self.posts[indexpath.item]
        // print(post.caption)
        // Introduce a 5th node in firebase called likes
        guard let postId = post.id else { return }
        //current user uid
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let values = [uid:post.hasLiked == true ? 0 : 1] // me liking or unliking this post
        print("like :", post.hasLiked)
        if post.hasLiked == false {
            animateLikes()
            playAudio(sound: "OK Hand Sign", ext: "wav")
        }
        Database.database().reference().child("likes").child(postId).updateChildValues(values) { (error, reference) in
            if let err = error {
                print("Could not like post", err)
                return
            }
            // success
//            print("Successfully liked post")
            post.hasLiked = !post.hasLiked // toggle like button
            self.posts[indexpath.item] = post // because of structs
            self.collectionView?.reloadItems(at: [indexpath])
        }
    }
   
    
    
    
    //MARK:- Animation
    fileprivate func animateLikes() {
        (0...10).forEach { (_) in
            generateAnimatedViews()
        }
    }
    private func generateAnimatedViews() {
        let image = drand48() > 0.5 ? #imageLiteral(resourceName: "heart") : #imageLiteral(resourceName: "thumbsUp")
        let imageView = UIImageView(image: image)
        let dimensions = 20 + drand48() * 10
        imageView.frame = CGRect(x: 0, y: 0, width: dimensions, height: 30)
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.path = customPath().cgPath
        animation.duration = 2 + drand48() * 3
        animation.fillMode = CAMediaTimingFillMode.forwards //removes from view
        animation.isRemovedOnCompletion = false
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        imageView.layer.add(animation, forKey: nil)
        view?.addSubview(imageView)
    }
    // MARK:- Sound
    var bombSoundEffect: AVAudioPlayer?
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


func customPath() -> UIBezierPath {
    let path = UIBezierPath()
//    starting point
    path.move(to: CGPoint(x: 20, y: 480))
    let endPoint = CGPoint(x: 600, y: 480)
//     path.addLine(to: endPoint)
    let randonYShift = 200 + drand48() * 300
    let cp1 = CGPoint(x: 120, y: 380 - randonYShift)
    let cp2 = CGPoint(x: 200, y: 580 + randonYShift)
    path.addCurve(to: endPoint, controlPoint1: cp1, controlPoint2: cp2)
    return path
}

class CurvedView : UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func draw(_ rect: CGRect) {
        // we will do some fancy drawing
        let path = customPath()
        path.lineWidth = 3
        path.stroke()
    }
}
