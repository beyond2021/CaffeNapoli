//
//  NewMainLoginController.swift
//  CaffeNapoli
//
//  Created by Kev1 on 3/1/18.
//  Copyright © 2018 Kev1. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn
import Crashlytics
import TwitterKit
import FirebaseAuthUI
import FirebaseGoogleAuthUI
import FirebaseFacebookAuthUI
import FirebaseTwitterAuthUI
import FirebasePhoneAuthUI


class NewMainLoginController: UIViewController,FUIAuthDelegate,GIDSignInUIDelegate{
    //
    //Google
    let GoogleCustomButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.facebookBlue()
        button.setTitle("Custom Google Login Here", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.textColor = .white
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleGoogleLogin), for: .touchUpInside)
        return button
    }()
    @objc fileprivate func handleGoogleLogin() {
        
        GIDSignIn.sharedInstance().signIn()
        //Dissmiss signin screen
        guard let mainTabbarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
        
        mainTabbarController.setupViewControllers()
        self.dismiss(animated: true, completion: nil)
        
    }
    ///////
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
//            self.showEmailAddress()
            
        }
        
    }
    //
    lazy var twitterLoginButton : TWTRLogInButton = {
        let button = TWTRLogInButton(logInCompletion: { (session, error) in
            if error != nil {
                print("Unable to Login with Twitter:", error ?? "")
                return
            }
        })
        print("Successfully Logged in with Twitter")
        //        button.setTitle("Crash", for:[])
        //        button.addTarget(self, action : #selector(handleCrashButtonTapped), for : .touchUpInside)
        return button
    }()
    
    
    // Credential
    var credential : AuthCredential? = nil
    
    let authUI = FUIAuth.defaultAuthUI()
    let providers: [FUIAuthProvider] = [
        FUIGoogleAuth(),
        FUIFacebookAuth(),
        FUITwitterAuth()
        
        ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        FirebaseApp.configure()
        view.backgroundColor = .white
        view.addSubview(fbCustomButton)
        
        view.addSubview(GoogleCustomButton)
        //        GIDSignIn.sharedInstance().signIn()
        //
        // Google Sign in
        GIDSignIn.sharedInstance().uiDelegate = self
        //
        view.addSubview(twitterLoginButton)
        setupInputFields()
    }
    
    fileprivate func setupInputFields() {
        
        
        //
        fbCustomButton.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 100, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 40)
        //
        
        GoogleCustomButton.anchor(top: fbCustomButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 40)
        twitterLoginButton.anchor(top: GoogleCustomButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 40)
    }
    
    
}
