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
import StatefulViewController
import NVActivityIndicatorView
import EasyAnimation




class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout, HomePostCellDelegate, UIViewControllerTransitioningDelegate, UIActionSheetDelegate, StatefulViewController, AppDelegateDelegate{
    func showWifiAlert() {
        print("Show wifi alert from delegate")
        self.alert(message: "Connected via Wifi.", title: "OK")
    }
    
    func showCellularAlert() {
         print("Show Cellular alert from delegate")
        self.alert(message: "Connected via Cellular.", title: "OK")
    }
    
    func showNoConnectionAlert() {
        print("Show no connection alert from delegate")
        self.alert(message: "No network connection.", title: "OK")
    }
    
   
 
    
    var bombSoundEffect: AVAudioPlayer?
    var posts = [Post]()
    var isFinishedRefreshing = false
    var morePostsButtonTopAnchor : NSLayoutConstraint?
    var morePostsButtonWidthAnchor : NSLayoutConstraint?
    var chain: EAAnimationFuture?
    var postCount: Int = 0
    
    static let cellID = "cellID"
    static let navTitle = "PROJECTS"
    static let followingNode = "following"
    static let postsNode = "posts"
    //    static let navFontName = "HelveticaNeue"
    static let likesNode = "likes"
    static let navFontName = "CloisterBlack-Light"
    static let navFontSizeLarge: CGFloat = 30
    static let navFontSizeSmall: CGFloat = 20
    
