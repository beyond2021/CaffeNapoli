//
//  ServiceCell.swift
//  CaffeNapoli
//
//  Created by KEEVIN MITCHELL on 11/6/18.
//  Copyright © 2018 Kev1. All rights reserved.
//

import UIKit

class ServiceCell:UICollectionViewCell{
    var service: Service?{
        didSet {
            guard let serviceImageURL = service?.imageURL else { return }
            serviceImageView.loadImage(urlString: serviceImageURL)
           
            serviceNameLabel.text = service?.name
            
        }
    } //needs to be nil in the beginning
    
    let serviceImageView : CustomImageView = {
        let iv = CustomImageView(image: #imageLiteral(resourceName: "icons8-technology-lifestyle-80"))
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 40 / 2
        iv.layer.borderColor = UIColor.tableViewBackgroundColor.cgColor
        iv.layer.borderWidth = 1
        return iv
    }()
    
    let serviceNameLabel : UILabel = {
        let label = UILabel()
        label.text = "Service Name"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
        
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(serviceImageView)
        serviceImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        serviceImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        serviceImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        serviceImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        addSubview(serviceNameLabel)
        
        serviceNameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        serviceNameLabel.leftAnchor.constraint(equalTo: serviceImageView.rightAnchor, constant:8).isActive = true
        serviceNameLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant:8).isActive = true
        serviceNameLabel.heightAnchor.constraint(equalToConstant: 40)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
