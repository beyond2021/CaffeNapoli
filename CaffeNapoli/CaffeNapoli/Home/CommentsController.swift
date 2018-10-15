//
//  CommentsController.swift
//  CaffeNapoli
//
//  Created by Kev1 on 12/3/17.
//  Copyright © 2017 Kev1. All rights reserved.
//

import UIKit
import Firebase

class CommentsController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    
    
    var post : Post?
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Comments"
        collectionView?.backgroundColor = .white
        collectionView?.alwaysBounceVertical = true // for scrolling
        collectionView?.indicatorStyle = UIScrollViewIndicatorStyle.black
        collectionView?.keyboardDismissMode = .interactive// for dismissal
        
//        collectionView?.backgroundColor = .red
        collectionView?.register(CommentsCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -50, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: -50, right: 0)
        fetchComments()
       
    }
    var comments = [Comment]() // container to hold the comments empty
    fileprivate func fetchComments() {
        //1: get the reference to the comments
        guard let postId = self.post?.id else { return }
        let ref = Database.database().reference().child("comments").child(postId)
        ref.observe(.childAdded, with: { (snapshot) in
            
            //
//          print(snapshot.value )
            // cast snapshot into a dictionary
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            //try to get the user for the comment here. get the uid
            guard let uid = dictionary["uid"] as? String else { return }// uid for the user of this parrticular comment
            // get the user from firebase
            Database.fetchUserWithUIUD(uid: uid, completion: { (user) in
                //here we have the uid
                // create the comment
//                var comment = Comment(dictionary: dictionary)
                //            print(comment.text, comment.uid)
                
                //add user to comment here
//                comment.user = user
                
                let comment = Comment(user: user, dictionary: dictionary)
                
                //we can now fill the cells with comments
                self.comments.append(comment)
                //
                self.collectionView?.reloadData()
                
            })
            
            
           
            
            
        }) { (err) in
            print("Failed to get comments:", err)
        }
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // remove the tabbar
        tabBarController?.tabBar.isHidden = true
    }
    
    
    
    // set the tabbar back in home controller
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //
        tabBarController?.tabBar.isHidden = false
    }
    //
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        //
        return 0
    }
    
    //
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 10
        return comments.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CommentsCell
        // set the comment for cell here
        cell.comment = comments[indexPath.item]
        return cell
    }
    //
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //self sizing
        //1: Create dummy cell
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let dummyCell = CommentsCell(frame: frame)
        //2: get the appropriate comment
        dummyCell.comment = comments[indexPath.item]
        //3: Fit the comment
        dummyCell.layoutIfNeeded()
        //
        //4: Set large height target size
        let targetSize = CGSize(width: view.frame.width, height: 1000)
        
        //5: self sizing
        let estimatedSize = dummyCell.systemLayoutSizeFitting(targetSize)
        //6: Height logic
        let height = max(40 + 8 + 8, estimatedSize.height)
        return CGSize( width: view.frame.width, height:height )
    }
    
    //
    let  commentsTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Comment"
        return textField
    }()
    
    
    //This construction is containerView is holding on to its referencve
    lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        //
        //submit button
        let submitButton = UIButton(type: .system)
        submitButton.setTitle("Submit", for: .normal)
        submitButton.setTitleColor(.black, for: .normal)
        submitButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        submitButton.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        containerView.addSubview(submitButton)
        submitButton.anchor(top: containerView.topAnchor, left: nil, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 50, height: 0)
        
        // input text
        
        containerView.addSubview(self.commentsTextField)
        self.commentsTextField.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: submitButton.leftAnchor, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        let lineSeparatorView = UIView()
        lineSeparatorView.backgroundColor = UIColor.rgb(displayP3Red: 230, green: 230, blue: 230)
        containerView.addSubview(lineSeparatorView)
        lineSeparatorView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)
        
        return containerView
        
    }()
    
    
    
    @objc func handleSubmit() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        print("post id:", self.post?.id ?? "")
        
        // 1: print the text in the textField
        print("Inserting comment:", commentsTextField.text ?? "")
        
        //2: now that we have the comment let insert it into FireBase DataBase. Create comments node. This is where all our comments are going to live.
//        let postId = "temporaryPostId"
        let postId = self.post?.id ?? "" // post id comming from Homecontroller
        
        
        
        let values = ["text": commentsTextField.text ?? "", "creationDate":Date().timeIntervalSince1970,"uid" : uid ] as[String:Any] // values payload to upload
//        Database.database().reference().child("comments").child(postId).updateChildValues(values) { (err, reference) in
        // childByAutoId() add the list of comments
        Database.database().reference().child("comments").child(postId).childByAutoId().updateChildValues(values) { (err, reference) in
            //
            if let err = err {
                print("Could not upload comment", err)
                return
            }
            // Success
            print("Successfully uploaded comment.")
            
        }
        
        
    }
    
    
    
    // keyboardb input at the bottom. every page on an iphone has the ability to receive text input( inputAccessoryView)
    override var inputAccessoryView: UIView? {
        get {
           return containerView
        }
        
    }
    // To show the input accessory view
    override var canBecomeFirstResponder: Bool {
       return true
        
    }
    
    
    
}
