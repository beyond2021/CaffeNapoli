//
//  HomeController.swift
//  CaffeNapoli
//
//  Created by Kev1 on 10/31/17.
//  Copyright © 2017 Kev1. All rights reserved.
//

import UIKit
import Firebase


class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    //
    var posts = [Post]()
    //
    let cellID = "cellID"
    //
    //iOS9
    // let refreshControl = UIRefreshControl
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
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
        // get the posts
//        fetchPosts()
        // the follow a certain user / Appending post to list
//        Database.fetchUserWithUIUD(uid: "kcrwzqypLKXrbFdzgBqYvm39Noh2") { (user) in
//            self.fetchPostsWithUser(user: user)
//        }
//        Database.fetchUserWithUIUD(uid: "nldfN1xNBtUr7MEv0tHvbYTKhxA2") { (user) in
//            self.fetchPostsWithUser(user: user)
//        }
        
        fetchAllPosts()
       
    }
    @objc func handleUpdateFeed() {
        handleRefresh()
    }
    
    @objc func handleRefresh() {
        print("Handling refresh...")
        posts.removeAll()
        fetchAllPosts()

    }
    //
    fileprivate func fetchAllPosts(){
                fetchPosts()
        fetchFollowingUserIds()
    }
    
    
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
    
    
  
    //Fetch Posts
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
                
                let post = Post(user: user, dictionary: dictionary)
                
                //                let post = Post(dictionary: dictionary)// here we create each post with a snapshot dictionary we get from firebase
                //                // Start filling up post array by appending
                
               
                self.posts.append(post)
                
            })
            self.posts.sort(by: { (post1, post2) -> Bool in
                //
                return post1.creationDate.compare(post2.creationDate ) == .orderedDescending
            })
            
            //After we fill up the posts array we can reset the UI ()
            self.collectionView?.reloadData()
            
            
            
        }) { (error) in
            // get the error from the cancel block if there is any
            print("Failed to fetch posts", error)
        }

    }
    
    //
    fileprivate func setUpNavigationItems() {
        navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "CaffeNapLogoSmallBlack"))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "camera3").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleCamera))
      
    }
    
    @objc func handleCamera(){
        
        print("Showing Camera")
        
        let cameraController = CameraController()
        present(cameraController, animated: true, completion: nil)
    }
    
    //DataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //
        return posts.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! HomePostCell
        //cell.backgroundColor = .purple
        // Set up post in custom cell here
        cell.post = posts[indexPath.item]
        
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
    //
    
}
