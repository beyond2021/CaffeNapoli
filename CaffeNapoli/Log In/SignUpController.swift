//
//  ViewController.swift
//  CaffeNapoli
//
//  Created by Kev1 on 9/29/17.
//  Copyright © 2017 Kev1. All rights reserved.
//

import UIKit
import Firebase

class SignUpController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // plus Photo Button
    let addPhotoButton : UIButton = {
        let button = UIButton(type: .system)
        //  button.backgroundColor = .red
 //       button.translatesAutoresizingMaskIntoConstraints = false
        let image = #imageLiteral(resourceName: "if_add_96_2074812")
        button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleAddPhoto), for: .touchUpInside)
        
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
    @objc func handleTextInputChange(){
        // validate email
        let isFormValid = emailTextField.text?.count ?? 0 > 0 && usersnameTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 0//
        if isFormValid {
            // enable signup button
            signupButton.isEnabled = true
         // sign up button color change
//            signupButton.backgroundColor = UIColor.rgb(displayP3Red: 17, green: 154, blue: 237)
            
            signupButton.backgroundColor = .mainBlue()
            
        } else {
            // disable signup button
            signupButton.isEnabled = false
             signupButton.backgroundColor = UIColor.rgb(displayP3Red: 149, green: 204, blue: 244)
        }
       
        
    }
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
    let usersnameTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Username"
        // textField.backgroundColor = UIColor.lightGray
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.borderStyle = .roundedRect
        // textfield listener
        textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return textField
    }()
    // SignupButton
    let signupButton : UIButton = {
        let button = UIButton(type: .system)
//        button.translatesAutoresizingMaskIntoConstraints = false
        //button.backgroundColor = .blue
//        button.backgroundColor = UIColor(displayP3Red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
        button.backgroundColor = UIColor.rgb(displayP3Red: 149, green: 204, blue: 244)
        button.setTitle("Sign Up", for: .normal)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        // Action
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
       
        // Disable the signup button by default
        button.isEnabled = false
        return button
    }()
    //
    
    
    //MARK:- Sign up User
    
    @objc func handleSignUp() {
        //print(123)
        // Create a new user
//        let email = "dummy0@gmail.com"
//        let password = "123123"
        
        guard let email = emailTextField.text, email.count > 0 else { return }
        guard let username = usersnameTextField.text, username.count > 0 else { return }
        guard let password = passwordTextField.text, password.count > 0 else { return }
        
        
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            // user and error is passed bak to  us after the user is created
            // 1: Check if there was an error
            if let err = error {
                print("Failed to create user:", err) // print the error and get out
                return
            }
            // If we are successful
            print("Successful created user:", user?.uid ?? "")
            //
             //Lets upload the image instead
            guard let image = self.addPhotoButton.imageView?.image else {return}
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
                
                
                guard let uid = user?.uid else { return}
                
                //to save the username
                let dictionaryValues = ["username": username, "profileImageURL" : profileImageURL]
                let values = [uid : dictionaryValues ]
                
                //this appends new users  on server
                Database.database().reference().child("users").updateChildValues(values, withCompletionBlock: { (err, ref) in
                    //
                    //
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
                //
            })
            
            
            
 
            
            
            //this replaces old users witgh new users on server
//            Database.database().reference().child("users").setValue(values, withCompletionBlock: { (err, ref) in
//                //
//                if let err = err {
//                    print("Failed to save user info into db:", err)
//                    return
//                }
//                // success
//                print("Successfully saved user info into db")
//
//            })
            //
           
            
        }
        
    }
    //
    //
    let alreadyHasAccountButton : UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Already have an account with Caffe Napoli?  ", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        // add the sign up
        attributedTitle.append(NSMutableAttributedString(string: "Sign In", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.rgb(displayP3Red: 17, green: 154, blue: 237)])
        )
        //        button.setTitle("Dont have an account with Caffe Napoli? Sign up.", for: .normal)
        //transition to signup controller. push sign up on to navigationaln stack
        button.addTarget(self, action: #selector(handelAlreadyHaveAccount), for: .touchUpInside)
        return button
    }()
    @objc func handelAlreadyHaveAccount() {
//print(123)
        //We need to pop the controller off the stack
        navigationController?.popViewController(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // add already have account button
        view.addSubview(alreadyHasAccountButton)
        alreadyHasAccountButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
        
        
        
        view.backgroundColor = .white
        view.addSubview(addPhotoButton)
     //   view.addSubview(emailTextField)
        setupViews()
    }
    
   fileprivate func setupViews(){
        // addv Button - AutoLayout
        addPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        addPhotoButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
//        addPhotoButton.heightAnchor.constraint(equalToConstant: 140).isActive = true
//        addPhotoButton.widthAnchor.constraint(equalToConstant: 140).isActive = true
        addPhotoButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 40, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 140, height: 140)
    
    
    
        setupInputFields()
        
        // Email Textfield Position
//        emailTextField.topAnchor.constraint(equalTo: addPhotoButton.bottomAnchor, constant: 20).isActive = true
//        emailTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40).isActive = true
//        emailTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
//        emailTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40).isActive = true
        //  NSLayoutConstraint.activate[])
    }
    
    // Input Fields In StackView
   fileprivate func setupInputFields(){
//    let greenView = UIView()
//    greenView.backgroundColor = .green
    
//    let redView = UIView()
//    redView.backgroundColor = .red
    let stackView = UIStackView(arrangedSubviews: [emailTextField,usersnameTextField,passwordTextField,signupButton])
//    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.distribution = .fillEqually
    stackView.axis = .vertical
    stackView.spacing = 10
    view.addSubview(stackView)
    
    /*
    NSLayoutConstraint.activate([
//        stackView.topAnchor.constraint(equalTo: addPhotoButton.bottomAnchor, constant: 20),
//                                 stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40),stackView.heightAnchor.constraint(equalToConstant: 200),stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40)])
//
    //Height
    stackView.heightAnchor.constraint(equalToConstant: 200)])
 */
    // With Extension
  stackView.anchor(top: addPhotoButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width : 0, height: 200)
    
    
    }


}


