//
//  PhotoSelectorController.swift
//  CaffeNapoli
//
//  Created by Kev1 on 10/24/17.
//  Copyright © 2017 Kev1. All rights reserved.
//

import UIKit
import Photos

class PhotoSelectorController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    // constants
    let cellID = "cellID"
    let headerID = "headerID"
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
        setupNavigationButtons()
        //
        collectionView?.register(PhotoSelectorCell.self, forCellWithReuseIdentifier: cellID)
        
        // Register Custom Header
        collectionView?.register(PhotoSelectorHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerID)
        fetchPhotos()
        
    }
    //MARK: - Fetch Photos
    // An array to hold the images. EMPTY UIImage array
    var images = [UIImage]()
    var assets = [PHAsset]() // to speed up
    
    //MARK: - Fetch Options
    // AFTER REFRACTION
    fileprivate func assetsFetchOptions() -> PHFetchOptions {
        let fetchOptions = PHFetchOptions()
        fetchOptions.fetchLimit = 30
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false) // the get the latest photos taken
        fetchOptions.sortDescriptors = [sortDescriptor]
        return fetchOptions
    }
    
    
    fileprivate func fetchPhotos() {
        
 
        let allPhotos = PHAsset.fetchAssets(with: .image, options: assetsFetchOptions())
        // to speed up and reduce lag we use a background thread (heavy work on backgroung thread)
        DispatchQueue.global(qos: .background).async {
            //
            allPhotos.enumerateObjects( { (asset, count, stop) in
                //print("count is :", count)
                //
                //print(asset)
                // to access the images fromn assets we use imageManager(photo enumeration code)
                let imageManager = PHImageManager.default()
                let targetSize = CGSize(width: 200, height: 200)
                let options = PHImageRequestOptions()
                options.isSynchronous = true
                imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: options, resultHandler: { (image, info) in
                    //
                    //print(image)
                    
                    // unwrap the imnage
                    if let image = image {
                        // put the images in the array
                        self.images.append(image)
                        // fill up asset array
                        self.assets.append(asset)
                        // to open with an image in the header
                        if self.selectedImage == nil {
                            self.selectedImage = image // the first image that loads
                        }
                    }
                    
                })
                
                //When we get all the images then we call collectView reloadData
                if count == allPhotos.count - 1 {
                    //here we have the same amount of images and assets
                    
                    //here we get back on the main thread UICode always on main thread
                    DispatchQueue.main.async {
                        self.collectionView?.reloadData() //here we can do some things with the cololectionView
                    }
                    
                    
                    
                }
                
            })

        }
        
        
        
       
    }
    
    // This give you the line above the header
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
    }
    
    // This meth for header size is a must to show header
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = view.frame.width
        return CGSize(width: width, height: width)
    }
    // Grad the header for the next view controller
    var header : PhotoSelectorHeader?
    // This method reders out the header for us
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerID, for: indexPath) as! PhotoSelectorHeader
        
        self.header = header
        //header.backgroundColor = .red
        // INSERT THE HEADER IMAGE HERE
        header.photoImageView.image = selectedImage // blurry image
        //we want to request a much larger image from assets
//        let imageManager = PHImageManager.default()
//        let targetSize = CGSize(width: 200, height: 200)
//        let options = PHImageRequestOptions()
//        options.isSynchronous = true
        // get the index of the image
        
        if let selectedImage = selectedImage {
            if let index = self.images.index(of: selectedImage) {
               let selectedAsset = self.assets[index]
                 let imageManager = PHImageManager.default()
                
                let targetSize = CGSize(width: 600, height: 600)
                imageManager.requestImage(for: selectedAsset, targetSize: targetSize, contentMode: .default, options: nil, resultHandler: { (image, infoDictionary) in
                    //
                    header.photoImageView.image = image
                })
            }
        }
//        let index = self.images.index(of: selectedImage)
        
       
        
        return header
    }
    
    // 4 cells per row design - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 3) / 4
        
        return CGSize(width: width, height: width)
    }
    //Horizontal spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        //
        return 1
    }
    //Vertical Spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    
    // Number Of cells u want
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 5
        return images.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! PhotoSelectorCell
//        cell.backgroundColor = .blue
        cell.photoImageView.image = images[indexPath.item]
        return cell
    }
    //MARK: - ColletionView Selection
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //print(indexPath)
//        let selectedImage = images[indexPath.item]
//        print(selectedImage)
        self.selectedImage = images[indexPath.item] // fill the selected image
        // to rerender the header for the image we call collectionView reloadData here
        self.collectionView?.reloadData() // coletionView redraws itself. next- viewForSupplementaryElementOfKind method above
        //Scroll collectionview to the bottom after selection
        let indexPath = IndexPath(item: 0, section:0)
        collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
        
    }
    //To hold the selected image for the header
    var selectedImage: UIImage? // this is filled when thumbnail is tapped
    
    
    //To hide the status bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    fileprivate func setupNavigationButtons(){
        navigationController?.navigationBar.tintColor = .black // change cancel button color
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        //
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(handleNext))
    }
    @objc func handleCancel() {
        //print(123)
        dismiss(animated: true, completion: nil)
    }
    @objc func handleNext() {
//        print("handling next.")
        //Here we need to an new controller onto the navigation stack
        let sharePhotoController = SharePhotoController()
        //SETTING THE IMAGE ON SHARE PHOTO CONTROLLER HAPPENS HERE
        sharePhotoController.selectedImage = header?.photoImageView.image
        navigationController?.pushViewController(sharePhotoController, animated: true)
        
    }
}
