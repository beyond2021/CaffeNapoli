//
//  LoginController.swift
//  KevGoogleAuth
//
//  Created by Kev1 on 3/14/18.
//  Copyright © 2018 Kev1. All rights reserved.
//  https://kevauth-d8b56.firebaseapp.com/__/auth/handler //twitter callback


import UIKit
import Firebase
import FirebaseAuthUI
import FirebasePhoneAuthUI
import FirebaseGoogleAuthUI
import FirebaseFacebookAuthUI
import FirebaseTwitterAuthUI
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn
import TwitterCore
import TwitterKit

class LoginAuthController: UIViewController, FUIAuthDelegate, FBSDKLoginButtonDelegate, GIDSignInUIDelegate {
    
    
    //Facebook
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        loginButton.readPermissions = ["email", "public_profile"]
        loginButton.delegate = self
        if let error = error {
            print("Custom FB login failed:", error.localizedDescription)
            return
        }
        // ...
        print("Successfully logged in to facebook")
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        //
    }
    //UI
    
    let nameLabel : UILabel = {
      let label = UILabel()
        label.textColor = UIColor.cellBGColor()
        label.font = UIFont.boldSystemFont(ofSize: 40)
        label.text = "FOODIE"
        label.textAlignment = .center
//        label.isUserInteractionEnabled = true
//        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(setupProviderButtons)))
        return label
    }()
    
    
    fileprivate(set) var auth:Auth?
    fileprivate(set) var authUI: FUIAuth? //only set internally but get externally
    fileprivate(set) var authStateListenerHandle: AuthStateDidChangeListenerHandle?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        title = "FOODIE"
        view.backgroundColor = UIColor.tabBarBlue()
        view.addSubview(nameLabel)
        setupViews()
        //Google signin
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
//        setupProviderButtons()
        self.auth = Auth.auth()
        self.authUI = FUIAuth.defaultAuthUI()
        self.authUI?.delegate = self
        let providers: [FUIAuthProvider] = [
            FUIGoogleAuth(),
            FUIFacebookAuth(),
            FUIPhoneAuth(authUI:FUIAuth.defaultAuthUI()!),
            ]
        self.authUI?.providers = providers
        self.authStateListenerHandle = self.auth?.addStateDidChangeListener { (auth, user) in
            guard user != nil else {
                self.loginAction(sender: self)
                return
            }
        }
    }
    
//    @objc func setupProviderButtons() {
//        self.auth = Auth.auth()
//        self.authUI = FUIAuth.defaultAuthUI()
//        self.authUI?.delegate = self
//        let providers: [FUIAuthProvider] = [
//            FUIGoogleAuth(),
//            FUIFacebookAuth(),
//            FUIPhoneAuth(authUI:FUIAuth.defaultAuthUI()!),
//            ]
//        self.authUI?.providers = providers
//        self.authStateListenerHandle = self.auth?.addStateDidChangeListener { (auth, user) in
//            guard user != nil else {
//                self.loginAction(sender: self)
//                return
//            }
//        }
//
//    }
    
    
    private func setupViews() {
        nameLabel.anchor(top: nil, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 60)
        nameLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
///MARK: Login Extensions
extension LoginAuthController{
    @IBAction func loginAction(sender: AnyObject) {
        // Present the default login view controller provided by authUI
        let authViewController = authUI?.authViewController();
        authViewController?.topViewController?.view.backgroundColor = UIColor.tabBarBlue()
        self.present(authViewController!, animated: true, completion: nil)
    }
   
    
    // Implement the required protocol method for FIRAuthUIDelegate
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        guard let user = user else { return }
        let database = Database.database().reference()
        database.child("users").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            print("snapshot is:",snapshot)
            if snapshot.hasChild( Auth.auth().currentUser!.uid)
            {
                // user exist
                print("Dismissing from a logged in user:", user.uid)
                
                self.dismiss(animated: true, completion: nil)
            } else {
                // create user
                print("Will sign up user with uid:", user.uid)
//                self.handleSignUp(user: user)
            }
        })
        guard let authError = error else { return }
        let errorCode = UInt((authError as NSError).code)
        switch errorCode {
        case FUIAuthErrorCode.userCancelledSignIn.rawValue:
            print("User cancelled sign-in");
            break
        default:
            let detailedError = (authError as NSError).userInfo[NSUnderlyingErrorKey] ?? authError
            print("Login error: \((detailedError as! NSError).localizedDescription)");
        }
    }
    
    func handleSignUp(user: AuthDataResult?) {
        let user = user?.user
        let uid = user?.uid
        //
        //Lets upload the image instead
        let image = #imageLiteral(resourceName: "avatar1")
//        let image = user?.photoURL
        // turn the image into upload data
        guard let uploadData = image.jpegData(compressionQuality: 0.3) else { return }
        // Append New image
        let filename = NSUUID().uuidString
//        let username = user.displayName
         let username = user?.displayName
        let email = user?.email
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
            //to save the username
            guard let fcmToken = Messaging.messaging().fcmToken else { return }
            
            //to save the username
            let dictionaryValues = ["username": username, "profileImageURL" : profileImageURL, "fcmToken": fcmToken, "email":email]
            let values = [uid!:dictionaryValues]
            //this appends new users  on server
            Database.database().reference().child("users").updateChildValues(values, withCompletionBlock: { (err, ref) in
                if let err = err {
                    print("Failed to save user info into db:", err)
                    return
                }
                // success
                print("Successfully saved user info into db")
                guard let mainTabbarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
                mainTabbarController.setupViewControllers()
                self.dismiss(animated: true, completion: nil)
            })
            //
        })
    }
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        if let error = error {
            print("There was an error signing in with AuthData", error.localizedDescription)
            return
        }
        print("successfully signed in with data",authDataResult ?? "")
        guard let user = authDataResult?.user else { return }
        let database = Database.database().reference()
        database.child("users").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
