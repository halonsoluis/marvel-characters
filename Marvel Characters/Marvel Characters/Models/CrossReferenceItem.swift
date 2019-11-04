//
//  CrossReferenceItem.swift
//  Marvel Characters
//
//  Created by Hugo on 5/26/16.
//  Copyright © 2016 halonsoluis. All rights reserved.
//

import Foundation

class CrossReferenceItem: Codable {

    let resourceURI: String?
    let name: String?
}

class StoriesCrossReferenceItem: CrossReferenceItem {

    let type: String? = nil
}
