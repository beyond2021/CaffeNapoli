//
//  CustomImageView.swift
//  CaffeNapoli
//
//  Created by Kev1 on 10/31/17.
//  Copyright © 2017 Kev1. All rights reserved.
// the load image using urlsession

import UIKit
// To save images preventing unecessar download
var imageCache = [String : UIImage]()


class CustomImageView: UIImageView {
    //class url variable
    var lastUrlUsedToLoadImage : String?
    // Method to load image
    func loadImage(urlString: String){
//        print("Loading image....")
        


        guard let url = URL(string: urlString) else { return }
                    lastUrlUsedToLoadImage = urlString
        // CHECK THE IMAGECACHE FOR THE IMAGE, WE WILL USE IUT AND AVOID THE URLSESSION TASK
        if let cachedImage = imageCache[urlString] {
            self.image = cachedImage
            // it will stop here
        }
        
       
                    URLSession.shared.dataTask(with: url) { (data, response, err) in
                      
                        if let err = err {
                            print("Failed to fetch profile image:", err)
                            return
                        }
                        //With urlsession u should check for response status of 200 [HTTP OK]
        
                        //                print(data)
                        // to stop double loading and repeating
                        if url.absoluteString != self.lastUrlUsedToLoadImage {
                            return
                        }
                        guard let imageData = data else { return }
        
                        let image = UIImage(data: imageData)
                        // STUFF THIS IMAGE INTO THE CACHE
                        imageCache[url.absoluteString] = image
                        
                        // I need to get back to the main UI thread
                        DispatchQueue.main.async {
                            self.image = image
                        }
        
                        }.resume()
        
        
    }
}
