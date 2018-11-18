//
//  ServicesDetailHeader.swift
//  CaffeNapoli
//
//  Created by KEEVIN MITCHELL on 11/15/18.
//  Copyright © 2018 Kev1. All rights reserved.
//

import UIKit

class ServicesDetailHeader:UICollectionViewCell {
    static let headerFontName = "CloisterBlack-Light"
    
    let serviceTitleHeaderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: headerFontName, size: 25)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Structured Voice & Data Network Cabling. Tri-State Coverage. 24 Hour Service. Free Estimates. Data, Wifi Installer. Competitive Rates. Services: Data Cabling, Structured Cabling, Fiber Optic Cable Install."
        
        return label
    }()
    
    let headerImageView : UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "AdobeStock_103075892"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleToFill
        return iv
    
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        backgroundColor = .yellow
        addSubview(serviceTitleHeaderLabel)
        serviceTitleHeaderLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        serviceTitleHeaderLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        serviceTitleHeaderLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        serviceTitleHeaderLabel.heightAnchor.constraint(equalToConstant: self.frame.width + 40)
        addSubview(headerImageView)
        headerImageView.topAnchor.constraint(equalTo: serviceTitleHeaderLabel.bottomAnchor, constant: 20).isActive = true
        headerImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        headerImageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        headerImageView.heightAnchor.constraint(equalToConstant: self.frame.width - 40).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
