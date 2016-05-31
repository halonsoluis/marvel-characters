//
//  CrossReference.swift
//  Marvel Characters
//
//  Created by Hugo Alonso on 5/31/16.
//  Copyright © 2016 halonsoluis. All rights reserved.
//

import Foundation
import ObjectMapper

class CrossReference: Mappable, MainAPISubject {
    
    var id: Int?
    var modified: String?
    var thumbnail: Thumbnail?
    var resourceURI: String?
    
    
    //MARK: Mappable protocol
    required init?(_ map: Map) { }
    
    func mapping(map: Map) {
        
        id <- map["id"]
        modified <- map["modified"]
        thumbnail <- map["thumbnail"]
        resourceURI <- map["resourceURI"]
   }
}