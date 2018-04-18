//
//  Followers.swift
//  CaffeNapoli
//
//  Created by Kev1 on 4/4/18.
//  Copyright © 2018 Kev1. All rights reserved.
//

import Foundation

struct Following {
    var followingID : String
    let user : User
    init(user: User, dictionary : [String : Any]) {
        self.followingID = dictionary["followwing"] as? String ?? "" //empty string if u cant get one
        self.user = user
    }
}
