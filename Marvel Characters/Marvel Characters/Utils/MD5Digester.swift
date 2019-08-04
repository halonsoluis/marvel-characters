//
//  MD5Digester.swift
//  Marvel Characters
//
//  Created by Hugo Alonso on 5/25/16.
//  Copyright © 2016 halonsoluis. All rights reserved.
//

import Foundation

struct MD5Digester {
    // return MD5 digest of string provided
    static func digest(_ string: String) -> String? {

        guard let data = string.data(using: String.Encoding.utf8) else { return nil }

        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))

        CC_MD5((data as NSData).bytes, CC_LONG(data.count), &digest)

        return (0..<Int(CC_MD5_DIGEST_LENGTH)).reduce("") { $0 + String(format: "%02x", digest[$1]) }
    }
}
