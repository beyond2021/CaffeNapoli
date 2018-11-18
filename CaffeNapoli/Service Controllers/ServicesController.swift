//
//  ServicesController.swift
//  CaffeNapoli
//
//  Created by KEEVIN MITCHELL on 11/3/18.
//  Copyright © 2018 Kev1. All rights reserved.
//

import UIKit
import Firebase
import CCZoomTransition



class ServicesController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let serviceCellID = "ServiceCell"
    let headerID = "headerID"
    var header : PhotoSelectorHeader?
    var services = [Service]()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "SERVICES"
        setupNavigationStyle()
        let width = collectionView.frame.width
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.headerReferenceSize = CGSize(width: width, height: width)
        collectionView.backgroundColor = .white
        collectionView.register(ServiceCell.self, forCellWithReuseIdentifier: serviceCellID)
        collectionView?.register(PhotoSelectorHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerID)
        
        getAllServices()
    }
    func setupNavigationStyle(){
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font:UIFont(name:HomeController.navFontName, size: HomeController.navFontSizeLarge) ?? ""]
        } else {
            // Fallback on earlier versions
        }
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font:UIFont(name:HomeController.navFontName, size: HomeController.navFontSizeSmall) ?? ""]
//        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
    }
    private func getAllServices() {
        let postReference = Database.database().reference().child("services")
        postReference.observeSingleEvent(of: .value, with: { (serviceSnapshot) in
//            print(serviceSnapshot)
            self.collectionView?.refreshControl?.endRefreshing()
            guard let dictionaries =  serviceSnapshot.value as? [String: Any] else { return }
            dictionaries.forEach({ (key, value) in
                guard let dictionary = value as? [String: Any] else { return }
                let service = Service(dictionary: dictionary)
                self.services.append(service)
                self.collectionView.reloadData()
                
            })
            
            
        }) { (error) in
            //            get the error from the cancel block if there is any
            print("Failed to fetch posts", error)
        }
        
        
    }
    
}

extension ServicesController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return services.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: serviceCellID, for: indexPath) as! ServiceCell
        let service = services[indexPath.row]
        cell.service = service
        
        
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //How tall the cell is
        let height: CGFloat = 40 + 8 + 8 // Username UserProfile
//        height += view.frame.width
//        //
//        height += 50// for bottom buttons
//        // Caption label
//        height += 60
        return CGSize(width: view.frame.width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = view.frame.width
        return CGSize(width: width, height: width)
    }
    // Grad the header for the next view controller
    
    // This method reders out the header for us
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerID, for: indexPath) as! PhotoSelectorHeader
     
        self.header = header
       
        header.photoImageView.image = #imageLiteral(resourceName: "AdobeStock_3716439")
       
        
        return header
    }
//    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let viewController = WifiController()
//
//        let targetView = collectionView.cellForItem(at: indexPath)
//        viewController.cc_setZoomTransition(originalView: targetView)
//        self.present(viewController, animated: true, completion: nil)
//    }
    
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let layout = UICollectionViewFlowLayout()
        let vc = ServicesDetailController(collectionViewLayout: layout)

        if let imageCell = collectionView.cellForItem(at: indexPath) as? ServiceCell {
            vc.cc_setZoomTransition(originalView: imageCell.serviceImageView)
//                        vc.cc_swipeBackDisabled = true
        }

        self.present(vc, animated: true, completion: nil)

        return false
    }
    
    
}
