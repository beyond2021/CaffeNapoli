//
//  LoginController.swift
//  CaffeNapoli
//
//  Created by Kev1 on 10/21/17.
//  Copyright © 2017 Kev1. All rights reserved.
//

import UIKit
import  Firebase

class LoginController: UIViewController {
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
        
        
    }
}
