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
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
        // register custom cell
        collectionView?.register(HomePostCell.self, forCellWithReuseIdentifier: cellID)
        //title
        setUpNavigationItems()
        // get the posts
        fetchPosts()
        
    }
    //Fetch Posts
    // Fetch Posts from database for this user
    fileprivate func fetchPosts(){
//        print("attempting to fetch post from firebase")
        // Method 1: Observe what is happening at this node (posts-node then uid-node)
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let postReference = Database.database().reference().child("posts").child(uid)
        
        // because we need all thew valuse at this point
        postReference.observeSingleEvent(of: .value, with: { (postsSnapshot) in
            //print(postsSnapshot.value)
            // For us to user our postSnapshot dictionary we get back . we have to cast it from type ANY to Type [String:Any]
            guard let dictionaries =  postsSnapshot.value as? [String: Any] else { return } //we are optionally binding this dictionary to postsSnapshot.value
            // to get each dictionary
            dictionaries.forEach({ (key, value) in
                //   print("key \(key), Value \(value)")
                // we get
                //                key -KxhmnGwV2C_WG3kFf9L, Value {
                //                    imageUrl = "https://firebasestorage.googleapis.com/v0/b/caffenapoli-8774f.appspot.com/o/posts%2F24312562-EBBA-4751-BF53-F108038141CF?alt=media&token=f2ac34ed-9974-4326-80b1-71b04c23d92f";
                //                }
                
                //first cast dictionar as? []
                guard let dictionary = value as? [String: Any] else { return }
                
                
                let post = Post(dictionary: dictionary)// here we create each post with a snapshot dictionary we get from firebase
                //                // Start filling up post array by appending
                self.posts.append(post)
                
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
