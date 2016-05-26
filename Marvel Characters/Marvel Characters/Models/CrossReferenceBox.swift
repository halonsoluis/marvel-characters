//
//  CrossReferenceBox.swift
//  Marvel Characters
//
//  Created by Hugo on 5/26/16.
//  Copyright © 2016 halonsoluis. All rights reserved.
//

import Foundation
import ObjectMapper

class CrossReferenceBox<T: CrossReferenceItem> : Mappable {
    
    var available: Int?
    var collectionURI: String?
    var items: [T]?
    var returned: Int?
    
    //MARK: Mappable protocol
    required init?(_ map: Map) {
    }
    
    func mapping(map: Map) {
        available <- map["available"]
        collectionURI <- map["collectionURI"]
        items <- map["items"]
        returned <- map["returned"]
     }
}
