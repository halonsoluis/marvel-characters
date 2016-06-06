//
//  LinkURL.swift
//  Marvel Characters
//
//  Created by Hugo on 5/26/16.
//  Copyright © 2016 halonsoluis. All rights reserved.
//

import ObjectMapper

class LinkURL: Mappable {
    
    var type: String!
    var url: String?
    
    //MARK: Mappable protocol
    required init?(_ map: Map) { }
    
    func mapping(map: Map) {
        type <- map["type"]
        url <- map["url"]
    }
}
