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
    func didLike(for cell: HomePostCell) {
        guard let indexpath = collectionView?.indexPath(for: cell) else { return }
        //         get the post
        var post = self.posts[indexpath.item]
        // print(post.caption)
        // Introduce a 5th node in firebase called likes
        guard let postId = post.id else { return }
        //current user uid
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let values = [uid:post.hasLiked == true ? 0 : 1] // me liking or unliking this post
        print("like :", post.hasLiked)
        if post.hasLiked == false {
            animateLikes()
            playAudio(sound: "OK Hand Sign", ext: "wav")
        }
        Database.database().reference().child("likes").child(postId).updateChildValues(values) { (error, reference) in
            if let err = error {
                print("Could not like post", err)
                return
            }
            // success
            //            print("Successfully liked post")
            post.hasLiked = !post.hasLiked // toggle like button
            self.posts[indexpath.item] = post // because of structs
            self.collectionView?.reloadItems(at: [indexpath])
        }
    }
    
    func animateLikes() {
        (0...10).forEach { (_) in
            generateAnimatedViews()
        }
    }
    func generateAnimatedViews() {
        let image = drand48() > 0.5 ? #imageLiteral(resourceName: "heart") : #imageLiteral(resourceName: "thumbsUp")
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
    

