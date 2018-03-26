//
//  EditProfileController.swift
//  CaffeNapoli
//
//  Created by Kev1 on 3/21/18.
//  Copyright © 2018 Kev1. All rights reserved.
//

import UIKit
import Firebase
class EditProfileController: UIViewController{
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
    let fullNameTextField : UITextField = {
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
    
    let passwordTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        // textField.backgroundColor = UIColor.lightGray
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.isSecureTextEntry = true
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.borderStyle = .roundedRect
        // textfield listener
        textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return textField
    }()
    //
    @objc func handleTextInputChange(){
        // validate email
//        let isFormValid = usernameTextField.text?.count ?? 0 > 0  && passwordTextField.text?.count ?? 0 > 0//
//        if isFormValid {
//            // enable signup button
//            loginButton.isEnabled = true
//            // sign up button color change
//            loginButton.backgroundColor = UIColor.rgb(displayP3Red: 17, green: 154, blue: 237)
//
//        } else {
//            // disable signup button
//            loginButton.isEnabled = false
//            loginButton.backgroundColor = UIColor.rgb(displayP3Red: 149, green: 204, blue: 244)
//        }
        
        
    }
    
    let loginButton : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.rgb(displayP3Red: 149, green: 204, blue: 244)
        button.setTitle("Update Profile", for: .normal)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(updateProfile), for: .touchUpInside)
        // Disable the signup button by default
        button.isEnabled = true
        
        return button
    }()
    
    //MARK:- Log In User
    @objc func updateProfile(){
        // print(123)
        guard let email = usernameTextField.text else { return }
        guard let password = passwordTextField.text else { return }
//        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
//            // handle Error
//            if let error = error {
//                print("Failed to sign in with email", error)
//                return
//            }
//            // successful
//            print("Successfully logged back in with user", user?.uid ?? "")
//            //To show the main controller and reset the UI
//            guard let mainTabbarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
//            mainTabbarController.setupViewControllers()
            self.dismiss(animated: true, completion: nil)
//        }
    }
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.cellBGColor()
        setupInputFields()
    }
    
    fileprivate func setupInputFields() {
        let stackView = UIStackView(arrangedSubviews: [usernameTextField, fullNameTextField, emailTextField, passwordTextField, loginButton])
        stackView.axis = .vertical // It defaults to horizontal
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        // Add stackView into the view
        view.addSubview(stackView)
        stackView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 140, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 230)
        
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
