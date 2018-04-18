//
//  Following.swift
//  
//
//  Created by Kev1 on 4/4/18.
//

import Foundation
struct Following {
    //
    var id: String?
    let user : User
    let imageUrl : String
    let caption : String
    let creationDate: Date
    //
    var hasLiked  = false
    
    //initializer takes in a dictionary of snapshot type [String : Any]
    //  this is the initial setup when a Post is built
    init(user: User, dictionary : [String : Any]) {
        self.imageUrl = dictionary["imageUrl"] as? String ?? "" //empty string if u cant get one
        self.user = user
        self.caption = dictionary["caption"] as? String ?? ""
        // date conversion /
        let secondsFrom1970 = dictionary["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
        
    }
    
}
