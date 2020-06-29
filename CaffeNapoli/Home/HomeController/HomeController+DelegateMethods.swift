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
        postCount = posts.count
        return posts.count
    }
    /*
    func getLikesFromPosts(post: Post){
        
//        let likesCount = post.likesCount
//        print(" likes for post: \(likesCount)")
        let postReference = Database.database().reference().child(HomeController.postsNode).child(post.id!)
        postReference.observeSingleEvent(of: .value, with: { (postsSnapshot) in
            print(postsSnapshot.value)
//            self.collectionView?.refreshControl?.endRefreshing() //iOS 10
            guard let dictionaries =  postsSnapshot.value as? [String: Any] else { return }
            dictionaries.forEach({ (key, value) in
                guard let dictionary = value as? [String: Any] else { return }
            
            
//                var post = Post(user: user, dictionary: dictionary)
//                post.id = key
//                guard let currentUserUid = Auth.auth().currentUser?.uid else { return }
//                Database.database().reference().child(HomeController.likesNode).child(key).child(currentUserUid).observeSingleEvent(of: .value, with: { (snapshot) in
//                    print("Change")
            }) })
        
        
        
    }
 */
            
       
      
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeController.cellID, for: indexPath) as! HomePostCell
        cell.layer.shadowRadius = 5;
        cell.layer.shadowOpacity = 0.25;
        cell.layer.cornerRadius = (60/2)
        
        
        cell.post = posts[indexPath.item]
        cell.delegate = self
//        getLikesFromPosts(post: cell.post!)
        return cell
        
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("tapped on post")
        //
        //        print("I selected :", indexPath.item)
        let post = posts[indexPath.item]
        print(post.user.uid)
//        if post.user.uid == Auth.auth().currentUser?.uid {
//            let editPostController = EditPhotoController()
//            self.navigationController?.pushViewController(editPostController, animated: true)
//        } else {
//            return
//        }
    }
    
    
    //    Cell sizes
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //How tall the cell is
        var height: CGFloat = 40 + 8 + 8 + 20// Username UserProfile
        height += view.frame.width
        //
        height += 50// for bottom buttons
        // Caption label
        height += 60
        return CGSize(width: view.frame.width - 20, height: height)
    }
    
    func handleErrorWhenContentAvailable(_ error: Error) {
        let alertController = UIAlertController(title: "Ooops", message: "Something went wrong.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}
