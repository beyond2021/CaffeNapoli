//
//  HomeController+Actions.swift
//  CaffeNapoli
//
//  Created by KEEVIN MITCHELL on 11/14/18.
//  Copyright © 2018 Kev1. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase
extension HomeController {
    
    
    
    func handlePinch(sender: UIPinchGestureRecognizer, imageView: UIImageView) {
        print("Handling for home")
    }
    
    
    func swipeRightForCamera() {
        print("Showing Camera")
        handleCamera()
    }
    
    
    func showMore(post: Post, sender : HomePostCell) {
        
        
        print("showing more from home controller")
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Share to Facebook", style: .default, handler: { (_) in
            print("facebook Action")
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Share on Instagram", style: .default, handler: { (_) in
            print("Instagram Action")
        }))
        actionSheet.addAction(UIAlertAction(title: "Copy Link", style: .default, handler: { (_) in
            print("Copy  Action")
        }))
        actionSheet.addAction(UIAlertAction(title: "Report", style: .default, handler: { (_) in
            print("Report Action")
        }))
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            print("Cancel button tapped")
        }
        
        actionSheet.addAction(cancel)
        present(actionSheet, animated: true, completion: nil)
        
    }
    
    
    
    //MARK:-    Saving the like state logic
    
    static let updateFeedNotificationName = NSNotification.Name("UpdatePostLikeCount")
