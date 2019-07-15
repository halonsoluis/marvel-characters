//
//  CrossReferenceBox.swift
//  Marvel Characters
//
//  Created by Hugo on 5/26/16.
//  Copyright © 2016 halonsoluis. All rights reserved.
//

import Foundation

class CrossReferenceBox<T: CrossReferenceItem>: Codable {
    
    let available: Int?
    let collectionURI: String?
    let items: [T]?
    let returned: Int?
}
