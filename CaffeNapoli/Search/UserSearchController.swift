//
//  UserSearchController.swift
//  CaffeNapoli
//
//  Created by Kev1 on 11/9/17.
//  Copyright © 2017 Kev1. All rights reserved.
//

import Foundation
import Firebase

class UserSearchController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    //Constants
    let cellID = "cellID"
    // Search Bar
    lazy var searchBar : UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Enter username"
        sb.barTintColor = .gray
//        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.rgb(displayP3Red: 230, green: 230, blue: 230)
         UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.cellBGColor()
        
        //to find whats being typed in the search bar
        sb.delegate = self // lazy var u have SELF, let u dont
        return sb
    }()
    // Searchbar delegate methods
    //to find whats being typed in the search bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)// text being printed in the searchbar realtime
        //logic
        //empty string case
        if searchText.isEmpty {
            filteredUsers = users
        
        } else {
            //regular case
            print(self.filteredUsers.count)
            //time to filter out the unwanted users
            self.filteredUsers = self.users.filter { (user) -> Bool in
                // give u any array back
                //lowercase makes it case insensitive
                let username = user.username ?? user.name

//                return user.username.lowercased().contains(searchText.lowercased())
                return username!.lowercased().contains(searchText.lowercased())
            }
            
            
        }
        
        // reset ui
        self.collectionView?.reloadData()
        
    }
    
    
    
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = UIColor.cellBGColor()
        // put the search bar in the nav bar
        navigationController?.navigationBar.addSubview(searchBar)
        let navBar = navigationController?.navigationBar
        searchBar.anchor(top: navBar?.topAnchor, left: navBar?.leftAnchor, bottom: navBar?.bottomAnchor, right: navBar?.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
        //Register Cell
        collectionView?.register(UserSearchCell.self, forCellWithReuseIdentifier: cellID)
        //Mkae it scroll when there isnt enough cells
        collectionView?.alwaysBounceVertical = true
        //get the users to filter for search
        //Dismiss the keyboard on drag
        collectionView?.keyboardDismissMode = .onDrag
        fetchUsers()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.isHidden = false // searchBar logic dance
        
    }
    
    //NAVIGATION
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //0: hide the search bar
        searchBar.isHidden = true // searchBar logic dance
        //0.5 remove searchbar
        searchBar.resignFirstResponder()
        //1 : Get the item
        let user = filteredUsers[indexPath.item]
        print(user.username)
        //2: b ring in the user profile page
        let userProfileController = UserProfileController(collectionViewLayout : UICollectionViewFlowLayout())
        //set the correct user in UserProfileController
        userProfileController.userID = user.uid
        // push userProfile
        navigationController?.pushViewController(userProfileController, animated: true)
        
    }
    //
    var filteredUsers = [User]()
    var users = [User]()
    
    
    //MARK:- GET ALL USERS
    fileprivate func fetchUsers(){
        print("Fetching users...")
        //fetching all users from the users node
        let ref = Database.database().reference().child("users")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
//            //
//            print(snapshot.value)// prints all users dictionaries
            //Make a list of users from these values. one value is a dictionary itself
            guard let dictionaries = snapshot.value as? [String : Any] else { return }
            //go true each dictionary
            dictionaries.forEach({ (key, value) in
                //
                //logic check to remove self from search
                if key == Auth.auth().currentUser?.uid {
                    print("Found myself omit from list")
                    return
                    
                }
//                print(key, value)
                // cast the value into our user dictionary. value here is of typy any
                guard let userDictionary = value as? [String:Any] else { return }
                //Construct one of our dictionary
                let user = User(uid: key, dictionary: userDictionary)
    
//                print(user.uid, user.username)
                self.users.append(user)
                
            })
            //Sort the user here not sorted! which returns an array
            self.users.sort(by: { (user1, user2) -> Bool in
                if user1.username == "" || user2.username == "" {
                    return user1.name!.compare(user2.name!) == .orderedAscending
                } else if user1.username == "" {
                    return user1.name!.compare(user2.username!) == .orderedAscending
                } else if user2.username == "" {
                    return user1.username!.compare(user2.name!) == .orderedAscending
                    
                } else {
                    return user1.username!.compare(user2.username!) == .orderedAscending                }
                //                return user1.username.compare(user2.username) == .orderedAscending
                
            })
            
            self.filteredUsers = self.users // when we get all users will fill up filtered users here
            self.collectionView?.reloadData()
            
            
        }) { (error) in
            //
            print("Failed to fetch users for search:", error)
        }
        
    }
    
    
    //DataScource Methods
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 7
//        return users.count
        return filteredUsers.count // after filtering
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! UserSearchCell
        //cell.backgroundColor = .green
//        cell.user = users[indexPath.item] // fill user in cell here
        cell.user = filteredUsers[indexPath.item] // after filtering
        return cell
    }
    // UICollectionViewDelegateFlowLayout Methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        return CGSize(width: width, height: 66)
    }
    
}
