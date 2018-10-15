//
//  CNUserProfileController.swift
//  CaffeNapoli
//
//  Created by Kev1 on 3/27/18.
//  Copyright © 2018 Kev1. All rights reserved.
//

import UIKit
import Firebase

class CNUserProfileController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    
   
    
    
    fileprivate func fetchUser() {
        //1: to fecth the user's name'
        //Database.database().reference() -> https://console.firebase.google.com/project/caffenapoli-8774f/database/data
        //This is the root of your database
        // .child("users") -> gets u to the Node
        // 2nd -> .child(Auth.auth().currentUser?.uid)
        // To unwrap
        //Correct use select logic
        let uid = userID ?? (Auth.auth().currentUser?.uid ?? "")
        //1: check if userID(the one set it in UserSearchController) is not nil use it else user current user id
        //
        //guard let uid = Auth.auth().currentUser?.uid else { return }
        //.observeSingleEvent(of: .value, with: { (snapshot) in.-> observe this one event and stop
        Database.fetchUserWithUIUD(uid: uid) { (user) in
            //
            self.user = user
            self.navigationItem.title = self.user?.username
            
            // TO STOP FECTHING DICTIONARY TWICE
            self.collectionView?.reloadData()
            // now we fetch the posts
            //            self.fetchOrderedPosts()
            //Pagination
            self.paginatePosts()
        }
    }
        
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
          return posts.count
//        return 4
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // show you how to fire off the paginate call
        //check if the last cell has been rendered then fire off the paginate
        if indexPath.item == self.posts.count - 1 && !isFinishedPaging {
            print("Paginating for posts")
            paginatePosts() // keeps repeating
        }
     
        
       
        if isGridView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: gridCellId, for: indexPath) as! UserProfilePhotoCell        //cell.backgroundColor = .purple
            cell.post = posts[indexPath.row]
            
            return cell
            
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: listCellId, for: indexPath) as! HomePostCell        //cell.backgroundColor = .purple
            cell.post = posts[indexPath.row]
            
            return cell
            
        }
    }
    
    var posts = [Post]()
    var userID:  String?
    var user: User?
    let gridCellId = "gridCellId"
    let listCellId = "listCellId"
    var isFinishedPaging = false
    // View State
    var isGridView = true

    //
    //MARK:- PAGINATION
    fileprivate func paginatePosts(){
        print("Start paging for more posts")
        
        guard let uid = self.user?.uid else { return }
        
        let ref = Database.database().reference().child("posts").child(uid)
        
        //        var query = ref.queryOrderedByKey() // this query works but out of order.
        var query = ref.queryOrdered(byChild: "creationDate")
        if posts.count > 0 {
            //            let value = posts.last?.id //last post
            let value = posts.last?.creationDate.timeIntervalSince1970 // order posts by date
            query = query.queryEnding(atValue: value) // this is a query from the front of the list
        }
        
        //        query.queryLimited(toFirst: 4).observe(.value, with: { (snapshot) in // this is a query from the front of the list
        
        query.queryLimited(toLast: 4).observe(.value, with: { (snapshot) in
            
            guard var allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
            
            allObjects.reverse()
            
            if allObjects.count < 4 {
                self.isFinishedPaging = true
            }
            if self.posts.count > 0 && allObjects.count > 0 {
                allObjects.removeFirst()
            }
            allObjects.forEach({ (snapshot) in
                print(snapshot.key) // AnyObject
                guard let user = self.user else { return }
                guard let dictionary = snapshot.value as? [String: Any] else { return }
                //                var post = Post(user: user, dictionary: dictionary)
                var post = Post(user: user, dictionary: dictionary)
                //
                post.id = snapshot.key
                self.posts.append(post)
            })
            // pagination logic
            self.posts.forEach({ (post) in
                print(post.id ?? "")
            })
            self.collectionView?.reloadData()
        }) { (err) in
            //
            print("Failed to paginate for posts:", err)
        }
        
    }
    
    
    
