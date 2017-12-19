//
//  MainTabBarController.swift
//  CaffeNapoli
//
//  Created by Kev1 on 10/10/17.
//  Copyright © 2017 Kev1. All rights reserved.
//

import UIKit
import Firebase

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    // This method comes from UITabBarControllerDelegate protocol
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        // Figure which index you are selecting
        let index = viewControllers?.index(of: viewController) // viewController - selected one
        print(index ?? 0)
        // will perform custom logic at index 2
        if index == 2 {
            let layout = UICollectionViewFlowLayout()
            let photoSelectorController = PhotoSelectorController(collectionViewLayout: layout)
            let navController = UINavigationController(rootViewController: photoSelectorController)
            present(navController, animated: true, completion: nil)
            return false
        }
        
        //
        return true // stops u from selecting all the tabbar items but must set the delegate in viewDidLoad
    }
    
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self //- disables tabbar selections
        
        //HERE WE WILL CHECK IF THE USER IS LOGGED IN
if Auth.auth().currentUser == nil {
        //PUT THE VIEW IN THE HIEARCHY
        DispatchQueue.main.async {
            //
            // THE USER IS NOT LOGGED IN, PRESENT LOGIN
            let loginController = LoginController()
            let navigationController = UINavigationController(rootViewController: loginController)
            self.present(navigationController, animated: true, completion: nil)
            
        }
        
//        if Auth.auth().currentUser == nil {
        
            return // Stop here and get out
       }
        setupViewControllers()

       
    }
     func setupViewControllers(){
        //Home
        let homeNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "home_unselected"), selectedImage: #imageLiteral(resourceName: "home_selected"), rootViewController: HomeController(collectionViewLayout: UICollectionViewFlowLayout()))
        // Search
//        let searchNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "search_unselected"), selectedImage: #imageLiteral(resourceName: "search_selected"))
//
        let searchNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "friendsUnsellected"), selectedImage: #imageLiteral(resourceName: "friendsSelected"), rootViewController: UserSearchController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        
        let plusNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "plus_unselected"), selectedImage: #imageLiteral(resourceName: "plus_unselected"))
//        let likeNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "like_unselected"), selectedImage: #imageLiteral(resourceName: "like_selected"))
        
//        let reservationsController = templateNavController(unselectedImage: #imageLiteral(resourceName: "reserveUnfilled"), selectedImage: #imageLiteral(resourceName: "reserveUnfilled"))
        
        let root = AddReservationViewController()
        let addReservationController = templateNavController(unselectedImage: #imageLiteral(resourceName: "reserveUnfilled"), selectedImage: #imageLiteral(resourceName: "reserveUnfilled"), rootViewController: root)
        
        let layout = UICollectionViewFlowLayout()
        
        let userProfileController = UserProfileController(collectionViewLayout: layout)
        
        
        
        //Add a navigationbar on the top
        let userProfileNavController = UINavigationController(rootViewController: userProfileController)
        // items in the tabs
        userProfileNavController.tabBarItem.image = #imageLiteral(resourceName: "profile_unselected")
        userProfileNavController.tabBarItem.selectedImage = #imageLiteral(resourceName: "profile_selected")
        
        // Color the tabBar
        tabBar.tintColor = .black
//        viewControllers = [navController, UIViewController()]
        viewControllers = [homeNavController, searchNavController,plusNavController, addReservationController, userProfileNavController]
        // Tomove the images to center of tabbar - insets here - Modify tabbar insets
        guard let items = tabBar.items else { return }
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
            
        }
        
    }
    fileprivate func templateNavController(unselectedImage : UIImage, selectedImage : UIImage, rootViewController : UIViewController = UIViewController()) -> UINavigationController {
        // Home icon
        let viewController = rootViewController
        let navController = UINavigationController(rootViewController: viewController)
        //To add the icons
        viewController.tabBarItem.image = unselectedImage
        navController.tabBarItem.selectedImage = selectedImage
        return navController
    }
    
}
