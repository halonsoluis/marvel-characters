//
//  Thumbnail.swift
//  Marvel Characters
//
//  Created by Hugo on 5/26/16.
//  Copyright © 2016 halonsoluis. All rights reserved.
//

import Foundation

class Thumbnail: Codable {
    
    let path: String?
    let `extension`: String?
    
}

extension Thumbnail: ImageLocatorDelegate {
    func url() -> String? {
        guard let path = path, let imageExtension = `extension` else { return nil }
        return path + "." + imageExtension
    }
}
