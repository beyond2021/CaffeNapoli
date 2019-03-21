//
//  LogInSimpleViewController.swift
//  CaffeNapoli
//
//  Created by KEEVIN MITCHELL on 3/20/19.
//  Copyright © 2019 Kev1. All rights reserved.
//

import UIKit

class SignUpSimpleViewController: UIViewController {
    let plusPhotoButton : UIButton = {
        let button = UIButton()
        let image = #imageLiteral(resourceName: "plus_photo-1")
        button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(plusPhotoButton)
        if #available(iOS 11.0, *) {
            plusPhotoButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 140, height: 140)
        } else {
            plusPhotoButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 140, height: 140)
        }
        plusPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
       
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
