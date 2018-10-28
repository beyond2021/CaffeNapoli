//
//  SharePhotoController.swift
//  CaffeNapoli
//
//  Created by Kev1 on 10/29/17.
//  Copyright © 2017 Kev1. All rights reserved.
//

import UIKit
import  Firebase

class SharePhotoController: UIViewController {
    static let updateFeedNotificationName = NSNotification.Name("UpdateFeed")
    
    // Something to hold selected image from previous controller
    var selectedImage : UIImage?{
        didSet{
          //  print(selectedImage)
            self.imageView.image = selectedImage
        }
    } // optinal because its nil at the very beginning
   
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.rgb(displayP3Red: 240, green: 240, blue: 240)
        //Create then share button on top right
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(handleShare))
        // set up views
        setupImageAndTextViews()
        
        setupAnimator()
        
    }
    
     let shapeLayer = CAShapeLayer()
    fileprivate func setupAnimator() {
        //tell it what shape to draw
        let center = view.center
        
        //Create my track layer
        let trackLayer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: center, radius: 100, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true) // 2 pi = all the way around
        trackLayer.path = circularPath.cgPath
        //
        trackLayer.strokeColor = UIColor.lightGray.cgColor
        trackLayer.lineWidth = 10
        //round the tip
        //        trackLayer.lineCap = kCALineCapRound
        trackLayer.fillColor = UIColor.clear.cgColor
        view.layer.addSublayer(trackLayer)
        
        //
        //        let circularPath = UIBezierPath(arcCenter: center, radius: 100, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true) // 2 pi = all the way around
        shapeLayer.path = circularPath.cgPath
        //
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.lineWidth = 10
        //round the tip
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        // remove inside color
        shapeLayer.fillColor = UIColor.clear.cgColor
        
        shapeLayer.strokeEnd = 0
        //add to viewcontrollers view
        view.layer.addSublayer(shapeLayer)
        
        
    }
    //Image View
    let imageView : UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .red
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
        
    }()
    // Text View
    let textView : UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 14)
        return tv
        
    }()
    // Set up image and text view in here
    fileprivate func setupImageAndTextViews(){
        let containerView = UIView()
        containerView.backgroundColor = .white
        view.addSubview(containerView)
//        containerView.anchor(top: topLayoutGuide.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 100)
        if #available(iOS 11.0, *) {
            containerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 100)
        } else {
            // Fallback on earlier versions
        }
        
        containerView.addSubview(imageView)
        imageView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 0, width: 84, height: 0)
        containerView.addSubview(textView)
        textView.anchor(top: containerView.topAnchor, left: imageView.rightAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
    }
    
    
    // hide the status bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
    //MARK:- POSTS
    // Handle Share
    @objc func handleShare(){
//       print("Handling Shares")
        //Make sure that the caption has text in it
       
        guard let caption = textView.text, caption.count > 0 else { return }
        
        
        //lets get the image outside nof the imageview
        guard let image = imageView.image else { return }
        //or
//        guard let image = selectedImage else { return }
        
        
        //1: we want to first upload the image to fireBase storage and record its URL location.
        
        let filename = NSUUID().uuidString // Filename is random string we generate
        //2: change the image into data
        guard let uploadData = image.jpegData(compressionQuality: 0.5) else { return }
        
        //disable the share button
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        /*
        
        Storage.storage().reference().child("posts").child(filename).putData(uploadData, metadata: nil) { (metaData, error) in
            //Check 4 error
//            if err != nil {
//                print("Error uploading photo", err)
//                return
//            }
            
            //or
            if let err = error {
                //reenable the share button if there is an error
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                
                
                print("Error uploading photo", err)
                return
            }
            // success and append on the file url (metaData?.downloadURL()?.absoluteString) from the returned metadata
//            guard let imageURL = metaData?.downloadURL()?.absoluteString else { return }
//            StorageReference.downloadURLWithCompletion()
            metaData?.storageReference?.downloadURL(completion: { (url, err) in
                if let error = err {
                    print("Could not  uploaded photo", error.localizedDescription)
                    return
                }
//                print("Successfully  uploaded photo", url)



                guard let urlString = url?.absoluteString else { return }
                 self.saveToDatabaseWithImageUrl(imageUrl: urlString)

            })
            
//            print("Successfully  uploaded photo", imageURL)
//             Save to database
//            self.saveToDatabaseWithImageUrl(imageUrl: imageURL)
        }
 */
        
        
        let storageRef = Storage.storage().reference().child("posts").child(filename)
            
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
                        self.saveToDatabaseWithImageUrl(imageUrl: (url?.absoluteString)!)
                    }
                    
                })
            }
            
        
        
    }
    fileprivate func saveToDatabaseWithImageUrl(imageUrl : String){
        animateUpload()
        
        //save to the posts node in uid -> the user id that is logged in. we return if we do not get the user id
        //Get the caption text
        guard let postImage = selectedImage else { return }
        guard let caption = textView.text else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        // userPostRef = returned firebase database reference
        let userPostRef = Database.database().reference().child("posts").child(uid)
        // childByAutoId generate a new child loction with a unique key
        //lists reference
        let listReference = userPostRef.childByAutoId() //THIS IS USED FOR ANY TYPE OF LISTS - (Here list of usersb posts)
        //get the values dictionary to be saved image size info needed for timeline download
        let values = ["imageUrl":imageUrl, "caption" : caption, "imageWidth": postImage.size.width, "imageHeight": postImage.size.height, "creationDate": Date().timeIntervalSince1970] as [String:Any]
        
        listReference.updateChildValues(values) { (error, reference) in
            //
            if let err = error {
                //reenable the share button if there is an error
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print("There was an error saving to database", err)
                return
            }
            print("successfully saved post to database")
            //Dismiss the share controller
            self.dismiss(animated: true, completion: nil)
            //POST A NOTIFICATION TO THE ENTIRE SYSTEM HERE!
            
            NotificationCenter.default.post(name: SharePhotoController.updateFeedNotificationName, object: nil)
        }
        
    }
    //MARK:- Animation
        func animateUpload() {
        print("Attempting to animate stroke")
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 1
        basicAnimation.duration = 1
        //stay the animation
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        shapeLayer.add(basicAnimation, forKey: "urSoBasic")
    }
}
