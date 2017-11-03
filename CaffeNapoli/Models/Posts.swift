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
    let imageUrl : String
    
    //initializer takes in a dictionary of snapshot type [String : Any]
    init(dictionary : [String : Any]) {
        self.imageUrl = dictionary["imageUrl"] as? String ?? "" //empty string if u cant get one
        
    }
}
