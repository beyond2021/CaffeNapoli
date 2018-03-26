//
//  UserProfileController.swift
//  CaffeNapoli
//
//  Created by Kev1 on 10/10/17.
//  Copyright © 2017 Kev1. All rights reserved.
//

import UIKit
import Firebase

class UserProfileController : UICollectionViewController, UICollectionViewDelegateFlowLayout, UserProfileHeaderDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func showEditProfileController() {
        let editProfileVC = EditProfileController()
        //TODO pass the logged in user here
//        navigationController?.pushViewController(editProfileVC, animated: true)
        present(editProfileVC, animated: true, completion: nil)
    }
    
    
    
    func updateProfilePhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        // allow editing
        imagePickerController.allowsEditing = true
        // present picker
        present(imagePickerController, animated: true, completion: nil)
    }
    //To get which photo was picked
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var profileImage : UIImage?
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            profileImage = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            profileImage = originalImage
        }
        guard let newImage = profileImage else { return }
        uploadImage(selectedImage: newImage)
        dismiss(animated: true, completion: nil)
    }
    
    fileprivate func uploadImage(selectedImage:UIImage) {
        print("Trying to upload image")
        //Lets upload the image instead
        let image = selectedImage 
        // turn the image into upload data
        guard let uploadData = UIImageJPEGRepresentation(image, 0.3) else { return }
        // Append New image
        let filename = NSUUID().uuidString
        //
        Storage.storage().reference().child("profile_Images").child(filename).putData(uploadData, metadata: nil, completion: { (metadata, err) in
            //
            if let error = err {
                print("Could not upload profile photo:", error)
                return
            }
            // Photo upload success
            // Append Metadata
            guard   let profileImageURL = metadata?.downloadURL()?.absoluteString else { return }
            print("Successfully uploaded profile photo", profileImageURL)
            
            // Lets save the username in Firebase
            //!:
            let user = Auth.auth().currentUser
            guard let uid = user?.uid else { return}
            // Getb token from the messaging of Firebase
            //to save the username
            let dictionaryValues = [ "profileImageURL" : profileImageURL]
            let values = [uid : dictionaryValues ]
            //this appends new users  on server
            Database.database().reference().child("users").updateChildValues(values, withCompletionBlock: { (err, ref) in
                if let err = err {
                    print("Failed to save user info into db:", err)
                    return
                }
                // success
                print("Successfully saved user info into db")
                //To show the main controller and reset the UI
                guard let mainTabbarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
                mainTabbarController.setupViewControllers()
                self.dismiss(animated: true, completion: nil)
            })
        })
    }
    // View State
    var isGridView = true // default state
    //
    func didChangeToListView() {
        print("did change to list view")
         isGridView = false // toggle to false
        collectionView?.reloadData() // UI
    }
    
    func didChangeToGridView() {
        print("did change to grid view")
         isGridView = true // toggle to true
        collectionView?.reloadData() // UI
    }
    
    let gridCellId = "gridCellId"
    let listCellId = "listCellId"
    var userID:  String? // to show correct user from UserSearchController
    //
    override func viewDidLoad() {
        super.viewDidLoad()
//        collectionView?.backgroundColor = .white
        collectionView?.backgroundColor = UIColor.cellBGColor()
        // We need to registewrb the collectionview with a header
        collectionView?.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerID")
        // Register 2 cell for grid and list layout
        collectionView?.register(UserProfilePhotoCell.self, forCellWithReuseIdentifier: gridCellId)
        collectionView?.register(HomePostCell.self, forCellWithReuseIdentifier: listCellId)
        //Setup the gear icon
        setupLogoutButton()
        fetchUser()
    }
    //
    var isFinishedPaging = false
    var posts = [Post]() // An empty array to hold our posts we get from FB
  
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
    
    
    //
    fileprivate func fetchOrderedPosts() {
//        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        guard let uid = user?.uid else { return }
        
        let postReference = Database.database().reference().child("posts").child(uid)
        // order post by creation date .queryOrdered(byChild: "creationDate")
        
        // perhaps later on we will implement some pagination of data
        
        postReference.queryOrdered(byChild: "creationDate").observe(.childAdded, with: { (snapshot) in
          
//            print(snapshot.key, snapshot.value)
            
            guard let dictionary = snapshot.value as? [String : Any] else { return }
              
            guard let user = self.user else { return }
            
            let post = Post(user: user, dictionary: dictionary)
            self.posts.insert(post, at: 0) // puts it in the front
//            self.posts.append(post)// append goes to the back of the array
            
            self.collectionView?.reloadData()
            
        }) { (error) in
            //
            print("Failed to nfetch ordered post", error)
        }
    }
    
    //Logout
    fileprivate func setupLogoutButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "gear").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleLogout))
        
    }
    @objc func handleLogout() {
      print("Logging out")
        //Alert controller with actionsheet
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        //Add Action
        alertController.addAction(UIAlertAction(title: "Log Out Caffe Napoli", style: .destructive, handler: { (_) in
            do {
           try Auth.auth().signOut()
             //WE NEED TO PRE4SENT SOME KING OF LOGIN CONTROLLER
//                let loginController = LoginController()
                let loginController = LoginAuthController()
                let navigationController = UINavigationController(rootViewController: loginController)
                self.present(navigationController, animated: true, completion: nil)
//                self.dismiss(animated: true, completion: nil)
                
            } catch let signOutError {
                print("Failed to sign Out", signOutError)
            }
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    // size for cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //GridView/ListView
        //Route
        if isGridView {
            let width = (view.frame.width - 2) / 3 // math to have 3 cells in one row.
            
            return CGSize(width: width, height: width)
        } else {
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
    //Number of items
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //
        return posts.count
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
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //
        print("I selected :", indexPath.item)
        let editPostController = EditPhotoController()
        self.navigationController?.pushViewController(editPostController, animated: true)
    }
    
    
    //Setting up the header for the collectionview on the profile page
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        // here u have to return a UICollectionReusableView
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerID", for: indexPath) as! UserProfileHeader // we can use bang! because we registered the UserProfileHeader in viewDidLoad
        
        //
        header.user = self.user //THIS LINE SET THE USER IN HEADERVIEWCONTROLLER
        // grid view change
         header.delegate = self
        //
        //IT IS WRONG TO TRY TO ADD SUBVIEWS TO HERE
        return header
    }
    //Must specify the size of the header UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        //
        return CGSize(width: view.frame.width, height: 200)
    }
    
    
    //private - this func only accessable in UserProfileController
    var user: User?
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
}

