//
//  ServiceDetailFooter.swift
//  CaffeNapoli
//
//  Created by KEEVIN MITCHELL on 11/16/18.
//  Copyright © 2018 Kev1. All rights reserved.
//

import UIKit
import TransitionButton
class ServiceDetailFooter: UICollectionViewCell {
    
    let topLineView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = UIColor.darkText
        view.backgroundColor = UIColor.tableViewBackgroundColor
        return view
    }()
    let separatorView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        //        view.backgroundColor = UIColor.darkText
        view.backgroundColor = UIColor.tableViewBackgroundColor
        return view
        
    }()
    
    let contactButton : TransitionButton = {
        let button = TransitionButton(type: UIButton.ButtonType.system)
        button.setTitle("Contact Us", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = UIColor.tableViewBackgroundColor
        
        button.titleLabel?.textColor =  UIColor.tableViewBackgroundColor
        
        button.backgroundColor = UIColor.white
        
        button.layer.shadowPath = UIBezierPath(rect: button.layer.bounds).cgPath
        button.layer.shadowColor = UIColor.darkGray.cgColor
        button.layer.shadowRadius = 3
        button.layer.borderColor =  UIColor.tableViewBackgroundColor.cgColor
        button.layer.borderWidth = 1
        return button
    }()
    
    let techCareButton : TransitionButton = {
        let button = TransitionButton(type: UIButton.ButtonType.system)
        button.setTitle("Tech Care", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = UIColor.tableViewBackgroundColor
         button.titleLabel?.textColor =  UIColor.tableViewBackgroundColor
        button.backgroundColor = UIColor.white
        button.layer.borderColor =  UIColor.tableViewBackgroundColor.cgColor
        button.layer.borderWidth = 1
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(topLineView)
        topLineView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        topLineView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        topLineView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        topLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        addSubview(separatorView)
        separatorView.topAnchor.constraint(equalTo: topLineView.topAnchor).isActive = true
        separatorView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        separatorView.widthAnchor.constraint(equalToConstant: 1).isActive = true
        separatorView.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -20).isActive = true
        addSubview(contactButton)
        contactButton.topAnchor.constraint(equalTo: topLineView.bottomAnchor, constant: 10).isActive = true
        contactButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        contactButton.rightAnchor.constraint(equalTo: separatorView.leftAnchor, constant: -10).isActive = true
        contactButton.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -50).isActive = true
        addSubview(techCareButton)
        techCareButton.topAnchor.constraint(equalTo: topLineView.bottomAnchor, constant: 10).isActive = true
        techCareButton.leftAnchor.constraint(equalTo: separatorView.rightAnchor, constant: 10).isActive = true
        techCareButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        contactButton.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -50).isActive = true
        
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
       
    }
}
