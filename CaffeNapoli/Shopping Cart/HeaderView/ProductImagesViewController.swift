//
//  ProductImagesViewController.swift
//  CaffeNapoli
//
//  Created by Kev1 on 12/27/17.
//  Copyright © 2017 Kev1. All rights reserved.
//

import UIKit

class ProductImagesViewController: UIViewController {
    
    let imageView : UIImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        return iv
    }()
    
    var image: UIImage? {
        didSet {
            self.imageView.image = image
        }
    }
    
    
    override func viewDidLoad() {
       super.viewDidLoad()
       view.addSubview(imageView)
        imageView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
         self.imageView.image = image
    }
}
