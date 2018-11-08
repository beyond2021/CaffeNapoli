//
//  Service.swift
//  CaffeNapoli
//
//  Created by KEEVIN MITCHELL on 11/2/18.
//  Copyright © 2018 Kev1. All rights reserved.
//

import UIKit


struct Service {
    let name: String
    let description : String
    let imageURL : String
    init( dictionary : [String : Any]) {
        self.name = dictionary["name"] as! String
        self.description = dictionary["description"] as! String
        self.imageURL = dictionary["imageURL"] as! String
       
    }
}

