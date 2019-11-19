//
//  Posts.swift
//  CaffeNapoli
//
//  Created by Kev1 on 10/30/17.
//  Copyright © 2017 Kev1. All rights reserved.
// WE WILL CXAPTURE ALL THE DOWNLOADED DATA IN THIS POSTS FILE

import Foundation
struct Post {
    //
    var id: String?
    let user : User
    let imageUrl : String
    let caption : String
    let creationDate: Date
    var likesCount: NSNumber?
    var hasLiked: Bool
    
   
//    let comment : Comment?
//    let like : Like?
//    let share: Share?
    
    //
//    var hasLiked  = false
    
    //initializer takes in a dictionary of snapshot type [String : Any]
    //  this is the initial setup when a Post is built
    init(user: User, dictionary : [String : Any]) {
        self.imageUrl = dictionary["imageUrl"] as? String ?? "" //empty string if u cant get one
        self.user = user
        self.caption = dictionary["caption"] as? String ?? ""
        self.likesCount = dictionary["likesCount"] as? NSNumber ?? 0
        self.hasLiked = (dictionary["hasLiked"] != nil)
        // date conversion /
        let secondsFrom1970 = dictionary["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
        
    }
}


    

