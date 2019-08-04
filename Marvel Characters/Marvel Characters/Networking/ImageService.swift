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

    fileprivate static let placeHolderImage = UIImage(named: "Image_not_found")
    /**
     Download/Load from cache the image and set it at the specified imageView
     
     - parameter imageView:         destination UIImageView
     - parameter uniqueKey:         unique resource location in cache
     - parameter completionHandler: returns the loaded image (from web or cache)
     */
    static func downloadImageAndSetIn(_ imageView: UIImageView,
                                      imageURL: URL,
                                      withUniqueKey uniqueKey: String,
                                      completionHandler: ((Image?) -> Void)? = nil) {
        let resourceKey = "\(imageURL.absoluteString)-\(uniqueKey)"

        let resource = ImageResource(downloadURL: imageURL, cacheKey: resourceKey)

        let placeholderImage = getPlaceholderImage() ?? imageView.image

        imageView.kf.setImage(
            with: resource,
            placeholder: placeholderImage,
            options: [.transition(.fade(1))],
            progressBlock: nil) { result in
                    switch result {
                    case .success(let value):
                        completionHandler?(value.image)
                    case .failure(let error):
                        print(error)
                    }
        }
    }

    /**
     Obtains a placeholder Image to show when downloading resource
     
     - returns: a placeholder Image
     */
    static fileprivate func getPlaceholderImage() -> UIImage? {
        //mockupEnabled ? UIImage(data: MockupResource.Image.getMockupData()!) :
        return placeHolderImage
    }
}
