//
//  HomeController.swift
//  CaffeNapoli
//
//  Created by Kev1 on 10/31/17.
//  Copyright © 2017 Kev1. All rights reserved.
//

import UIKit
import Firebase


class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout, HomePostCellDelegate {
    
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
        label.text = " Please create a post by clicking the + button at the bottom or search for and follow users with the search button below "
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .white
        return label
    }()
    
    
    
    
    //
    var posts = [Post]()
    //
    let cellID = "cellID"
    //
    //iOS9
//    let refreshControl = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLabels()
       
//        collectionView?.backgroundColor = .white
        collectionView?.backgroundColor = UIColor.napoliGold()
        //Setup to catch updateField notification from SharePhotoController
//        let name = NSNotification.Name("UpdateFeed")
        //using the class property from SharePhotoController
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateFeed), name:         SharePhotoController.updateFeedNotificationName
, object: nil)
        
        // register custom cell
        collectionView?.register(HomePostCell.self, forCellWithReuseIdentifier: cellID)
        //Refresh Control
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView?.refreshControl = refreshControl
        //title
        setUpNavigationItems()
  
        fetchAllPosts()
       
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
        posts.removeAll()
        collectionView?.reloadData() // stops index out of bounds crash
        fetchAllPosts()
        
      
    }
    //
    fileprivate func fetchAllPosts(){
                fetchPosts()
        fetchFollowingUserIds()
    }
    
    //MARK:- Get the usee ids of all the people that i am following
    fileprivate func fetchFollowingUserIds() {
        //LOGIC
        //1: get to following node user ids
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
    
    
  
    //MARK:- Get the id of the loggen in user
    // Fetch Posts from database for this user
    fileprivate func fetchPosts(){
//        print("attempting to fetch post from firebase")
        // Method 1: Observe what is happening at this node (posts-node then uid-node)
        guard let uid = Auth.auth().currentUser?.uid else { return }
     
        Database.fetchUserWithUIUD(uid: uid) { (user) in
            //
            self.fetchPostsWithUser(user: user)
        }
        
    }
    //MARK:- Fetch all posts of the people that this logged in user is folowing
    fileprivate func fetchPostsWithUser(user: User) {
        
//        guard let uid = Auth.auth().currentUser?.uid else { return }
        let postReference = Database.database().reference().child("posts").child(user.uid)
        
        // because we need all thew valuse at this point
        postReference.observeSingleEvent(of: .value, with: { (postsSnapshot) in
            // stop spinner
            self.collectionView?.refreshControl?.endRefreshing() //iOS 10
            
            //print(postsSnapshot.value)
            // For us to user our postSnapshot dictionary we get back . we have to cast it from type ANY to Type [String:Any]
            guard let dictionaries =  postsSnapshot.value as? [String: Any] else { return } //we are optionally binding this dictionary to postsSnapshot.value
            // to get each dictionary
            dictionaries.forEach({ (key, value) in
                
                //first cast dictionar as? []
                guard let dictionary = value as? [String: Any] else { return }
                //                    let dummyUser = User(dictionary: ["username" : "Keevin"])
                
                var post = Post(user: user, dictionary: dictionary)//var because styrcts need to be a var to change properties
                post.id = key
                
                //                let post = Post(dictionary: dictionary)// here we create each post with a snapshot dictionary we get from firebase
                //                // Start filling up post array by appending
                //LIKES from Firebase
                guard let currentUserUid = Auth.auth().currentUser?.uid else { return }
                
                Database.database().reference().child("likes").child(key).child(currentUserUid).observeSingleEvent(of: .value, with: { (snapshot) in

                    
//                    print(snapshot) // expecting 1
                    //creating a like
                    if let value = snapshot.value as? Int, value == 1 {
                        //post has been liked
                        post.hasLiked = true
                    } else {
                        post.hasLiked = false
                        
                    }
                    self.posts.append(post)
                    //
                    self.posts.sort(by: { (post1, post2) -> Bool in
                        //
                        return post1.creationDate.compare(post2.creationDate ) == .orderedDescending
                    })
                    // stop refreshing
                    if self.posts.count < 1 {
                        self.isFinishedRefreshing = true
                        
                    }
                    // UI
                    self.collectionView?.reloadData()
                    //
                }, withCancel: { (err) in
                    //
                    print("could not get like info for post", err)
                })
               
//                self.posts.append(post)
                
            })
//            self.posts.sort(by: { (post1, post2) -> Bool in
//                //
//                return post1.creationDate.compare(post2.creationDate ) == .orderedDescending
//            })
            
            //After we fill up the posts array we can reset the UI ()
//            self.collectionView?.reloadData()
            
            
            
        }) { (error) in
            // get the error from the cancel block if there is any
            print("Failed to fetch posts", error)
        }

    }
    
    //
    fileprivate func setUpNavigationItems() {
        navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "CaffeNapLogoSmallBlack"))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "camera3").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleCamera))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image:#imageLiteral(resourceName: "shopping-cart-50").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleCart))
    }
    @objc func handleCart(){
        print("handling cart....")
        let shoppingCartController = ShoppingCartController()
        present(shoppingCartController, animated: true, completion: nil)
        
    }
    
    @objc func handleCamera(){
        
        print("Showing Camera")
        
        let cameraController = CameraController()
        present(cameraController, animated: true, completion: nil)
    }
    
    //DataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if posts.count > 0 {
            noPostsAvailableLabel.alpha = 0
            howToSeePostsLabel.alpha = 0
            
        }
        
        //
        return posts.count
    }
    //
    var isFinishedRefreshing = false
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! HomePostCell
        
            cell.post = posts[indexPath.item]
            cell.delegate = self
        
        return cell
     
    }
    
    
    //Cell sizes
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
    // HomePostCellDelegate Methjods
    func didTapComment(post: Post) {
       
        //
        print(post.caption)
        let commentsController = CommentsController(collectionViewLayout: UICollectionViewFlowLayout())
        //pass the post to the commentscontroller here
        commentsController.post = post
        
        // Push new viewcontroller on to the stack here
        navigationController?.pushViewController(commentsController, animated: true)
        
    }
    //MARK:- Saving the like state logic
    func didLike(for cell: HomePostCell) {
       
        guard let indexpath = collectionView?.indexPath(for: cell) else { return }
        // we can now get the post
        var post = self.posts[indexpath.item]
        //check
       // print(post.caption)
        // Introduce a 5th node in firebase called likes
        guard let postId = post.id else { return }
        //current user uid
        guard let uid = Auth.auth().currentUser?.uid else { return }
      
        
        let values = [uid:post.hasLiked == true ? 0 : 1] // me liking or unliking this post
        Database.database().reference().child("likes").child(postId).updateChildValues(values) { (error, reference) in
            //
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
    
}
