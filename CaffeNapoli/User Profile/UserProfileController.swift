//
//  UserProfileController.swift
//  CaffeNapoli
//
//  Created by Kev1 on 10/10/17.
//  Copyright © 2017 Kev1. All rights reserved.
//

import UIKit
import Firebase

class UserProfileController : UICollectionViewController, UICollectionViewDelegateFlowLayout {
    let cellID = "cellID"
    var userID:  String? // to show correct user from UserSearchController
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
       
        //Fetch User
        fetchUser()
        // We need to registewrb the collectionview with a header
        collectionView?.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerID")
        //UserProfileHeader
//        collectionView?.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerID")
        // Registering collectionview cell id
        collectionView?.register(UserProfilePhotoCell.self, forCellWithReuseIdentifier: cellID)
        //Setup the gear icon
        setupLogoutButton()
        // Fetch Posts from database
        // fetchPosts()
        //fetchOrderedPosts()
        
    }
    //
    var posts = [Post]() // An empty array to hold our posts we get from FB
    /*
    
 */
    //
    fileprivate func fetchOrderedPosts() {
//        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        guard let uid = user?.uid else { return }
        
        let postReference = Database.database().reference().child("posts").child(uid)
        // order post by creation date .queryOrdered(byChild: "creationDate")
        
        // perhaps later on we will implement some pagination of data
        
        postReference.queryOrdered(byChild: "creationDate").observe(.childAdded, with: { (snapshot) in
          
//            print(snapshot.key, snapshot.value)
            
            guard let dictionary = snapshot.value as? [String : Any] else { return }
              
            guard let user = self.user else { return }
            
            let post = Post(user: user, dictionary: dictionary)
            self.posts.insert(post, at: 0) // puts it in the front
//            self.posts.append(post)// append goes to the back of the array
            
            self.collectionView?.reloadData()
            
        }) { (error) in
            //
            print("Failed to nfetch ordered post", error)
        }
    }
    
    //Logout
    fileprivate func setupLogoutButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "gear").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleLogout))
        
    }
    @objc func handleLogout() {
      print("Logging out")
        //Alert controller with actionsheet
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        //Add Action
        alertController.addAction(UIAlertAction(title: "Log Out Caffe Napoli", style: .destructive, handler: { (_) in
            //
//            print("Perform Logout")
            do {
           try Auth.auth().signOut()
             //WE NEED TO PRE4SENT SOME KING OF LOGIN CONTROLLER
                
                let loginController = LoginController()
                let navigationController = UINavigationController(rootViewController: loginController)
                self.present(navigationController, animated: true, completion: nil)
                
                
            } catch let signOutError {
                print("Failed to sign Out", signOutError)
            }
            
            
            
        }))
        //Add in the cancel button
//        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
//            print("Perform Cancel")
//        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    // size for cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2) / 3
        
        return CGSize(width: width, height: width)
    }
    //spacing of cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    //Number of items
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //
        return posts.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! UserProfilePhotoCell        //cell.backgroundColor = .purple
        cell.post = posts[indexPath.row]
        
        return cell
    }
    
    
    //Setting up the header for the collectionview on the profile page
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        // here u have to return a UICollectionReusableView
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerID", for: indexPath) as! UserProfileHeader // we can use bang! because we registered the UserProfileHeader in viewDidLoad
        
        //
        header.user = self.user //THIS LINE SET THE USER IN HEADERVIEWCONTROLLER
        //
        //IT IS WRONG TO TRY TO ADD SUBVIEWS TO HERE
        return header
    }
    //Must specify the size of the header UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        //
        return CGSize(width: view.frame.width, height: 200)
    }
    
    
    //private - this func only accessable in UserProfileController
    var user: User?
    fileprivate func fetchUser() {
        //1: to fecth the user's name'
        //Database.database().reference() -> https://console.firebase.google.com/project/caffenapoli-8774f/database/data
        //This is the root of your database
        // .child("users") -> gets u to the Node
        // 2nd -> .child(Auth.auth().currentUser?.uid)
        // To unwrap
        //Correct use select logic
        let uid = userID ?? (Auth.auth().currentUser?.uid ?? "")
        //1: check if userID(the one set it in UserSearchController) is not nil use it else user current user id
        //
        //guard let uid = Auth.auth().currentUser?.uid else { return }
        //.observeSingleEvent(of: .value, with: { (snapshot) in.-> observe this one event and stop
        Database.fetchUserWithUIUD(uid: uid) { (user) in
            //
            self.user = user
            self.navigationItem.title = self.user?.username
            
            // TO STOP FECTHING DICTIONARY TWICE
            self.collectionView?.reloadData()
            // now we fetch the posts
            self.fetchOrderedPosts()
        }
        
        
    }
}