func didLike(for cell: HomePostCell, post:Post) {
//    post.hasLiked = !post.hasLiked // toggle like button
    guard let uid = Auth.auth().currentUser?.uid else { return }
//    print("My uid: \(uid)")
    let postUserUID = post.user.uid
    
    
    if uid == postUserUID {
        print("Not alloed to like")
        return
    } else {
        print("Allowed to like")
        guard let postId = post.id else { return }
        let postUserID = post.user.uid
        // like or unlike post
            
        
        if post.hasLiked  {
            LikePost(cell: cell, postUserID: postUserID, postID: postId){
                print("liking post")
                }
            
        } else {
            unlikePost(cell: cell, postUserID: postUserID, postID: postId) {
                print("unliking Post")
            }
            
        }
        
        
    }
    

  
    }
    private func updateLikeImage(cell: HomePostCell, postID: String, postUserID: String, completionBlock : @escaping (() -> Void)) {
        let prntRef = Database.database().reference().child("posts").child(postUserID).child(postID).child("hasLiked")

        prntRef.runTransactionBlock({ (resul) -> TransactionResult in
        if let image_Initial = resul.value as? Bool{

            resul.value = !image_Initial
            //Or HowSoEver you want to update your dealResul.
            return TransactionResult.success(withValue: resul)
        }else{

            return TransactionResult.success(withValue: resul)

        }
        }, andCompletionBlock: {(error,completion,snap) in

//                print(error?.localizedDescription)
//                print(completion)
//                print(snap)
            if !completion {

               print("Couldn't Update the node")
            }else{

                completionBlock()
            }
        })
    }
    
    func LikePost(cell: HomePostCell, postUserID: String ,postID: String, completionBlock : @escaping (() -> Void)){
       
       
        let prntRef = Database.database().reference().child("posts").child(postUserID).child(postID).child("likesCount")

        prntRef.runTransactionBlock({ (resul) -> TransactionResult in
        if let dealResul_Initial = resul.value as? Int{

            resul.value = dealResul_Initial + 1
            //Or HowSoEver you want to update your dealResul.
//             self.updatePostCount(postID: postID, postUserID: postUserID)
        
            return TransactionResult.success(withValue: resul)
        }else{

            return TransactionResult.success(withValue: resul)

        }
        }, andCompletionBlock: {(error,completion,snap) in

//                print(error?.localizedDescription)
//                print(completion)
//                print(snap)
            if !completion {

               print("Couldn't Update the node")
            }else{

                completionBlock()
            }
        })

     
    }
   
    
   // unlike Post
    
    func unlikePost(cell: HomePostCell, postUserID: String ,postID: String, completionBlock : @escaping (() -> Void)){
       
        defer {
            //  NotificationCenter.default.post(name: SharePhotoController.updateFeedNotificationName, object: nil)
        
            updateLikeImage(cell: cell, postID: postID, postUserID: postUserID) {
//                print("updating like image")
            }
           NotificationCenter.default.post(name: HomeController.updateFeedNotificationName, object: nil)
        }

        let prntRef = Database.database().reference().child("posts").child(postUserID).child(postID).child("likesCount")

        prntRef.runTransactionBlock({ (resul) -> TransactionResult in
        if let dealResul_Initial = resul.value as? Int{
            if dealResul_Initial >= 1{
            resul.value = dealResul_Initial - 1
            } else {
             resul.value = 0
            }
            //Or HowSoEver you want to update your dealResul.
            return TransactionResult.success(withValue: resul)
        }else{

            return TransactionResult.success(withValue: resul)

        }
        }, andCompletionBlock: {(error,completion,snap) in

//                print(error?.localizedDescription)
//                print(completion)
//                print(snap)
//
          
            
            if !completion {

               print("Couldn't Update the node")
            }else{

                completionBlock()
            }
        })

     
    }
    
    
   
   /*
    func didLike(for cell: HomePostCell, post:Post) {
        
        
       
        
        guard let indexpath = collectionView?.indexPath(for: cell) else { return }
        //         get the post
        var post = self.posts[indexpath.item]
        // print(post.caption)
        // Introduce a 5th node in firebase called likes
        guard let postId = post.id else { return }
        print("Post id is: \(postId)")
        //current user uid
        guard let uid = Auth.auth().currentUser?.uid else { return }
//        let values = [uid:post.hasLiked == true ? 1 : 0] // me liking or unliking this post
        
        
        // udate values in backend
        // get likes count
        // add 1
        // get liked status
        // update if necessary
//        guard let likesCount = post.likesCount else { return }
//        let newLikesCount = NSNumber(value: Int(likesCount) + 1)
        let newLikesCount =  likes + 1
        likes = newLikesCount
        print(newLikesCount)
        let userPostRef = Database.database().reference().child("posts").child(postId)
        let listReference = userPostRef.childByAutoId()
        let values = ["likesCount" :newLikesCount] as [String:Any]
        
         
        listReference.updateChildValues(values) { (error, reference) in
            //
            if let err = error {
                //reenable the share button if there is an error
//                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print("There was an error updating  post to database", err)
                return
            }
            print("successfully saved updated post to database")
            //Dismiss the share controller
//            self.activityView.stopAnimating()
//            self.dismiss(animated: true, completion: nil)
//            //POST A NOTIFICATION TO THE ENTIRE SYSTEM HERE!
//
//            NotificationCenter.default.post(name: SharePhotoController.updateFeedNotificationName, object: nil)
       
        //}
                    
      //  }
    }
 
        
//        if post.hasLiked  {
////            likesCount  = likesCount + 1
////            self.fetchLikesCount()
//        } else if !post.hasLiked && likesCount > 0 {
////            likesCount  = likesCount - 1
//
//        } else {
////             likesCount  = 0
//        }
//
        /*
        print("Likes count is: ",self.likesCount)
        print("like :", post.hasLiked)
        if post.hasLiked != false {
            animateLikes()
            playAudio(sound: "OK Hand Sign", ext: "wav")
            let ref = Database.database().reference().child("likesCount").child(postId)
                    ref.observe(.childAdded, with: { (snapshot) in
                        
                        //
                        print("Likes snapshot is:",snapshot.value )
                        // cast snapshot into a dictionary
                        guard let dictionary = snapshot.value as? [String: Any] else { return }
                        //try to get the user for the comment here. get the uid
            //            guard let uid = dictionary["uid"] as? String else { return }// uid for the user of this parrticular comment
                        guard let likesCount = dictionary["likesCount"] as? String else { return }
                    })
                    
                    
                    //
                    
                    Database.database().reference().child("likesCount").child(postId).updateChildValues(values) { (error, reference) in
                        if let err = error {
                            print("Could not like post", err)
                            return
                        }
                        // success
                        //            print("Successfully liked post")
                        post.hasLiked = !post.hasLiked // toggle like button
                        self.posts[indexpath.item] = post // because of structs
                        self.post?.likesCount = self.likesCount
                        self.collectionView?.reloadItems(at: [indexpath])
                        
            }
        } else {
            Database.database().reference().child("likesCount").child(postId).updateChildValues(values) { (error, reference) in
                        if let err = error {
                            print("Could not like post", err)
                            return
                        }
                        // success
                print("Unlike count: \(self.likesCount)")
                        post.hasLiked = !post.hasLiked // toggle like button
                        self.posts[indexpath.item] = post // because of structs
                self.post?.likesCount = self.likesCount
                        self.collectionView?.reloadItems(at: [indexpath])
                        
            }
        }
        //
        */
        
        
    }
    
