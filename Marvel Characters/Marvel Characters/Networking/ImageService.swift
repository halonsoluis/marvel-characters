//
//  ImageService.swift
//  Marvel Characters
//
//  Created by Hugo on 5/26/16.
//  Copyright © 2016 halonsoluis. All rights reserved.
//

import Foundation
import Kingfisher
import UIKit

/**
 Prepares for loading images and handle the cache of those already downloaded
*/
struct ImageSource {
   
    /**
     Download/Load from cache the image and set it at the specified imageView
     
     - parameter imageView:         destination UIImageView
     - parameter uniqueKey:         unique resource location in cache
     - parameter completionHandler: returns the loaded image (from web or cache)
     */
    static func downloadImageAndSetIn(imageView: UIImageView, imageURL: NSURL, withUniqueKey uniqueKey :String, completionHandler: ((Image?)->())? = nil){
        let resourceKey = "\(imageURL.absoluteString)-\(uniqueKey)"
        print(resourceKey)
        
        let resource = Kingfisher.Resource(downloadURL: imageURL, cacheKey: resourceKey)
        
        let placeholderImage = getPlaceholderImage() ?? imageView.image
        
        imageView.kf_setImageWithResource(resource, placeholderImage: placeholderImage, optionsInfo: [.Transition(ImageTransition.Fade(1))], progressBlock: nil, completionHandler: {(image, _, _ ,_) in
            completionHandler?(image)
        })
    }
    
    /**
     Obtains a placeholder Image to show when downloading resource
     
     - returns: a placeholder Image
     */
    static private func getPlaceholderImage() -> UIImage? {
       return nil
    }
}