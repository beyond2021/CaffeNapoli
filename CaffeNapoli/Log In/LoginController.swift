//
//  LoginController.swift
//  CaffeNapoli
//
//  Created by Kev1 on 10/21/17.
//  Copyright © 2017 Kev1. All rights reserved.
//

import UIKit
import  Firebase
import FBSDKCoreKit
import FBSDKLoginKit

class LoginController: UIViewController,FBSDKLoginButtonDelegate{
    
    
    // LogoContainerView
    let logoContainerView : UIView = {
        let view = UIView()
        //Add in the logo
        let logoImageView = UIImageView(image: #imageLiteral(resourceName: "CaffeNapoliLargeWhite"))
        logoImageView.contentMode = .scaleAspectFill
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        //logoImageView.backgroundColor = .red
        view.addSubview(logoImageView)
        logoImageView.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 200, height: 50)
        // to center it
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        view.backgroundColor = UIColor.rgb(displayP3Red: 0, green: 120, blue: 175)
        return view
        
    }()
    //MARK: Facebook
    let fbCustomButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.facebookBlue()
        button.setTitle("Custom Facebook Login Here", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.textColor = .white
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleFBLogin), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func handleFBLogin() {
      //call login on fb manager
        FBSDKLoginManager().logIn(withReadPermissions: ["email", "public_profile"], from: self) { (result, err) in
            //
            if let error = err{
                print(error.localizedDescription)
                return
            }
//            print(result?.token.tokenString ?? "")
             self.showEmailAddress()
            
        }
        
    }
    
    // Facebook Button
    lazy var facebookLoginButton : FBSDKLoginButton = {
        let button = FBSDKLoginButton()
        button.readPermissions = ["email", "public_profile"]
        button.delegate = self
        return button
    }()
    // Custom Button
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if let error = error {
            print("Custom FB login failed:", error.localizedDescription)
            return
        }
        // ...
        print("Successfully logged in to facebook")
         self.showEmailAddress()

}
    private func showEmailAddress(){
        // log in to Firebase with this Facebook user.
         // This how we get the access token
        let accessToken = FBSDKAccessToken.current()
        guard let accessTokenString = accessToken?.tokenString else { return }
        let credentials = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
        Auth.auth().signIn(with: credentials) { (user, error) in
            if error != nil {
                print("Something went wrong with our FB user:", error ?? "")
                return
            }
            print("Successfully logged in  with our FB user:", user ?? "")
            
  
            
            // adding a reference to our firebase database
            let ref = Database.database().reference(fromURL: "https://caffenapoli-8774f.firebaseio.com/")
            
            // guard for user id
            guard let uid = user?.uid else {
                return
            }
            
            // create a child reference - uid will let us wrap each users data in a unique user id for later reference
            let usersReference = ref.child("users").child(uid)
            
            //
            FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start { (connection, result, err) in
                //
                
                if err != nil {
                    print("Failed to start graph request:", err ?? "")
                    return
                    
                }
                print(result ?? "")
                
                guard let data = result as? [String:Any]  else { return }
                
                guard let name = data["name"] as? String else { return }
                guard let email = data["email"]as? String else { return }
                guard let id = data["id"]as? String else { return }
//                guard let profilePicURL = data["profile_pic"] else { return }
                print( name)
                print( email)
                print( id)
//                print(profilePicURL)
                
                let values: [String:AnyObject] = result as! [String : AnyObject]
                usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                    // if there's an error in saving to our firebase database
                    if err != nil {
                        print(err)
                        return
                    }
                    // no error, so it means we've saved the user into our firebase database successfully
                    print("Save the user successfully into Firebase database")
                })
                
                guard let mainTabbarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
                
                mainTabbarController.setupViewControllers()
                self.dismiss(animated: true, completion: nil)
                
            }
            
        }

    }
    
    
    
    //Update a user's profile
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
    private func reAuthenticateUser(){
        let user = Auth.auth().currentUser
        let credential: AuthCredential
        
        // Prompt the user to re-provide their sign-in credentials
        credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        //
        user?.reauthenticate(with: credential) { error in
            if let error = error {
                // An error happened.
                print("Failed to reAuthenticate user", error)
            } else {
                // User re-authenticated.
                print("User is re-authenticated")
                
            }
        }

    }
    
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    //TextFields
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
    //
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
        let isFormValid = emailTextField.text?.count ?? 0 > 0  && passwordTextField.text?.count ?? 0 > 0//
        if isFormValid {
            // enable signup button
            loginButton.isEnabled = true
            // sign up button color change
            loginButton.backgroundColor = UIColor.rgb(displayP3Red: 17, green: 154, blue: 237)
            
        } else {
            // disable signup button
            loginButton.isEnabled = false
            loginButton.backgroundColor = UIColor.rgb(displayP3Red: 149, green: 204, blue: 244)
        }
        
        
    }
    
    let loginButton : UIButton = {
        let button = UIButton(type: .system)
        //        button.translatesAutoresizingMaskIntoConstraints = false
        //button.backgroundColor = .blue
        //        button.backgroundColor = UIColor(displayP3Red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
        button.backgroundColor = UIColor.rgb(displayP3Red: 149, green: 204, blue: 244)
        button.setTitle("Login", for: .normal)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        // Action
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        
        // Disable the signup button by default
        button.isEnabled = false
        return button
    }()
    
     //MARK:- Log In User
    @objc func handleLogin(){
       // print(123)
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            // handle Error
            if let error = error {
                print("Failed to sign in with email", error)
                return
            }
            // successful
            print("Successfully logged back in with user", user?.uid ?? "")
            //To show the main controller and reset the UI
            guard let mainTabbarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
            
            mainTabbarController.setupViewControllers()
            self.dismiss(animated: true, completion: nil)
            
        }
        
    }
    
    //
    let dontHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Dont have an account with Caffe Napoli?  ", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        // add the sign up
        attributedTitle.append(NSMutableAttributedString(string: "Sign Up", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.rgb(displayP3Red: 17, green: 154, blue: 237)])
        )
//        button.setTitle("Dont have an account with Caffe Napoli? Sign up.", for: .normal)
        //transition to signup controller. push sign up on to navigationaln stack
        button.addTarget(self, action: #selector(handelShowSignUp), for: .touchUpInside)
        return button
    }()
    
    @objc func handelShowSignUp(){
        //Push the registration Controller
        let signUpController = SignUpController()
       // print(navigationController)
        navigationController?.pushViewController(signUpController, animated: true) // does not show because navigation controller is nil
        
    }
    //Change the font of the stausbar
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(logoContainerView)
        view.addSubview(facebookLoginButton)
        view.addSubview(fbCustomButton)
        
        
        
        logoContainerView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 150)
        //Remove the navigation bar
        navigationController?.isNavigationBarHidden = true
        
        view.backgroundColor = .white
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        setupInputFields()
    }
    
    fileprivate func setupInputFields() {
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton])
        stackView.axis = .vertical // It defaults to horizontal
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        // Add stackView into the view
        view.addSubview(stackView)
        stackView.anchor(top: logoContainerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 40, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 140)
        facebookLoginButton.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width - 80, height: 50)
        facebookLoginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        facebookLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        //
        fbCustomButton.anchor(top: facebookLoginButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 40)
        
    }
}
