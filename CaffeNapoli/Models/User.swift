//
//  User.swift
//  CaffeNapoli
//
//  Created by Kev1 on 11/9/17.
//  Copyright © 2017 Kev1. All rights reserved.
//

import Foundation
// TO STOP FECTHING DICTIONARY TWICE

struct User {
    //
    let uid : String
    let username : String?
    let name : String?
    let profileImageURL : String
    let email : String?
   
    
    
    //Constructor to setup these properties
    init(uid: String, dictionary: [String:Any]) {
        self.uid = uid
        // to get them out and cast them beca they r of type Any and if its not able to do so empty string
        self.username = dictionary["username"] as? String ?? ""
        self.name = dictionary["name"] as? String ?? ""
        self.profileImageURL = dictionary["profileImageURL"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
    }
}

