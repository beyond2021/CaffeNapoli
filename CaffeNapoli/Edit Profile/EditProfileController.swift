//
//  EditProfileController.swift
//  CaffeNapoli
//
//  Created by Kev1 on 3/21/18.
//  Copyright © 2018 Kev1. All rights reserved.
//

import UIKit
import Firebase
class EditProfileController: UIViewController,  UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let addPhotoButton : UIButton = {
        let button = UIButton(type: .system)
        //  button.backgroundColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = #imageLiteral(resourceName: "avatar2")
        button.imageView?.contentMode = .scaleAspectFill
        button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleAddPhoto), for: .touchUpInside)
        button.clipsToBounds = true
        
        return button
        
    }()
    
    @objc func handleAddPhoto(){
        //print(123)
        let imagePickerController = UIImagePickerController()
        //set a dlegate on imagePicker to get image picked
        imagePickerController.delegate = self
        // allow editing
        imagePickerController.allowsEditing = true
        // present picker
        present(imagePickerController, animated: true, completion: nil)
        
        
    }
    //To get which photo was picked
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // Toget the ewdited image
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            addPhotoButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            addPhotoButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        // Lets get the image
        //        print(originalImage?.size)
        //        print(editedImage?.size)
        // round the button
        addPhotoButton.layer.masksToBounds = true
        addPhotoButton.layer.cornerRadius = addPhotoButton.frame.width/2
        addPhotoButton.layer.borderColor = UIColor.black.cgColor
        addPhotoButton.layer.borderWidth = 3
        dismiss(animated: true, completion: nil)
    }
    
    
    
    //TextFields
    //TextFields
    let usernameTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "New Username"
        // textField.backgroundColor = UIColor.lightGray
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.borderStyle = .roundedRect
        // textfield listener
        textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        
        return textField
    }()
    //
    let  nameTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Full Name"
        // textField.backgroundColor = UIColor.lightGray
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.borderStyle = .roundedRect
        // textfield listener
        textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        
        return textField
    }()
    let emailTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        // textField.backgroundColor = UIColor.lightGray
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.borderStyle = .roundedRect
        // textfield listener
        textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        
        return textField
    }()
    
//    let passwordTextField : UITextField = {
//        let textField = UITextField()
//        textField.placeholder = "Password"
//        // textField.backgroundColor = UIColor.lightGray
//        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
//        textField.isSecureTextEntry = true
//        textField.font = UIFont.systemFont(ofSize: 14)
//        textField.borderStyle = .roundedRect
//        // textfield listener
//        textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
//        return textField
//    }()
    //
    @objc func handleTextInputChange(){
        // validate email
        let isFormValid = usernameTextField.text?.count ?? 0 > 0  && nameTextField.text?.count ?? 0 >  0  && emailTextField.text?.count ?? 0 >  0
        if isFormValid {
            // enable signup button
            loginButton.isEnabled = true
            // sign up button color change
//            loginButton.backgroundColor = UIColor.rgb(displayP3Red: 17, green: 154, blue: 237)
            loginButton.backgroundColor = UIColor.tabBarBlue()
            loginButton.setTitle("Update Profile", for: .normal)
        } else {
            // disable signup button
            loginButton.isEnabled = false
//            loginButton.backgroundColor = UIColor.rgb(displayP3Red: 149, green: 204, blue: 244)
            loginButton.setTitle("Please Fill All Fields", for: .normal)
            loginButton.backgroundColor = UIColor.cellBGColor()
        }
        
        
    }
    
    let loginButton : UIButton = {
        let button = UIButton(type: .system)
//        button.backgroundColor = UIColor.rgb(displayP3Red: 149, green: 204, blue: 244)
        button.backgroundColor = UIColor.cellBGColor()
        button.setTitle("Please Fill All Fields", for: .normal)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(updateProfile), for: .touchUpInside)
        // Disable the signup button by default
        button.isEnabled = false
        
        return button
    }()
    let cancelButton : UIButton = {
        let button = UIButton(type: .system)
        //        button.backgroundColor = UIColor.rgb(displayP3Red: 149, green: 204, blue: 244)
        button.backgroundColor = UIColor.tabBarBlue()
        button.setTitle("Cancel Update", for: .normal)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(dissMiss), for: .touchUpInside)
        // Disable the signup button by default
        button.isEnabled = true
        
        return button
        
    }()
    
    @objc fileprivate func dissMiss() {
        self.dismiss(animated: true) {
            guard let mainTabbarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
            mainTabbarController.setupViewControllers()
            mainTabbarController.selectedIndex = 4
            
        }
    }
    //MARK:- Log In User
    @objc func updateProfile(){
        // print(123)
        guard let email = emailTextField.text else { return }
        guard let username = usernameTextField.text else { return }
        guard let name = nameTextField.text else { return }
        updateWith(username: username, email: email, name:name)
//            self.dismiss(animated: true, completion: nil)
//        }
    }
    
    fileprivate func updateWith(username : String?, email: String?, name: String) {
        guard let image = addPhotoButton.image(for: .normal) else { return}
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
            //
            let user = Auth.auth().currentUser
            guard let uid = user?.uid else { return}
            let username = username
            let email = email
            guard let fcmToken = Messaging.messaging().fcmToken else { return }
            let dictionaryValues = ["profileImageURL" : profileImageURL, "username":username, "email":email, "name" : name, "fcmToken" : fcmToken ]
            let values = [uid : dictionaryValues ]
            //this appends new users  on server
            Database.database().reference().child("users").updateChildValues(values, withCompletionBlock: { (err, ref) in
                if let err = err {
                    print("Failed to save user info into db:", err)
                    return
                }
                // success
                print("Successfully saved user info into db")
                
//                self.dismiss(animated: true, completion: nil)
                self.dismiss(animated: true, completion: {
                    guard let mainTabbarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
                    mainTabbarController.setupViewControllers()
                    mainTabbarController.selectedIndex = 4
                })
            })
            
           //
        })
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.cellBGColor()
        
        view.addSubview(addPhotoButton)
        setupInputFields()
        fetchUser()
       
    }
    var user: User?
    var userID:  String?
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
            
