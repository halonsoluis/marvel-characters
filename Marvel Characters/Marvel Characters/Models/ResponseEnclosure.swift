//
//  ResponseEnclosure.swift
//  Marvel Characters
//
//  Created by Hugo on 5/26/16.
//  Copyright © 2016 halonsoluis. All rights reserved.
//

import Foundation
import ObjectMapper

class ResponseEnclosure<T: Mappable>: Mappable {
    
    var code: Int?
    var status: String?
    var copyright: String?
    var attributionText: String?
    var attributionHTML: String?
    var etag: String?
    var data: ResultDataBox<T>?
    
    //MARK: Mappable protocol
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        code <- map["code"]
        status <- map["status"]
        copyright <- map["copyright"]
        attributionText <- map["attributionText"]
        attributionHTML <- map["attributionHTML"]
        etag <- map["etag"]
        data <- map["data"]
    }
}
