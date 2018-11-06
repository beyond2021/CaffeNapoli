//
//  UserProfileController.swift
//  CaffeNapoli
//
//  Created by Kev1 on 10/10/17.
//  Copyright © 2017 Kev1. All rights reserved.
//

import UIKit
import Firebase

class UserProfileController : UICollectionViewController, UICollectionViewDelegateFlowLayout, CNUserProfileHeaderDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
    
    func getMyPosts(posts: Int) {
//        print("number of posts", posts.count)
//        let header = CNUserProfileHeader()
//        header.posts = posts.count
        let headerView = collectionView?.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: [0,0]) as? CNUserProfileHeader
        //        headerView?.followingLabel.text = "\(count) \nposts"
        let attributedText = NSMutableAttributedString(string: "\(posts)\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "My Stories", attributes:[NSAttributedString.Key.foregroundColor:UIColor.lightGray, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)]))
        
        headerView?.postLabel.attributedText = attributedText
        
    }
    
    func getMyFollowers() {
        print("Getting the people that i am following")
       // get my user ID
        
    }
    var peopleThisUserFollowsCount  = 20
    func getFollowing() {
//        print("Getting my following")
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.fetchUserWithUIUD(uid: uid) { (user) in
            //
            
            self.fetchPersonsThisUserIsFollowing(user: user)
        }

    }
    fileprivate func fetchPersonsThisUserIsFollowing(user: User){
         let followingReference = Database.database().reference().child("following").child(user.uid)
        followingReference.observeSingleEvent(of: .value, with: { (followingSnapshot) in
            print("FollowingSnapshot is:",followingSnapshot.value ?? "There was no snapShot")
            guard let dictionaries =  followingSnapshot.value as? [String: Any] else { return } //we are optionally binding this dictionary to postsSnapshot.value
            // to get each dictionary
           
            dictionaries.forEach({ (key, value) in
                let countedSet = NSCountedSet()
                for (_, value) in dictionaries {
                    countedSet.add(value)
                }
               
                let count = (countedSet.count(for: 1))
                self.peopleThisUserFollowsCount = (countedSet.count(for: 1))
//                print("Count for true: \(countedSet.count(for: 1))")
//                [[_collectionView collectionViewLayout] invalidateLayout]
               
                self.updateLabelWith(count: count)
                print("PeopleThisUserFollowsCount is:\(self.peopleThisUserFollowsCount)")
            })
        })
    }
    
    fileprivate func updateLabelWith(count : Int?) {
       
        guard let count = count else { return }
        print("Will try to update following labe with count", count)
//        let header = CNUserProfileHeader()
//        collectionView?.collectionViewLayout.invalidateLayout()
//        header.following = count
        let headerView = collectionView?.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: [0,0]) as? CNUserProfileHeader
//        headerView?.followingLabel.text = "\(count) \nposts"
                let attributedText = NSMutableAttributedString(string: "\(count)\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
                attributedText.append(NSAttributedString(string: "Watching", attributes:[NSAttributedString.Key.foregroundColor:UIColor.lightGray, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)]))
        
                headerView?.followingLabel.attributedText = attributedText
        
        
    }
    
    
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
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

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
        guard let uploadData = image.jpegData(compressionQuality: 0.3) else { return }
        // Append New image
        let fileName = NSUUID().uuidString
     
         let storageRef = Storage.storage().reference().child("profile_Images").child(fileName)
         
         storageRef.putData(uploadData, metadata: nil) { (metadata, err) in
         
         if let err = err {
         print(err)
         }
         storageRef.downloadURL(completion: { (url, error) in
         if error != nil {
         print("Failed to download url:", error!)
         return
         } else {
         //Do something with url
            print("Successfully uploaded profile photo", url?.absoluteString ?? "")
         let user = Auth.auth().currentUser
         guard let uid = user?.uid else { return}
         guard let name = user?.displayName else { return }
         guard let fcmToken = Messaging.messaging().fcmToken else { return }
         guard let profileImageURL = url?.absoluteString else { return }
         // Getb token from the messaging of Firebase
         //to save the username
         let dictionaryValues = [ "profileImageURL" : profileImageURL, "uid" : uid, "name":name, "fcmToken":fcmToken]
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
         
         
         
         }
         
         })
         }
         }
         
         
         /*

        ///////
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
            guard let name = user?.displayName else { return }
            guard let fcmToken = Messaging.messaging().fcmToken else { return }
            // Getb token from the messaging of Firebase
            //to save the username
            let dictionaryValues = [ "profileImageURL" : profileImageURL, "uid" : uid, "name":name, "fcmToken":fcmToken]
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
 */
   // }
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
        
        collectionView?.backgroundColor = .white
