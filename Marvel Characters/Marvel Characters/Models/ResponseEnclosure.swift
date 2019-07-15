//
//  ResponseEnclosure.swift
//  Marvel Characters
//
//  Created by Hugo on 5/26/16.
//  Copyright © 2016 halonsoluis. All rights reserved.
//

import Foundation

class ResponseEnclosure<T: Codable>: Codable {
    
    let code: Int?
    let status: String?
    let copyright: String?
    let attributionText: String?
    let attributionHTML: String?
    let etag: String?
    let data: ResultDataBox<T>?
}
