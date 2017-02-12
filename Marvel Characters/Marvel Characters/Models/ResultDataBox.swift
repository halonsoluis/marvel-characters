//
//  ResultDataBox.swift
//  Marvel Characters
//
//  Created by Hugo on 5/26/16.
//  Copyright © 2016 halonsoluis. All rights reserved.
//

import Foundation
import ObjectMapper

class ResultDataBox<T: Mappable>: Mappable {
    
    var offset: Int?
    var limit: Int?
    var total: Int?
    var count: Int?
    var results: [T]?
    
    //MARK: Mappable protocol
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        offset <- map["offset"]
        limit <- map["limit"]
        total <- map["total"]
        count <- map["count"]
        results <- map["results"]
    }
}
