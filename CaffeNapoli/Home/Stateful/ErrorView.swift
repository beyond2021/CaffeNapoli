//
//  ErrorView.swift
//  CaffeNapoli
//
//  Created by KEEVIN MITCHELL on 11/13/18.
//  Copyright © 2018 Kev1. All rights reserved.
//

import UIKit
class ErrorView: BasicPlaceholderView {
    
    let textLabel = UILabel()
    let detailTextLabel = UILabel()
    let tapGestureRecognizer = UITapGestureRecognizer()
    
    override func setupView() {
        super.setupView()
        
        backgroundColor = UIColor.white
        
        self.addGestureRecognizer(tapGestureRecognizer)
        
        textLabel.text = "Something went wrong."
        textLabel.numberOfLines = 0
        textLabel.textAlignment = .center
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        centerView.addSubview(textLabel)
        
        detailTextLabel.text = "Tap to reload"
        detailTextLabel.numberOfLines = 0
        detailTextLabel.textAlignment = .center
        let fontDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: UIFont.TextStyle.footnote)
        detailTextLabel.font = UIFont(descriptor: fontDescriptor, size: 0)
        detailTextLabel.textAlignment = .center
        detailTextLabel.textColor = UIColor.gray
        detailTextLabel.translatesAutoresizingMaskIntoConstraints = false
        centerView.addSubview(detailTextLabel)
        
        let views = ["label": textLabel, "detailLabel": detailTextLabel]
        let hConstraints = NSLayoutConstraint.constraints(withVisualFormat: "|-[label]-|", options: .alignAllCenterY, metrics: nil, views: views)
        let hConstraintsDetail = NSLayoutConstraint.constraints(withVisualFormat: "|-[detailLabel]-|", options: .alignAllCenterY, metrics: nil, views: views)
        let vConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-[label]-[detailLabel]-|", options: .alignAllCenterX, metrics: nil, views: views)
        
        centerView.addConstraints(hConstraints)
        centerView.addConstraints(hConstraintsDetail)
        centerView.addConstraints(vConstraints)
    }
    
}
