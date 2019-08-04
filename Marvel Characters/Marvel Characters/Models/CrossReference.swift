//
//  CrossReference.swift
//  Marvel Characters
//
//  Created by Hugo Alonso on 5/31/16.
//  Copyright © 2016 halonsoluis. All rights reserved.
//

import Foundation

class CrossReference: Codable, MainAPISubject {

    let id: Int?
    let title: String?
    let modified: String?
    let thumbnail: Thumbnail?
    let resourceURI: String?
}
