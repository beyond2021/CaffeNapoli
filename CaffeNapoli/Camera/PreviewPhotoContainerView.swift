//
//  PreviewPhotoContaimerView.swift
//  CaffeNapoli
//
//  Created by Kev1 on 11/25/17.
//  Copyright © 2017 Kev1. All rights reserved.
//

import UIKit
import  Photos

class PreviewPhotoContainerView: UIView {
    //
    let previewImageView: UIImageView = {
        let iv = UIImageView()
        
        return iv
    }()
    //
    let cancelButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "cancel_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
    
    return button
    }()
    
   //
    let saveButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "save_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
        
        return button
    }()
    @objc func handleSave() {
        print("handling save..... ")
        //1: PHOTOS SDK
        //2: get breference to photo library
        //3: get the image
        guard let perviewImage = previewImageView.image else  {return}
        let library = PHPhotoLibrary.shared()
        library.performChanges({
            //
            PHAssetChangeRequest.creationRequestForAsset(from: perviewImage)
            
            
        }) { (success, error) in
            //
            if let err = error {
                print("Failed to save image...", err)
                return
            }
            // success
            print("Successfullyb saved image to library...")
            DispatchQueue.main.async {
                //
                let savedLabel = UILabel()
                savedLabel.text = "Saved Successfully"
                savedLabel.font = UIFont.boldSystemFont(ofSize: 18)
                savedLabel.textAlignment = .center
                savedLabel.textColor = .white
                savedLabel.backgroundColor = UIColor(white: 0, alpha: 0.3)
                savedLabel.numberOfLines = 0
                //frame anchoring when animating
                savedLabel.frame = CGRect(x: 0, y: 0, width: 150, height: 80)
                //center the label
                savedLabel.center = self.center
                
                self.addSubview(savedLabel)
                //animation start
                savedLabel.layer.transform = CATransform3DMakeScale(0, 0, 0)
                // Animation
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                    //
                    savedLabel.layer.transform = CATransform3DMakeScale(1, 1, 1)
                }, completion: { (completed) in
                    // Animate out
                    UIView.animate(withDuration: 0.5, delay: 0.75, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                        //
                        savedLabel.layer.transform = CATransform3DMakeScale(0.1, 0.1, 0.1)
                        savedLabel.alpha = 0
                        
                    }, completion: { (_) in
                        //
                            savedLabel.removeFromSuperview()
                    })
                    
                    
                    
                    
                })
                
            }
            
        }
       
        
    }
    
    @objc func handleCancel() {
       print("Dismissing ")
        self.removeFromSuperview()
        
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .yellow
        addSubview(previewImageView)
        addSubview(cancelButton)
        addSubview(saveButton)
        previewImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        cancelButton.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        saveButton.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 24, paddingBottom: 24, paddingRight: 0, width: 50, height: 50)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