     let connection = Beyond2021Reachability()
    
    
    let EmptyLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkText
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "Somthing went worong. Tap to reload"
        return label
    }()
    
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
    
    let networkStatus: UILabel = {
        let label = UILabel()
        label.text = "Network Label "
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textColor = .red
        return label
    }()
    
    let hostNameLabel: UILabel = {
        let label = UILabel()
        label.text = " "
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textColor = .white
        return label
    }()
    
    let morePostsButton: UIButton  = {
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setTitle("More Posts?", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
        button.titleLabel?.textColor = .white
        button.addTarget(self, action: #selector(checkForPosts), for: .touchUpInside)
        button.backgroundColor = UIColor.tableViewBackgroundColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    @objc private func checkForPosts(){
        print("More post pressed")
        // scroll to the top
        hideMorePostsButton()
        if (self.posts.count > 0) {
            self.collectionView.setContentOffset(CGPoint(x:0,y:0), animated: true)
        }
        setMorePostButton()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("from view will appear")

//        if connection.networkConnectionAvailable() == true {
//                    setupInitialViewState()
//                    handleRefresh()
//
////            self.alert(message: "You can connect.", title: "OK")
//        } else {
//            self.alert(message: "You cannot connect.", title: "OK")
//        }
        
    }
   
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDel = UIApplication.shared.delegate as! AppDelegate
        appDel.delegate = self

//        checkReachAbility()
        setupLabels()
        collectionView?.backgroundColor = .white
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateFeed), name:         SharePhotoController.updateFeedNotificationName
            , object: nil)
        collectionView?.register(HomePostCell.self, forCellWithReuseIdentifier: HomeController.cellID)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView?.refreshControl = refreshControl
        noPostsAvailableLabel.alpha = 0
        setUpNavigationItems()
        view.insertSubview(morePostsButton, aboveSubview: collectionView)
        setMorePostButton()
        // Setup placeholder views
        loadingView = LoadingView()
        collectionView?.addSubview(loadingView!)
        emptyView = EmptyView()
        collectionView?.addSubview(emptyView!)
        let failureView = ErrorView(frame: view.frame)
        failureView.tapGestureRecognizer.addTarget(self, action: #selector(handleRefresh))
        errorView = failureView
        collectionView?.addSubview(errorView!)
//
        
        
        //        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "...", style: .plain, target: self, action: #selector(handleBitcoin))
        
        //        DispatchQueue.main.asyncAfter(deadline: .now() + 4.5) {
        //            self.setupBitcoin()
        //        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image:#imageLiteral(resourceName: "bitcoin"), style: .plain, target: self, action: #selector(handleBitcoin))
        
        //        handleRefresh()
        
        if connection.networkConnectionAvailable() == true {
            setupInitialViewState()
            handleRefresh()
            
            //            self.alert(message: "You can connect.", title: "OK")
        } else {
            self.alert(message: "You cannot connect.", title: "OK")
        }
        
        
        
    }
    private func checkConnection(){
       
        if connection.networkConnectionAvailable() == true {
            self.alert(message: "You can connect.", title: "OK")
        } else {
            self.alert(message: "You cannot connect.", title: "OK")
        }
        
        
    }
    
    func checkReachAbility(){
       
        
       
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    private func setMorePostButton() {
        morePostsButtonTopAnchor = morePostsButton.topAnchor.constraint(equalTo: view.topAnchor, constant:10)
        morePostsButtonTopAnchor?.isActive = true
        morePostsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        morePostsButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        morePostsButtonWidthAnchor = morePostsButton.widthAnchor.constraint(equalToConstant: 20)
        morePostsButtonWidthAnchor?.isActive = true
        
    }
    private func hideMorePostsButton(){
        morePostsButton.isEnabled = false
        morePostsButton.isHidden = true
        
    }
    private func ShowMorePostsButton(){
        morePostsButton.isEnabled = true
        morePostsButton.isHidden = false
    }
    
    
    
    private func animatePostButton(){
        ShowMorePostsButton()
        chain = UIView.animateAndChain(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.25, initialSpringVelocity: 0.0, options:  .curveEaseOut, animations: {
            self.morePostsButtonTopAnchor!.constant  += 140
            self.morePostsButton.layer.cornerRadius = 5.0
            self.morePostsButton.layer.transform = CATransform3DMakeScale(1.2, 1.2, 1.0)
            self.view.layoutIfNeeded()
        }, completion: nil).animate(withDuration: 2.0, delay: 0.0, usingSpringWithDamping: 0.25, initialSpringVelocity: 0.0, options: .curveEaseOut, animations: {
            self.morePostsButtonWidthAnchor!.constant += 80
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    
    
    @objc private func refreshPostsFromFailure() {
        handleRefresh()
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        hideMorePostsButton()
        setMorePostButton()
    }
    
    private func  setupLabels() {
        noPostsAvailableLabel.alpha = 1
        howToSeePostsLabel.alpha = 1
//        collectionView?.addSubview(networkStatus)
////        collectionView?.addSubview(howToSeePostsLabel)
//        networkStatus.anchor(top: collectionView?.topAnchor, left: collectionView?.leftAnchor, bottom: nil, right: collectionView?.rightAnchor, paddingTop: 40, paddingLeft: 20, paddingBottom: 0, paddingRight: -20, width: 0, height: 40)
//        networkStatus.centerXAnchor.constraint(equalTo: (collectionView?.centerXAnchor)!).isActive = true
//        howToSeePostsLabel.anchor(top: noPostsAvailableLabel.bottomAnchor, left: collectionView?.leftAnchor, bottom: nil, right: collectionView?.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: -20, width: 0, height: 60)
//        howToSeePostsLabel.centerXAnchor.constraint(equalTo: (collectionView?.centerXAnchor)!).isActive = true
    }
    
    
    @objc func handleUpdateFeed() {
        handleRefresh()
    }
    
    @objc func handleRefresh() {
        if self.lastState == StatefulViewControllerState.Loading { return }
        startLoading {
            print("completaion startLoading -> loadingState: \(self.currentState.rawValue)")
        }
        print("startLoading -> loadingState: \(self.lastState.rawValue)")
        print("Handling refresh...")
        playAudio(sound: "Smiling Face With Heart-Shaped Eyes", ext: "wav")
        posts.removeAll()
        collectionView?.reloadData() // stops index out of bounds crash
        fetchAllPosts()
    }
    
    private func fetchAllPosts(){
        fetchPosts()
        fetchFollowingUserIds()
    }
    
    
    fileprivate func fetchFollowingUserIds() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child(HomeController.followingNode).child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let userIdsDictionary = snapshot.value as? [String : Any] else { return }
            userIdsDictionary.forEach({ (key, value) in
                Database.fetchUserWithUIUD(uid: key, completion: { (user) in
                    self.fetchPostsWithUser(user: user)
                })
            })
        }) { (error) in
            print("Failed to fetch following user ids:", error)
        }
    }
    var myPosts = 0
    fileprivate func fetchPosts(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.fetchUserWithUIUD(uid: uid) { (user) in
            self.fetchPostsWithUser(user: user)
        }
    }
    
    
    
    fileprivate func fetchPostsWithUser(user: User) {
        let postReference = Database.database().reference().child(HomeController.postsNode).child(user.uid)
        postReference.observeSingleEvent(of: .value, with: { (postsSnapshot) in
            self.collectionView?.refreshControl?.endRefreshing() //iOS 10
            guard let dictionaries =  postsSnapshot.value as? [String: Any] else { return }
            dictionaries.forEach({ (key, value) in
                guard let dictionary = value as? [String: Any] else { return }
                var post = Post(user: user, dictionary: dictionary)
                post.id = key
                guard let currentUserUid = Auth.auth().currentUser?.uid else { return }
                Database.database().reference().child(HomeController.likesNode).child(key).child(currentUserUid).observeSingleEvent(of: .value, with: { (snapshot) in
                    if let value = snapshot.value as? Int, value == 1 {
                        post.hasLiked = true
                    } else {
                        post.hasLiked = false
                    }
                    self.posts.append(post)
                    self.posts.sort(by: { (post1, post2) -> Bool in
                        return post1.creationDate.compare(post2.creationDate ) == .orderedDescending
                    })
                    if self.posts.count < 1 {
                        self.isFinishedRefreshing = true
                    }
                    self.collectionView?.reloadData()
                    self.endLoading(error: nil, completion: {
                        print("completion endLoading -> loadingState: \(self.currentState.rawValue)")
                    })
                    print("endLoading -> loadingState: \(self.lastState.rawValue)")
                    
//                    self.collectionView?.reloadData()
                }, withCancel: { (err) in
                    print("could not get like info for post", err)
                })
            })
        }) { (error) in
            print("Failed to fetch posts", error)
        }
    }
    
    
    fileprivate func setUpNavigationItems() {
        navigationItem.title = HomeController.navTitle
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font:UIFont(name:HomeController.navFontName, size: HomeController.navFontSizeLarge) ?? ""]
        } else {
            // Fallback on earlier versions
        }
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font:UIFont(name:HomeController.navFontName, size: HomeController.navFontSizeSmall) ?? ""]
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "TakeAPic").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleCamera))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "...", style: .plain, target: self, action: #selector(handleBitcoin))
    }
    
    
    private func setupBitcoin(){
        
        
        /*
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
         */
        
    }
    
    @objc func handleCamera(){
        let cameraController = CameraController()
        present(cameraController, animated: true, completion: nil)
    }
    
    @objc private func handleBitcoin() {
        print("Handling bitcoin")
    }
    
    
}

extension HomeController {
    
    func hasContent() -> Bool {
        return posts.count > 0
    }
    
  
}



