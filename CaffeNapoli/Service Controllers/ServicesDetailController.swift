//
//  WifiController.swift
//  CaffeNapoli
//
//  Created by KEEVIN MITCHELL on 11/11/18.
//  Copyright © 2018 Kev1. All rights reserved.
//

import UIKit
import CCZoomTransition
import EasyAnimation

class ServicesDetailController : UICollectionViewController, UICollectionViewDelegateFlowLayout {
    static let headerCell = "headerCell"
    static let serviceTopicCell = "serviceTopicCell"
    static let footerCell = "footerCell"
    var moveLeftAnchor: NSLayoutConstraint?
    var chain: EAAnimationFuture?
    
    var header : ServicesDetailHeader?
    var footer : ServiceDetailFooter?
    
    var service :Service? {
        didSet {
            
        }
    }
    let moveRightView: UIImageView  = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "WhitRingArrow"))
        iv.backgroundColor = UIColor.tableViewBackgroundColor
        iv.layer.borderColor = UIColor.white.cgColor
        iv.layer.borderWidth = 1
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    let swipeRightLabel: UILabel  = {
        let label = UILabel()
        label.text = "Swipe Right ->"
//        label.backgroundColor = UIColor.tableViewBackgroundColor
//        label.layer.borderColor = UIColor.white.cgColor
//        label.layer.borderWidth = 1
        label.font = UIFont.systemFont(ofSize: 10)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
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
       
         view.insertSubview(moveRightView, aboveSubview: collectionView)
        view.insertSubview(swipeRightLabel, aboveSubview: collectionView)
        moveRightView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        moveRightView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        moveRightView.topAnchor.constraint(equalTo: collectionView.topAnchor, constant:40).isActive = true
        moveLeftAnchor = moveRightView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10)
        moveLeftAnchor?.isActive = true
        
        swipeRightLabel.alpha = 0
        swipeRightLabel.widthAnchor.constraint(equalToConstant: 20 + 20 + 48).isActive = true
        swipeRightLabel.centerYAnchor.constraint(equalTo: moveRightView.centerYAnchor).isActive = true
        swipeRightLabel.leftAnchor.constraint(equalTo: collectionView.leftAnchor, constant: 68).isActive = true
        swipeRightLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
      
    }
    
    
    func resetMoveRightLabel(){
       
        moveRightView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        moveRightView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        moveRightView.topAnchor.constraint(equalTo: collectionView.topAnchor, constant:40).isActive = true
        moveLeftAnchor = moveRightView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10)
        moveLeftAnchor?.isActive = true
        
        swipeRightLabel.alpha = 0
        swipeRightLabel.widthAnchor.constraint(equalToConstant: 20 + 20 + 48).isActive = true
        swipeRightLabel.centerYAnchor.constraint(equalTo: moveRightView.centerYAnchor).isActive = true
        swipeRightLabel.leftAnchor.constraint(equalTo: collectionView.leftAnchor, constant: 68).isActive = true
        swipeRightLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("View will appeared called")
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
         self.moveLeftAnchor!.constant  = 10
       
        UIView.animate(withDuration: 2.0, delay: 2.0, options: [.repeat, .autoreverse, .curveEaseOut], animations: {
            self.moveLeftAnchor!.constant  += 40
            self.moveRightView.layer.cornerRadius = 10.0
            self.view.layer.borderWidth = 5.0
            self.swipeRightLabel.alpha = 1
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        UIView.animate(withDuration: 2.0, delay: 2.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.0, options: [.repeat, .autoreverse, .curveEaseOut], animations: {
//         self.moveLeftAnchor!.constant  += 20
//        self.moveRightView.layer.cornerRadius = 5.0
//        self.view.layer.borderWidth = 5.0
//
//         self.view.layoutIfNeeded()
//
//       }, completion : nil)
//
    })
    
    
    }
    
}

extension ServicesDetailController {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ServicesDetailController.serviceTopicCell, for: indexPath) as! ServiceTopicCell
        cell.service = service
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //How tall the cell is
        /*
        let height: CGFloat = 300
//        let height: CGFloat = 40// Username UserProfile
        //        height += view.frame.width
        //        //
        //        height += 50// for bottom buttons
        //        // Caption label
        //        height += 60
        return CGSize(width: view.frame.width, height: height)
         
 */
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)]
        let appoximatedWidthOftextView = view.frame.width - 20 - 20
        let size = CGSize(width:appoximatedWidthOftextView, height: 1000)
        let str = NSString(string: (service?.description)!)
        let estimatedFrame = NSString(string: str).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        return CGSize(width: view.frame.width, height: estimatedFrame.height + 20 + 10 + 10)
        
        
        
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = view.frame.width
        return CGSize(width: width, height: width )
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
            headerView.service = service
            return headerView
            
        case UICollectionView.elementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier:  ServicesDetailController.footerCell, for: indexPath) as! ServiceDetailFooter
            self.footer = footerView
            
            footerView.backgroundColor = UIColor.white
            return footerView
            
        default:
            
            assert(false, "Unexpected element kind")
        }
        
        
        
        
    }
    
   
    
}
