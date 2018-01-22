//
//  SuggestionCell.swift
//  CaffeNapoli
//
//  Created by Kev1 on 12/27/17.
//  Copyright © 2017 Kev1. All rights reserved.
//

import UIKit

class SuggestionCell: UITableViewCell {
//    let cellIdentifier = "cellIdentifier"
    
    
    
    
    
    let suggestionLabel : UILabel = {
        let label = UILabel()
        label.text = "YOU MIGHT ALSO LIKE"
        label.textAlignment = .center
        label.font = UIFont.init(name: "Avenir Next Condensed Demi Bold", size: 15)
        label.textColor = UIColor.tabBarBlue()
        return label
    }()
    
    lazy var  suggestionCollectionView : UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        let CVFrame = CGRect(x: 0, y: 24, width:  self.bounds.size.width, height: 373)
        let cv = UICollectionView(frame: CVFrame, collectionViewLayout: layout)
        cv.backgroundColor = .white
       return cv
    }()
    
    
    //
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //        backgroundColor = .green
        addSubview(suggestionLabel)
        suggestionLabel.anchor(top: topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 13, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 124, height: 21)
        suggestionLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        addSubview(suggestionCollectionView)
        
        suggestionCollectionView.anchor(top: suggestionLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 24, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 373)

       
        
    }
    
    
}
