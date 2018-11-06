//
//  Service.swift
//  CaffeNapoli
//
//  Created by KEEVIN MITCHELL on 11/2/18.
//  Copyright © 2018 Kev1. All rights reserved.
//

import UIKit


struct Service {
    let uid: String
    let name: String
    let description : String
    let image : UIImage?
    init(uid: String, name: String, description : String, image : UIImage?) {
        self.uid = uid
        self.name = name
        self.description = description
        self.image = image
    }
}