//        collectionView?.backgroundColor = UIColor.cellBGColor()
        // We need to registewrb the collectionview with a header
//        collectionView?.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerID")
        collectionView?.register(CNUserProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CNheaderID")
        // Register 2 cell for grid and list layout
        collectionView?.register(UserProfilePhotoCell.self, forCellWithReuseIdentifier: gridCellId)
        collectionView?.register(HomePostCell.self, forCellWithReuseIdentifier: listCellId)
        //Setup the gear icon
        setupLogoutButton()
//         navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "gear").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(updateLabel))
        
        fetchUser()
       
//        getMyFollowers()
//        self.getFollowing()
//        getFollowing()
//        getMyPosts()
    }
    
//    @objc fileprivate func updateLabel(){
//        print("Trying to update header label")
//        let headerView = collectionView?.supplementaryView(forElementKind: UICollectionElementKindSectionHeader, at: [0,0]) as? CNUserProfileHeader
//        headerView?.followingLabel.text = "22 \nposts"
//
//
//
//    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        fetchUser()
        getFollowing()
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
            self.getMyPosts(posts: self.posts.count)
            
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
//             self.getMyPosts()
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
//         getMyPosts()
//        let header = CNUserProfileHeader()
//        header.posts = posts.count
//        print("Post count is:", posts.count)
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
        let post = posts[indexPath.row]
        let layout = UICollectionViewFlowLayout()
        let editPostController = EditPhotoController(collectionViewLayout: layout)
        editPostController.post = post
        self.navigationController?.pushViewController(editPostController, animated: true)
    }
    
    
    //Setting up the header for the collectionview on the profile page
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        // here u have to return a UICollectionReusableView
//        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerID", for: indexPath) as! UserProfileHeader
        // we can use bang! because we registered the UserProfileHeader in viewDidLoad
         let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CNheaderID", for: indexPath) as! CNUserProfileHeader
        //
//        self.getFollowing()
//        header.followingLabel.text = "\(peopleThisUserFollowsCount)"
//        header.following = peopleThisUserFollowsCount
//        header.following = 25
        
        header.user = self.user //THIS LINE SET THE USER IN HEADERVIEWCONTROLLER
        // grid view change
         header.delegate = self
        //
        //IT IS WRONG TO TRY TO ADD SUBVIEWS TO HERE
        return header
    }
    func invalidateLayout(with context: UICollectionViewLayoutInvalidationContext) {
        
    }
    func invalidateSupplementaryElements(ofKind elementKind: String,
                                         at indexPaths: [IndexPath]) {
        
        
    }
    
    
    
    //Must specify the size of the header UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        //
        return CGSize(width: view.frame.width, height: 240)
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
//            self.navigationItem.title = self.user?.username
            self.navigationItem.title = self.user?.name
            
            
            // TO STOP FECTHING DICTIONARY TWICE
            self.collectionView?.reloadData()
            // now we fetch the posts
//            self.fetchOrderedPosts()
            //Pagination
            self.paginatePosts()
//            self.getMyPosts()
        }
        
        
    }
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}
