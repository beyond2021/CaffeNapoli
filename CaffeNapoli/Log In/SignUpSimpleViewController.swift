//
//  LogInSimpleViewController.swift
//  CaffeNapoli
//
//  Created by KEEVIN MITCHELL on 3/20/19.
//  Copyright © 2019 Kev1. All rights reserved.
//

import UIKit
import Firebase

class SignUpSimpleController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let plusPhotoButton : UIButton = {
        let button = UIButton(type: .system)
        let image = #imageLiteral(resourceName: "plus_photo-1")
        button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleAddPhoto), for: .touchUpInside)
        return button
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        // textfield listener
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    let usernameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Username"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        // textfield listener
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        
        return tf
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        // textfield listener
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        
        return tf
    }()
    @objc func handleTextInputChange(){
        // validate email
        let isFormValid = emailTextField.text?.count ?? 0 > 0 && usernameTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 0//
        if isFormValid {
            // enable signup button
            signupButton.isEnabled = true
            signupButton.backgroundColor = .mainBlue()
        } else {
            // disable signup button
            signupButton.isEnabled = false
            signupButton.backgroundColor = UIColor.rgb(displayP3Red: 149, green: 204, blue: 244)
        }
    }
    
    let signupButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(plusPhotoButton)
    
        if #available(iOS 11.0, *) {
            plusPhotoButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 140, height: 140)
        } else {
            plusPhotoButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 140, height: 140)
        }
        plusPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        setupInputFields()
        
       
    }
    

    fileprivate func setupInputFields() {

        let stackView = UIStackView(arrangedSubviews: [emailTextField, usernameTextField, passwordTextField, signupButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        stackView.anchor(top: plusPhotoButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width:0, height: 200)
    }
    
    //MARK:- Sign up User
    
    @objc func handleSignUp() {
        
        guard let email = emailTextField.text, email.count > 0 else { return }
        guard let username = usernameTextField.text, username.count > 0 else { return }
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
            guard let image = self.plusPhotoButton.imageView?.image else {return}
            // turn the image into upload data
            guard let uploadData = image.jpegData(compressionQuality: 0.3) else { return }
            // Append New image
            let filename = NSUUID().uuidString
            
            let storageRef = Storage.storage().reference().child("profile_Images").child(filename)
            
            storageRef.putData(uploadData, metadata: nil) { (metadata, err) in
                
                if let err = err {
                    print(err)
                }
                //             guard   let profileImageURL = metadata?.downloadURL()?.absoluteString else { return }
                
                storageRef.downloadURL(completion: { (url, error) in
                    if error != nil {
                        print("Failed to download url:", error!)
                        return
                    } else {
                        //Do something with url
                        // self.saveToDatabaseWithImageUrl(imageUrl: (url?.absoluteString)!)
                        guard let uid = user?.uid else { return}
                        guard let fcmToken = Messaging.messaging().fcmToken else { return }
                        guard let profileImageURL = url?.absoluteString else {return}
                        let dictionaryValues = ["username": username, "profileImageURL" : profileImageURL, "fcmToken": fcmToken]
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
                    }
                })
                
            }
          
            
        }
        
    }
    
    @objc func handleAddPhoto(){
        //print(123)
        let imagePickerController = UIImagePickerController()
        //set a dlegate on imagePicker to get image picked
//        imagePickerController.delegate = self
//        // allow editing
//        imagePickerController.allowsEditing = true
        // present picker
        present(imagePickerController, animated: true, completion: nil)
        
        
    }
    //To get which photo was picked
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        // Toget the ewdited image
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            plusPhotoButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            plusPhotoButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        // Lets get the image
        //        print(originalImage?.size)
        //        print(editedImage?.size)
        // round the button
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.layer.cornerRadius = plusPhotoButton.frame.width/2
        plusPhotoButton.layer.borderColor = UIColor.black.cgColor
        plusPhotoButton.layer.borderWidth = 3
        dismiss(animated: true, completion: nil)
    }
    
    // Helper function inserted by Swift 4.2 migrator.
    fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
        return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
    }

    

}
