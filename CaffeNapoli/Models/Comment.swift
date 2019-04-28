//
//  Comment.swift
//  CaffeNapoli
//
//  Created by Kev1 on 12/9/17.
//  Copyright © 2017 Kev1. All rights reserved.
//  this struct to hold on to the text and uid of the commemts from snapshot
//YOU CREATE THIS STRUCT MODEL FROM WHAT YOU GET BACK IN SNAPSHOT

import Foundation
struct Comment {
    let user: User //not an option
    //
    let text : String
    let uid : String
    //initializer that will take in the snapshot value
    init(user: User, dictionary : [String: Any]) {
        //
        self.user = user
        self.text = dictionary["text"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
    }
}

struct Like {
   
    let uid : String
    //initializer that will take in the snapshot value
    init(post: Post, dictionary : [String: Any]) {
        //
       
        self.uid = dictionary["likes"] as? String ?? ""
    }
}

struct Share {
    
    let uid : String
    //initializer that will take in the snapshot value
    init(post: Post, dictionary : [String: Any]) {
        //
        
        self.uid = dictionary["shares"] as? String ?? ""
    }
}
