//
//  ServicesDetailHeader.swift
//  CaffeNapoli
//
//  Created by KEEVIN MITCHELL on 11/15/18.
//  Copyright © 2018 Kev1. All rights reserved.
//

import UIKit

class ServicesDetailHeader:UICollectionViewCell {
    
    var service: Service? {
        didSet {
            serviceTitleHeaderLabel.text = service?.name
        }
        
    }
    
    static let headerFontName = "Gilroy-ExtraBold"
    
    let topLineView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        //        view.backgroundColor = UIColor.darkText
        view.backgroundColor = UIColor.tableViewBackgroundColor
        return view
    }()
    
    let serviceTitleHeaderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: headerFontName, size: 25)
        
        label.numberOfLines = 0
//        label.backgroundColor = .blue
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Structured Voice & Data Network Cabling. Tri-State Coverage. 24 Hour Service. Free Estimates. Data, Wifi Installer. Competitive Rates. Services: Data Cabling, Structured Cabling, Fiber Optic Cable Install."
        
        return label
    }()
    
    let headerImageView : UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "AdobeStock_103075892"))
        iv.translatesAutoresizingMaskIntoConstraints = false
//        iv.backgroundColor = .green
        
        
        iv.contentMode = .scaleAspectFill
        return iv
    
    }()
    let labelContainerView:UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
       backgroundColor = .white
         addSubview(serviceTitleHeaderLabel)
        serviceTitleHeaderLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        serviceTitleHeaderLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        serviceTitleHeaderLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        serviceTitleHeaderLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        serviceTitleHeaderLabel.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: NSLayoutConstraint.Axis.vertical)
//        addSubview(labelContainerView)
//        labelContainerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
//        labelContainerView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
//        labelContainerView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
//        labelContainerView.heightAnchor.constraint(equalToConstant: 40).isActive = true
//        labelContainerView.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: NSLayoutConstraint.Axis.vertical)
//
        addSubview(headerImageView)
        headerImageView.topAnchor.constraint(equalTo: serviceTitleHeaderLabel.bottomAnchor, constant: 0).isActive = true
        headerImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant:20).isActive = true
        headerImageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant:-20).isActive = true
        headerImageView.heightAnchor.constraint(equalToConstant: self.frame.width - 80).isActive = true
        addSubview(topLineView)
        topLineView.topAnchor.constraint(equalTo: self.headerImageView.bottomAnchor, constant: 20).isActive = true
        topLineView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        topLineView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        topLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
