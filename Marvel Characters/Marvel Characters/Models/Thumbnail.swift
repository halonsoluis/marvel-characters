//
//  Thumbnail.swift
//  Marvel Characters
//
//  Created by Hugo on 5/26/16.
//  Copyright © 2016 halonsoluis. All rights reserved.
//

import Foundation
import ObjectMapper

class Thumbnail : Mappable {
    
    var path: String?
    var imageExtension: String?
    
    //MARK: Mappable protocol
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        path <- map["path"]
        imageExtension <- map["extension"]
    }
    
}

extension Thumbnail : ImageLocatorDelegate {
    func url() -> String? {
        guard let path = path, let imageExtension = imageExtension else { return nil }
        return path + "." + imageExtension
    }
}
