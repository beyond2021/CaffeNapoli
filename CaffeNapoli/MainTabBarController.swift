//
//  MainTabBarController.swift
//  CaffeNapoli
//
//  Created by Kev1 on 10/10/17.
//  Copyright © 2017 Kev1. All rights reserved.
//

import UIKit
import Firebase

class MainTabBarController: UITabBarController {
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        //HERE WE WILL CHECK IF THE USER IS LOGGED IN
        
        //PUT THE VIEW IN THE HIEARCHY
        DispatchQueue.main.async {
            //
            // THE USER IS NOT LOGGED IN, PRESENT LOGIN
            let loginController = LoginController()
            let navigationController = UINavigationController(rootViewController: loginController)
            self.present(navigationController, animated: true, completion: nil)
            
        }
        
        if Auth.auth().currentUser == nil {
        
            return // Stop here and get out
        }
        
        
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
