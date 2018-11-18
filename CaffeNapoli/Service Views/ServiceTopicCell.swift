//
//  ServiceTopicCell.swift
//  CaffeNapoli
//
//  Created by KEEVIN MITCHELL on 11/15/18.
//  Copyright © 2018 Kev1. All rights reserved.
//

import UIKit

class ServiceTopicCell : UICollectionViewCell {
    
    let topicTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
     
        label.text = "Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of de Finibus Bonorum et Malorum Contrary to popular belief"
       
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        backgroundColor = .cyan
        addSubview(topicTextLabel)
        topicTextLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        topicTextLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        topicTextLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        topicTextLabel.heightAnchor.constraint(equalToConstant: 400)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
