//
//  Character.swift
//  Marvel Characters
//
//  Created by Hugo on 5/26/16.
//  Copyright © 2016 halonsoluis. All rights reserved.
//

import Foundation
import ObjectMapper

class MarvelCharacter: Mappable, MainAPISubject {
    
    var id: Int?
    var name: String?
    var description: String?
    var modified: String?
    var thumbnail: Thumbnail?
    var resourceURI: String?
    
    var comics: CrossReferenceBox<CrossReferenceItem>?
    var series: CrossReferenceBox<CrossReferenceItem>?
    var stories: CrossReferenceBox<StoriesCrossReferenceItem>?
    var events: CrossReferenceBox<CrossReferenceItem>?
    var urls: [LinkURL]?
    
    //MARK: Mappable protocol
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        
        id <- map["id"]
        name <- map["name"]
        description <- map["description"]
        modified <- map["modified"]
        thumbnail <- map["thumbnail"]
        resourceURI <- map["resourceURI"]
        
        comics <- map["comics"]
        series <- map["series"]
        stories <- map["stories"]
        events <- map["events"]
        
        urls <- map["urls"]
    }
}