//            print("username is:", self.user?.username ?? "No username")
//            if user.username == "" {
//                self.usernameTextField.placeholder = "Username"
//            } else {
//                self.usernameTextField.placeholder = user.username
//
//            }
//
//            let userNamePlaceholder = user.username ?? "Username"
//            let emailPlaceholder = user.email ?? "Email"
//
//            self.usernameTextField.placeholder = userNamePlaceholder
//            self.fullNameTextField.placeholder = user.name
//            self.emailTextField.placeholder = emailPlaceholder
            
        
           
        }
        
        
    }
    
    
    
    fileprivate func setupInputFields() {
        addPhotoButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 100, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 140, height: 140)
        addPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [usernameTextField, nameTextField, emailTextField, loginButton, cancelButton])
        stackView.axis = .vertical // It defaults to horizontal
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        // Add stackView into the view
        view.addSubview(stackView)
        stackView.anchor(top: addPhotoButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 230)
        
    }
    
}
extension EditProfileController {
    //Methods
    private func updateUsersProfile(with uid:String, displayName:String?, photoURL: URL?) {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = displayName
        changeRequest?.photoURL = photoURL
        
        changeRequest?.commitChanges { (error) in
            // ...
            if (error != nil) {
                print("Could not update user profile", error!)
            } else {
                print("Successfully updated User profile")
            }
        }
        
    }
    //Set a user's email address
    private func setUserEmailAddress(email : String) {
        Auth.auth().currentUser?.updateEmail(to: email) { (error) in
            if (error != nil) {
                print("Could not update email", error!)
            } else {
                print("Successfully updated email")
            }
            
            
        }
    }
    //Send a user a verification email
    private func sendVerificationEmail(){
        Auth.auth().currentUser?.sendEmailVerification { (error) in
            if (error != nil) {
                print("Could not send verification email", error!)
            } else {
                print("Successfully sent verification email")
            }
        }
    }
    //Set a user's password
    private func updatePassword(to password:String) {
        Auth.auth().currentUser?.updatePassword(to: password) { (error) in
            if (error != nil) {
                print("Could not update password", error!)
            } else {
                print("Successfully updated password")
            }
        }
    }
    //Send a password reset email
    private func sendPasswordResetEmail(to email:String){
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if (error != nil) {
                print("Failed to send password reset to email", error!)
            } else {
                print("Successfully sent password reset to email")
            }
        }
        
    }
    //Delete a user
    private func deleteAUser(){
        let user = Auth.auth().currentUser
        
        user?.delete { error in
            if let error = error {
                print("Could not delete user", error)
            } else {
                // Account deleted.
                print("Account deleted.")
                
            }
        }
    }
    //Re-authenticate a user | need to do this before deleting an account, setting a primary email address, and changing a password—
//    private func reAuthenticateUser(){
//        let user = Auth.auth().currentUser
//        let credential: AuthCredential
//
//        // Prompt the user to re-provide their sign-in credentials
//        credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
//        //
//        user?.reauthenticate(with: credential) { error in
//            if let error = error {
//                // An error happened.
//                print("Failed to reAuthenticate user", error)
//            } else {
//                // User re-authenticated.
//                print("User is re-authenticated")
//
//            }
//        }
//
//    }
    
}
