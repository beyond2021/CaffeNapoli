//
//  EditPhotoController.swift
//  CaffeNapoli
//
//  Created by Kev1 on 3/18/18.
//  Copyright © 2018 Kev1. All rights reserved.
//

import UIKit

class EditPhotoController: UICollectionViewController,  UICollectionViewDelegateFlowLayout {
    func didLike(for cell: HomePostCell, post: Post) {
        //
    }
    
    func handlePinch(sender: UIPinchGestureRecognizer, imageView: UIImageView) {
        //
    }
    
   
    func swipeRightForCamera() {
        //
    }
    
    func didTapComment(post: Post) {
        print("Tapping Cooment")
    }
    
    func didLike(for cell: HomePostCell) {
        print("Tapping Like")
    }
    
    func showMore(post: Post, sender: HomePostCell) {
        print("Tapping Show more")
    }
    
    let cellID = "cellID"
    var post : Post? {
        didSet {
           print("Post to edit is set")
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = UIColor.cellBGColor()
        collectionView?.register(HomePostCell.self, forCellWithReuseIdentifier: cellID)
        title = "Edit Post"
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! HomePostCell
        cell.post = post
//        cell.delegate = self
        return cell
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
}