//            print("snapshot is:",snapshot)
            if snapshot.hasChild( Auth.auth().currentUser!.uid)
            {
                // user exist
                print("Dismissing from a logged in user:", user.uid)
                print(user.description)
                print(user.email ?? "No email present")
                print(user.displayName ?? "No name present")
                print(user.photoURL)
                guard let mainTabbarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
                mainTabbarController.setupViewControllers()
                self.dismiss(animated: true, completion: nil)
            } else {
                // create user
                print("Will sign up user with uid:", user.uid)
                self.handleSignUp(user: authDataResult)
            }
        })
    }
    
    
    
}
///MARK: Login Extensions
/*
extension LoginAuthController{
    @IBAction func loginAction(sender: AnyObject) {
        // Present the default login view controller provided by authUI
        let authViewController = authUI?.authViewController();
//        authViewController?.visibleViewController?.view.backgroundColor = UIColor.tabBarBlue()
        self.present(authViewController!, animated: true, completion: nil)
    }
    
    // Implement the required protocol method for FIRAuthUIDelegate
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        guard let user = user else { return }
        let database = Database.database().reference()
        database.child("users").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            print("snapshot is:",snapshot)
            if snapshot.hasChild( Auth.auth().currentUser!.uid)
            {
                // user exist
                print("Dismissing from a logged in user:", user.uid)
                self.dismiss(animated: true, completion: nil)
            } else {
                // create user
                print("Will sign up user with uid:", user.uid)
                self.handleSignUp(user: user)
            }
        })
        guard let authError = error else { return }
        let errorCode = UInt((authError as NSError).code)
        switch errorCode {
        case FUIAuthErrorCode.userCancelledSignIn.rawValue:
            print("User cancelled sign-in");
            break
        default:
            let detailedError = (authError as NSError).userInfo[NSUnderlyingErrorKey] ?? authError
            print("Login error: \((detailedError as! NSError).localizedDescription)");
        }
    }
    
    func handleSignUp(user: User) {
        let uid = user.uid
        //
        //Lets upload the image instead
        let image = #imageLiteral(resourceName: "keevAv")
        // turn the image into upload data
        guard let uploadData = UIImageJPEGRepresentation(image, 0.3) else { return }
        // Append New image
        let filename = NSUUID().uuidString
        let username = user.username
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
            //to save the username
            guard let fcmToken = Messaging.messaging().fcmToken else { return }
            //to save the username
            let dictionaryValues = ["username": username, "profileImageURL" : profileImageURL, "fcmToken": fcmToken]
//            let dictionaryValues = ["username": username, "profileImageURL" : profileImageURL]
            let values = [uid : dictionaryValues ]
            //this appends new users  on server
            Database.database().reference().child("users").updateChildValues(values, withCompletionBlock: { (err, ref) in
                if let err = err {
                    print("Failed to save user info into db:", err)
                    return
                }
                // success
                print("Successfully saved user info into db")
                self.dismiss(animated: true, completion: nil)
            })
            //
        })
    }
        func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
            if let error = error {
                print("There was an error signing in with AuthData", error.localizedDescription)
                return
            }
            guard let mainTabbarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
            mainTabbarController.setupViewControllers()
            self.dismiss(animated: true, completion: nil)
        }
    
}
 */


