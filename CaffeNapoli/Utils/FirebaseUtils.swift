//
//  FirebaseUtils.swift
//  CaffeNapoli
//
//  Created by Kev1 on 11/9/17.
//  Copyright © 2017 Kev1. All rights reserved.
//

import Firebase
extension Database {
    // My common method to fetch user data from firebase
    // completion: @escaping () -> () first one parameter it takes second what it spits out
    static func fetchUserWithUIUD(uid: String, completion: @escaping  (User) -> ()) {
        //test
        print("Fetching user with uid:", uid)
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let userDictionary = snapshot.value as? [String:Any] else { return }
            //            let user = User(dictionary: userDictionary)
            let user = User(uid: uid, dictionary: userDictionary)
            //            print(snapshot.value ?? [])
            //FETCH POST FOR USER            //
            //            self.fetchPostsWithUser(user: user)
            //            print(user.username)
            
            //Completion()
            completion(user)
            
        }) { (error) in
            //
            print("Failed to fetch user for posts", error)
        }
        
        
        
    }
    
}
