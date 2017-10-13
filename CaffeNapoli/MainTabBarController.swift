//
//  MainTabBarController.swift
//  CaffeNapoli
//
//  Created by Kev1 on 10/10/17.
//  Copyright © 2017 Kev1. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        //set bgcolor
        view.backgroundColor = .blue
        // UITabarcontrooler has a property called viewControllers
//        let redVC = UIViewController()
//        redVC.view.backgroundColor = .red
        
        let layout = UICollectionViewFlowLayout()
        
        let userProfileController = UserProfileController(collectionViewLayout: layout)
        
        //Add a navigationbar on the top
        let navController = UINavigationController(rootViewController: userProfileController)
        // items in the tabs
        navController.tabBarItem.image = #imageLiteral(resourceName: "profile_unselected")
        navController.tabBarItem.selectedImage = #imageLiteral(resourceName: "profile_selected")
        
        // Color the tabBar
        tabBar.tintColor = .black
        viewControllers = [navController, UIViewController()]
        
    }
    
}
