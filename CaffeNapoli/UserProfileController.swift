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
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
        //navigationItem.title = "Caffe Napoli User Profile"
        //Fetch the user title
        //1: get ur user id -> Auth.auth().currentUser?.uid
        
        navigationItem.title = Auth.auth().currentUser?.uid
        
        //Fetch User
        fetchUser()
        // We need to registewrb the collectionview with a header
        collectionView?.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerID")
        //UserProfileHeader
//        collectionView?.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerID")
        // Registering collectionview cell id
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        //Setup the gear icon
        setupLogoutButton()
        
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
            print("Perform Logout")
            do {
           try Auth.auth().signOut()
             //WE NEED TO PRE4SENT SOME KING OF LOGIN CONTROLLER
                
                
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
        return 7
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
        cell.backgroundColor = .purple
        
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
        guard let uid = Auth.auth().currentUser?.uid else { return } // return if we cant get the user id
        //.observeSingleEvent(of: .value, with: { (snapshot) in.-> observe this one event and stop
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            //
            print(snapshot.value ?? "")
            /*
             {
             profileImageURL = "https://firebasestorage.googleapis.com/v0/b/caffenapoli-8774f.appspot.com/o/profile_Images%2F22B102FC-E48C-40C8-8FD1-F384560D9BF8?alt=media&token=3149813c-e942-4b70-ad99-71d3aca7669e";
             username = Dummy13;
             }
            */
            //snapshot is a dictionary?
            guard let dictionary = snapshot.value as? [String: Any] else { return } //
            
            //NOW WITH USER STRUCT
            self.user = User(dictionary: dictionary) // loading user dic with snapshot dictionary from above
            self.navigationItem.title = self.user?.username
            
            // TO STOP FECTHING DICTIONARY TWICE
            self.collectionView?.reloadData()
            
        }) { (err) in
            //
            print("Failed to fetch user:", err)
        }
        
        
    }
}
// TO STOP FECTHING DICTIONARY TWICE
struct User {
    //
    let username : String
    let profileImageURL : String
    
    //Constructor to setup these properties
    init(dictionary: [String:Any]) {
        // to get them out and cast them beca they r of type Any and if its not able to do so empty string
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageURL = dictionary["profileImageURL"] as? String ?? ""
    }
}
