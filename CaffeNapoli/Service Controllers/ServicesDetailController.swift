//
//  WifiController.swift
//  CaffeNapoli
//
//  Created by KEEVIN MITCHELL on 11/11/18.
//  Copyright © 2018 Kev1. All rights reserved.
//

import UIKit
import CCZoomTransition

class ServicesDetailController : UICollectionViewController, UICollectionViewDelegateFlowLayout {
    static let headerCell = "headerCell"
    static let serviceTopicCell = "serviceTopicCell"
    static let footerCell = "footerCell"
    var header : ServicesDetailHeader?
    var footer : ServiceDetailFooter?
    
    var service :Service? {
        didSet {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let width = collectionView.frame.width
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.headerReferenceSize = CGSize(width: width, height: width)
        layout.footerReferenceSize = CGSize(width: width, height: 40)
        collectionView?.backgroundColor = .white
        collectionView.register(ServiceTopicCell.self, forCellWithReuseIdentifier: ServicesDetailController.serviceTopicCell)
        collectionView?.register(ServicesDetailHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ServicesDetailController.headerCell)
        collectionView?.register(ServiceDetailFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: ServicesDetailController.footerCell)
        
    }
}
extension ServicesDetailController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ServicesDetailController.serviceTopicCell, for: indexPath) as! ServiceTopicCell
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //How tall the cell is
        
        let height: CGFloat = 300
//        let height: CGFloat = 40// Username UserProfile
        //        height += view.frame.width
        //        //
        //        height += 50// for bottom buttons
        //        // Caption label
        //        height += 60
        return CGSize(width: view.frame.width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = view.frame.width
        return CGSize(width: width, height: width + 40 + 20)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let width = view.frame.width
        let height: CGFloat = 80
         return CGSize(width: width, height: height)
        
    }
//    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        <#code#>
//    }
    
    // This method reders out the header for us
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ServicesDetailController.headerCell, for: indexPath) as! ServicesDetailHeader
//
//        self.header = header
//
//     header.headerImageView.image = #imageLiteral(resourceName: "AdobeStock_132678227")
//
//
//        return header
        switch kind {
            
        case UICollectionView.elementKindSectionHeader:
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ServicesDetailController.headerCell, for: indexPath)as! ServicesDetailHeader
            
            self.header = headerView
            headerView.headerImageView.image = #imageLiteral(resourceName: "AdobeStock_132678227")
            return headerView
            
        case UICollectionView.elementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier:  ServicesDetailController.footerCell, for: indexPath) as! ServiceDetailFooter
            self.footer = footerView
            
            footerView.backgroundColor = UIColor.tableViewBackgroundColor
            return footerView
            
        default:
            
            assert(false, "Unexpected element kind")
        }
        
        
        
        
    }
    
   
    
}