*/
    
    /*
    func didLike(for cell: HomePostCell, post:Post) {
        guard let indexpath = collectionView?.indexPath(for: cell) else { return }
        var newPost = self.posts[indexpath.item]
        newPost.hasLiked = false
        var couldLike = false
        // check if current user ID and post owner ID is the same
        //1: get current user
         let uid = Auth.auth().currentUser?.uid
        //2: Get the post userID
        let postUserId = post.user.uid
        //3: compare UIDs
        if uid == postUserId {
             print("Leaving Scope")
            couldLike = false
            return
           
        } else {
       couldLike = true
        
        
        //
       
            print("\(post.id ?? "") \(newPost.id ?? "")")
            // update like count
            likesCount = likesCount + 1
            newPost.likesCount = likesCount
            print("likes count:\(likesCount)")
            // update image
            newPost.hasLiked = true
            let values = [uid:post.hasLiked == true ? 1 : 0]
            // update server
            
        }
        }
        */
   
    
    func animateLikes() {
        (0...10).forEach { (_) in
            generateAnimatedViews()
        }
    }
    /*
    private func fetchLikesCount() {
        //        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        guard let uid = user?.uid else { return }
        
        let postReference = Database.database().reference().child("likesCount").child(uid)
        
        postReference.observe(.childAdded) { (snapshot) in
            print(snapshot.key, snapshot.value)
            print("Fetch likes count : \(snapshot.value)")
        }
    }
 */
        
        
//        postReference.queryOrdered(byChild: "creationDate").observe(.childAdded, with: { (snapshot) in
//
//            //            print(snapshot.key, snapshot.value)
//
//            guard let dictionary = snapshot.value as? [String : Any] else { return }
//
//            guard let user = self.user else { return }
//
//            let post = Post(user: user, dictionary: dictionary)
//            self.posts.insert(post, at: 0) // puts it in the front
//            //            self.posts.append(post)// append goes to the back of the array
//            //             self.getMyPosts()
//            self.collectionView?.reloadData()
//
//        }) { (error) in
//            //
//            print("Failed to nfetch ordered post", error)
//        }
 //   }
    
    
    
    func generateAnimatedViews() {
        let image = drand48() > 0.5 ? #imageLiteral(resourceName: "icons8-heart-filled-50") : #imageLiteral(resourceName: "icons8-heart-filled-50")
        let imageView = UIImageView(image: image)
        let dimensions = 20 + drand48() * 10
        imageView.frame = CGRect(x: 0, y: 0, width: dimensions, height: 30)
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.path = customPath().cgPath
        animation.duration = 2 + drand48() * 3
        animation.fillMode = CAMediaTimingFillMode.forwards //removes from view
        animation.isRemovedOnCompletion = false
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        imageView.layer.add(animation, forKey: nil)
        view?.addSubview(imageView)
    }
    // MARK:- Sound
    
    func playAudio(sound: String, ext: String) {
        let url = Bundle.main.url(forResource: sound, withExtension: ext)!
        do {
            bombSoundEffect = try AVAudioPlayer(contentsOf: url)
            guard let bombSound = bombSoundEffect else { return }
            bombSound.prepareToPlay()
            bombSound.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    func didTapComment(post: Post) {
        let commentsController = CommentsController(collectionViewLayout: UICollectionViewFlowLayout())
        commentsController.post = post
        navigationController?.pushViewController(commentsController, animated: true)
       
    }
    
}


func customPath() -> UIBezierPath {
    let path = UIBezierPath()
    //    starting point
    path.move(to: CGPoint(x: 20, y: 480))
    let endPoint = CGPoint(x: 600, y: 480)
    //     path.addLine(to: endPoint)
    let randonYShift = 200 + drand48() * 300
    let cp1 = CGPoint(x: 120, y: 380 - randonYShift)
    let cp2 = CGPoint(x: 200, y: 580 + randonYShift)
    path.addCurve(to: endPoint, controlPoint1: cp1, controlPoint2: cp2)
    return path
}

class CurvedView : UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func draw(_ rect: CGRect) {
        // we will do some fancy drawing
        let path = customPath()
        path.lineWidth = 3
        path.stroke()
    }
}
    

