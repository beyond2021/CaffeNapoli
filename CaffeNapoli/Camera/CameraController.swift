//
//  CameraController.swift
//  CaffeNapoli
//
//  Created by Kev1 on 11/19/17.
//  Copyright © 2017 Kev1. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class CameraController: UIViewController, AVCapturePhotoCaptureDelegate, UIViewControllerTransitioningDelegate {
    
    let dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "dismissCamera").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(dismissCamera), for: .touchUpInside)
        
        return button
    }()
    //
    let capturePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "capture_photo").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleCapturePhoto), for: .touchUpInside)
        
        return button
    }()
    
    //
    let flashButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "flashOff").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(toggleCamera), for: .touchDown)
        return button
    }()
    var flashIsOn = false
    @objc private func toggleCamera() {
        
        guard let avDevice = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        
        // check if the device has torch
        if avDevice.hasTorch {
            // lock your device for configuration
            do {
                _ = try avDevice.lockForConfiguration()
            } catch {
                print("aaaa")
            }
            
            // check if your torchMode is on or off. If on turns it off otherwise turns it on
            if avDevice.isTorchActive {
                avDevice.torchMode = AVCaptureDevice.TorchMode.off
                //turn flash off
                flashButton.setImage(#imageLiteral(resourceName: "flashOff").withRenderingMode(.alwaysOriginal), for: .normal)            } else {
                // sets the torch intensity to 100%
                do {
                    _ = try avDevice.setTorchModeOn(level: 1.0)
                  //turn flash on
                    flashButton.setImage(#imageLiteral(resourceName: "flashOn").withRenderingMode(.alwaysOriginal), for: .normal)                 } catch {
                    print("bbb")
                }
                //    avDevice.setTorchModeOnWithLevel(1.0, error: nil)
            }
            // unlock your device
            avDevice.unlockForConfiguration()
        }
        
    }
    
    
    
    @objc func dismissCamera() {
        print("Dismissing camera....")
        dismiss(animated: true, completion: nil)
        
    }
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Custome transitioning
        //1:  protocol UIViewControllerTransitioningDelegate
        
        let swipeToDismiss = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeftToDismiss))
        swipeToDismiss.direction = .left
        view.addGestureRecognizer(swipeToDismiss)
        
        transitioningDelegate = self//trasition
        setupCaptureSession()
        setupHUD()
        
    }
    
    @objc func swipeLeftToDismiss() {
        dismissCamera()
        
    }
    
    
    //Custom Transition
    //presenting
    let customAnimationPresentor = CustomAnimationPresenter()
    let customAnimationDismisser = CustomAnimationDismisser()
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        //
        return customAnimationPresentor
    }
    //
//    class CustomAnimationPresenter: NSObject, UIViewControllerAnimatedTransitioning {
//        //
//        func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
//            //
//            return 0.5
//        }
//        func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
//            // my custom transition animation code logic
//            
//        }
//    }
//    
    
    //dimising
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        //
        return customAnimationDismisser
    }
    //remove status bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    fileprivate func setupHUD() {
        view.addSubview(capturePhotoButton)
        view.addSubview(dismissButton)
        view.addSubview(flashButton)
        capturePhotoButton.anchor(top: nil, left: nil, bottom: view.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 24, paddingRight: 0, width: 80, height: 80)
        //center it
        capturePhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        //
        flashButton.anchor(top: nil, left: nil, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 24, paddingRight: 10, width: 80, height: 80)
        
        
        dismissButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 40, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 50, height: 50)
    
    }
    @objc func handleCapturePhoto() {
        print("Capturing photo....")
        //
        let settings = AVCapturePhotoSettings()
        guard let previewFormatType = settings.availablePreviewPhotoPixelFormatTypes.first else { return }
        
        settings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String :previewFormatType]
        output.capturePhoto(with: settings, delegate: self)
    }
    
    @available(iOS 11.0, *)
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        let imageData = photo.fileDataRepresentation()
        let previewImage = UIImage(data: imageData!)
        //
        let containerView = PreviewPhotoContainerView()
        containerView.previewImageView.image = previewImage
        view.addSubview(containerView)
        containerView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        //adding the preview to phone
//        let previewImageView = UIImageView(image: previewImage)
//        view.addSubview(previewImageView)
//        previewImageView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
//        print("Finish processing photo sample buffer....")
    }
// b efore iOS 11.0
    /*
    public func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        
       
        let imageData =  AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer!, previewPhotoSampleBuffer: previewPhotoSampleBuffer)
        
        
        
        
        
//        let data = AVCapturePhotoOutput.fileDataRepresentation
        let previewImage = UIImage(data: imageData!)
        //adding the preview to phone
        let previewImageView = UIImageView(image: previewImage)
        view.addSubview(previewImageView)
        previewImageView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        print("Finish processing photo sample buffer....")

    }
 */
    
    //Avcapture delegate Methods
    
    
    let output = AVCapturePhotoOutput()
    func setupCaptureSession() {
    
        //0:Add camera usage in info plist.
        let captureSession = AVCaptureSession()
        
        //1: setup inputs = get the device camera  on our phone and use as an input
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else { return}
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
                
            }
            
            
        } catch let error {
            print("Could not setup camera input", error)
        }
        
        
        //2: setup outputs
        
        // Capture to photo from the camera
        
        if captureSession.canAddOutput(output) {
            captureSession.addOutput(output)
        }
        
        
        //3: setup output preview
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        //4: set the frame
        previewLayer.frame = view.frame
        
        //5: Add it to viewcontrollers view
        view.layer.addSublayer(previewLayer)
        
        //6: start the capture session. Pipes the input to the output shows what the camera is seeing.
        captureSession.startRunning()
        
    }
    
    
}
