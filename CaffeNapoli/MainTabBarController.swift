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
            // THE USER IS NOT LOGGED IN, PRESENT LOGIN //FUIAuthViewController
//            let loginController = LoginController()
            let loginController = LoginAuthController()
            let navigationController = CustomNavigationController(rootViewController: loginController)
            self.present(navigationController, animated: true, completion: nil)
            
        }
        
//        if Auth.auth().currentUser == nil {
        
            return // Stop here and get out
       }
        setupViewControllers()

       
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
     func setupViewControllers(){
        //Home
        let cellLayout = UICollectionViewFlowLayout()
        cellLayout.minimumInteritemSpacing = 20
        cellLayout.minimumLineSpacing = 20
        cellLayout.sectionInset = UIEdgeInsets.init(top: 20,left: 0,bottom: 0,right: 0)
      
//        let homeNavController = templateNavController(unselectedImage:#imageLiteral(resourceName: "feedUnselected"), selectedImage: #imageLiteral(resourceName: "feedSelected"), rootViewController: HomeController(collectionViewLayout: cellLayout))
        let homeNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "homeFeedBE"), selectedImage: #imageLiteral(resourceName: "homeFeedBS"), rootViewController: HomeController(collectionViewLayout: cellLayout))
        
        // Search

        let searchNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "friendsBE"), selectedImage: #imageLiteral(resourceName: "friendsBS"), rootViewController: UserSearchController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        let plusNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "uploadBE"), selectedImage: #imageLiteral(resourceName: "uploadBS"))


        
        let addReservationController = templateNavController(unselectedImage: #imageLiteral(resourceName: "serviceBE"), selectedImage: #imageLiteral(resourceName: "serviceBS"), rootViewController: ShoppingCartController(collectionViewLayout: UICollectionViewFlowLayout()))
        let layout = UICollectionViewFlowLayout()
        
        let userProfileController = UserProfileController(collectionViewLayout: layout)
        
        
        //Add a navigationbar on the top
        let userProfileNavController = UINavigationController(rootViewController: userProfileController)
        // items in the tabs
        userProfileNavController.tabBarItem.image = #imageLiteral(resourceName: "avatarBE")
        userProfileNavController.tabBarItem.selectedImage = #imageLiteral(resourceName: "avatarBS")
        
        // Color the tabBar
        tabBar.tintColor = .black
//        viewControllers = [navController, UIViewController()]
//        HomeController(collectionViewLayout: UICollectionViewFlowLayout())
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
        let navController = CustomNavigationController(rootViewController: viewController)
        //To add the icons
        viewController.tabBarItem.image = unselectedImage
        navController.tabBarItem.selectedImage = selectedImage
        return navController
    }
    
}
