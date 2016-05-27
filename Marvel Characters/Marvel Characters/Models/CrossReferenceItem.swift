//
//  CrossReferenceItem.swift
//  Marvel Characters
//
//  Created by Hugo on 5/26/16.
//  Copyright © 2016 halonsoluis. All rights reserved.
//

import Foundation
import ObjectMapper

class CrossReferenceItem : Mappable {
    
    var resourceURI: String?
    var name: String?
    
    //MARK: Mappable protocol
    required init?(_ map: Map) {
    }
    
    func mapping(map: Map) {
        resourceURI <- map["resourceURI"]
        name <- map["name"]
    }
}

class StoriesCrossReferenceItem : CrossReferenceItem {
    
    var type: String?
    
    //MARK: Mappable protocol
    required init?(_ map: Map) {
        super.init(map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map)
        type <- map["type"]
    }
}