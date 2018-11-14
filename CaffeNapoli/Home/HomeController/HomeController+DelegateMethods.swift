//
//  HomeController+DelegateMethods.swift
//  CaffeNapoli
//
//  Created by KEEVIN MITCHELL on 11/14/18.
//  Copyright © 2018 Kev1. All rights reserved.
//

import UIKit
import Firebase

extension HomeController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if posts.count > 0 {
            noPostsAvailableLabel.alpha = 0
            howToSeePostsLabel.alpha = 0
        } else {
            noPostsAvailableLabel.alpha = 1
        }
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeController.cellID, for: indexPath) as! HomePostCell
        cell.layer.shadowRadius = 5;
        cell.layer.shadowOpacity = 0.25;
        cell.post = posts[indexPath.item]
        cell.delegate = self
        return cell
        
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //
        //        print("I selected :", indexPath.item)
        let post = posts[indexPath.item]
        //        print(post.user)
        if post.user.uid == Auth.auth().currentUser?.uid {
            let editPostController = EditPhotoController()
            self.navigationController?.pushViewController(editPostController, animated: true)
        } else {
            return
        }
    }
    
    
    //    Cell sizes
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //How tall the cell is
        var height: CGFloat = 40 + 8 + 8 // Username UserProfile
        height += view.frame.width
        //
        height += 50// for bottom buttons
        // Caption label
        height += 60
        return CGSize(width: view.frame.width, height: height)
    }
    
    func handleErrorWhenContentAvailable(_ error: Error) {
        let alertController = UIAlertController(title: "Ooops", message: "Something went wrong.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}
