//
//  Character.swift
//  Marvel Characters
//
//  Created by Hugo on 5/26/16.
//  Copyright © 2016 halonsoluis. All rights reserved.
//

import Foundation

class MarvelCharacter: Codable, MainAPISubject {

    let id: Int?
    let name: String?
    let description: String?
    let modified: String?
    let thumbnail: Thumbnail?
    let resourceURI: String?

    let comics: CrossReferenceBox<CrossReferenceItem>?
    let series: CrossReferenceBox<CrossReferenceItem>?
    let stories: CrossReferenceBox<StoriesCrossReferenceItem>?
    let events: CrossReferenceBox<CrossReferenceItem>?
    let urls: [LinkURL]?
}
