//
//  LoadingView.swift
//  CaffeNapoli
//
//  Created by KEEVIN MITCHELL on 11/13/18.
//  Copyright © 2018 Kev1. All rights reserved.
//

import UIKit
import StatefulViewController
import NVActivityIndicatorView

class LoadingView: BasicPlaceholderView, StatefulPlaceholderView {
    
    let label = UILabel()
    let activityView : NVActivityIndicatorView = {
        let actView = NVActivityIndicatorView(frame: CGRect.zero, type: .ballPulse, color: UIColor.tableViewBackgroundColor, padding: 0)
        actView.translatesAutoresizingMaskIntoConstraints = false
        return actView
        
    }()
    
    
    override func setupView() {
        super.setupView()
        
        label.text = "Loading..."
        label.translatesAutoresizingMaskIntoConstraints = false
        centerView.addSubview(label)
        
        let activityIndicator = UIActivityIndicatorView(style:.medium)
        activityIndicator.startAnimating()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        centerView.addSubview(activityIndicator)
        activityView.startAnimating()
        
        
        let views = ["label": label, "activity": activityIndicator]
        let hConstraints = NSLayoutConstraint.constraints(withVisualFormat: "|-[activity]-[label]-|", options: [], metrics: nil, views: views)
        let vConstraintsLabel = NSLayoutConstraint.constraints(withVisualFormat: "V:|[label]|", options: [], metrics: nil, views: views)
        let vConstraintsActivity = NSLayoutConstraint.constraints(withVisualFormat: "V:|[activity]|", options: [], metrics: nil, views: views)
        
        centerView.addConstraints(hConstraints)
        centerView.addConstraints(vConstraintsLabel)
        centerView.addConstraints(vConstraintsActivity)
    }
    
    func placeholderViewInsets() -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
}
