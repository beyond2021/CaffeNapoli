//
//  CustomTabBarController.swift
//  CaffeNapoli
//
//  Created by KEEVIN MITCHELL on 11/10/18.
//  Copyright © 2018 Kev1. All rights reserved.
//

import UIKit
import ESTabBarController_swift
import  Firebase

class CustomTabBarController: ESTabBarController, UITabBarControllerDelegate {
    
    static let homeTitle = "Home"
    static let serviceTitle = "service"
    static let shareTitle = "Share"
    static let friendsTitle = "Friends"
    static let meTitle = "Me"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.barTintColor = .white
       
        
//        self.tabBar.tintColor = .white
        
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
            return // Stop here and get out
        }
        
            self.shouldHijackHandler = {
                tabbarController, viewController, index in
                if index == 2 {
                    return true
                }
                return false
        }
        setupViewControllers()
    }
    private func setupViewControllers() {
        let cellLayout = UICollectionViewFlowLayout()
        cellLayout.minimumInteritemSpacing = 20
        cellLayout.minimumLineSpacing = 20
        cellLayout.sectionInset = UIEdgeInsets.init(top: 20,left: 0,bottom: 0,right: 0)
        let homeNavController = templateNavController(title: MainTabBarController.homeTitle, unselectedImage: #imageLiteral(resourceName: "homeFeedBE"), selectedImage: #imageLiteral(resourceName: "homeFeedBS"), rootViewController: HomeController(collectionViewLayout: cellLayout), tag: 0)
        let searchNavController = templateNavController(title: MainTabBarController.friendsTitle, unselectedImage: #imageLiteral(resourceName: "friendsBE"), selectedImage: #imageLiteral(resourceName: "friendsBS"), rootViewController: UserSearchController(collectionViewLayout: UICollectionViewFlowLayout()), tag: 1)
        let plusNavController = templateNavController(title: MainTabBarController.shareTitle, unselectedImage: #imageLiteral(resourceName: "uploadBE"), selectedImage: #imageLiteral(resourceName: "uploadBS"), tag: 2)
        let addReservationController = templateNavController(title: MainTabBarController.serviceTitle, unselectedImage: #imageLiteral(resourceName: "serviceBE"), selectedImage: #imageLiteral(resourceName: "serviceBS"), rootViewController: ServicesController(collectionViewLayout: HeaderStrechyLayout()), tag: 3)
        let userProfileNavController = templateNavController(title: MainTabBarController.meTitle, unselectedImage:  #imageLiteral(resourceName: "avatarBE"), selectedImage: #imageLiteral(resourceName: "avatarBS"), rootViewController:UserProfileController(collectionViewLayout: UICollectionViewFlowLayout()), tag: 4)
        viewControllers = [homeNavController,addReservationController,plusNavController,searchNavController,  userProfileNavController]
        // Tomove the images to center of tabbar - insets here - Modify tabbar insets
        guard let items = tabBar.items else { return }
        for  item in items {
            
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        }
        
    }
    
    fileprivate func templateNavController(title : String, unselectedImage : UIImage, selectedImage : UIImage, rootViewController : UIViewController = UIViewController(), tag : Int) -> UINavigationController {
        // Home icon
        let viewController = rootViewController
        let navController = CustomNavigationController(rootViewController: viewController)
        //To add the icons
        let contentView = ESTabBarItemContentView()
        contentView.highlightTextColor = UIColor.tableViewBackgroundColor
        
        contentView.tintColor = UIColor.tableViewBackgroundColor
        contentView.highlightIconColor = UIColor.tableViewBackgroundColor
        contentView.iconColor = UIColor.tableViewBackgroundColor
        contentView.titleLabel.textColor = UIColor.tableViewBackgroundColor
        viewController.tabBarItem = ESTabBarItem(ExampleBouncesContentView(), title: title, image: unselectedImage, selectedImage: selectedImage, tag: tag)
        
//        viewController.tabBarItem = ESTabBarItem.init(content: ExampleImpliesTabBarItemContent.init(animator: ExampleBackgroundAnimator.init(special: true)))

        return navController
    }
    
    
    
}
extension CustomTabBarController {
    public func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        // Figure which index you are selecting
        let index = viewControllers?.index(of: viewController) // viewController - selected one
        print(index ?? 0)
        // will perform custom logic at index 2
        if index == 2 {
            let layout = UICollectionViewFlowLayout()
            let photoSelectorController = PhotoSelectorController(collectionViewLayout: layout)
            let navController = CustomNavigationController(rootViewController: photoSelectorController)
            present(navController, animated: true, completion: nil)
            return false
        }
        
        //
        return true // stops u from selecting all the tabbar items but must set the delegate in viewDidLoad
    }
}


