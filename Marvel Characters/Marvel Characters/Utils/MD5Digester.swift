//
//  MD5Provider.swift
//  Marvel Characters
//
//  Created by Hugo Alonso on 5/25/16.
//  Copyright © 2016 halonsoluis. All rights reserved.
//

import Foundation

struct MD5Digester {
    
    // return MD5 digest of string provided
    static func digest(string: String) -> String? {
       
        guard let data = string.dataUsingEncoding(NSUTF8StringEncoding) else { return nil }
        
        var digest = [UInt8](count: Int(CC_MD5_DIGEST_LENGTH), repeatedValue: 0)
        
        CC_MD5(data.bytes, CC_LONG(data.length), &digest)
        
        return (0..<Int(CC_MD5_DIGEST_LENGTH)).reduce("") { $0 + String(format: "%02x", digest[$1]) }
    }
}