//    //
//    let bgImageView: UIImageView = {
//        let iv = UIImageView()
//        iv.image = #imageLiteral(resourceName: "UPBg")
//        iv.contentMode = .scaleAspectFill
//       return iv
//    }()
//
//    let blurView: UIVisualEffectView = {
//        let blurEffect = UIBlurEffect(style: .light)
//        let view = UIVisualEffectView(effect: blurEffect)
//        view.translatesAutoresizingMaskIntoConstraints = false
//
//        view.layer.cornerRadius = 15
//        view.clipsToBounds = true
////        view.layer.masksToBounds = true
//        return view
//    }()
//
//    var drawLeadingConstraint : NSLayoutConstraint?
//
//    let drawerView: UIView = {
//        let view = UIView()
//        view.layer.shadowColor = UIColor.black.cgColor
//        view.layer.shadowOpacity = 0.8
//        view.layer.shadowOffset = CGSize(width: 5, height: 0)
//        view.backgroundColor = .clear
//        view.translatesAutoresizingMaskIntoConstraints = false
////        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(openCloseDrawer)))
//        return view
//    }()
//    @objc  func openCloseDrawer(sender:UIPanGestureRecognizer) {
//        print("Trying to or closee drawer ")
//        //checK state of pan
//        if sender.state == .began || sender.state == .changed {
//            //get the translation or amount of change
//            let translation = sender.translation(in: self.view).x // we get both x and y we only need x
//            //check if the swiping was left or right
//            if translation > 0 {
//                // swiping right
////                self.drawLeadingConstraint?.constant += translation
//                print("Trying to or open drawer ",translation)
//                drawLeadingConstraint = drawerView.widthAnchor.constraint(equalToConstant:  translation)
//                self.view.layoutIfNeeded()
//            } else {
//                //swipe left
//                print("Trying to or close drawer ",translation)
//                drawLeadingConstraint = drawerView.widthAnchor.constraint(equalToConstant:  -translation)
//                self.view.layoutIfNeeded()
//
//            }
//
//        } else if sender.state == .ended {
//
//
//        }
//
//
//    }
//    //Let manually add our views
//    lazy var  profileImageView: CustomImageView = {
//        let iv = CustomImageView()
//        iv.image = #imageLiteral(resourceName: "avatar1")
//        iv.isUserInteractionEnabled = true
//        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(updatePhoto)))
//        return iv
//    }()
//    @objc  func updatePhoto() {
//        print("Trying to update photo from Header")
//    }
//    let usernameLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Username"
//        label.font = UIFont.boldSystemFont(ofSize: 14)
//        return label
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .white
        
        collectionView?.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerID")
        // Register 2 cell for grid and list layout
        collectionView?.register(UserProfilePhotoCell.self, forCellWithReuseIdentifier: gridCellId)
        collectionView?.register(HomePostCell.self, forCellWithReuseIdentifier: listCellId)
        //Setup the gear icon
//        setupLogoutButton()
        fetchUser()
        setupSubViews()
    }
    
    
    
    func setupSubViews() {
       
    }
    var CollectionViewLeadingConstraint : NSLayoutConstraint?
    
    @objc private func handleTap() {
        print("Tapping on view")
//        drawLeadingConstraint.constant = 175
//        print(drawLeadingConstraint.constant)
//        if drawLeadingConstraint.constant == 175 {
//        drawLeadingConstraint.constant = 0
//        } else {
//        drawLeadingConstraint.constant = 175
//        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //GridView/ListView
        //Route
        if isGridView {
            let width = (175 - 1) / 2 // math to have 3 cells in one row.
            
            return CGSize(width: width, height: width)
        } else {
            //How tall the cell is
            var height: CGFloat = 40 + 8 + 8 // Username UserProfile
            height += view.frame.width
            //
            height += 50// for bottom buttons
            // Caption label
            height += 60
            
            return CGSize(width: 175, height: height)
        }
        
        
    }
    //spacing of cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if isGridView {
            return 1
        } else {
            return 10
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    
}
