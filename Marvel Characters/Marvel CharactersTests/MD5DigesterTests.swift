//
//  Marvel_CharactersTests.swift
//  Marvel CharactersTests
//
//  Created by Hugo on 5/25/16.
//  Copyright © 2016 halonsoluis. All rights reserved.
//

import XCTest
@testable import Marvel_Characters

class MD5DigesterTests: XCTestCase {

    func testDigest() {
        let digest = MD5Digester.digest("1abcd1234")
        XCTAssert(digest == "ffd275c5130566a2916217b101f26150")
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testDigestEmptyLine() {
        let digest = MD5Digester.digest("")
        print(digest ?? "")
        XCTAssert(digest != nil)
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testDigestBigLine() {
        let digest = MD5Digester.digest("ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150ffd275c5130566a2916217b101f26150")
         XCTAssert(digest != nil)
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

}
