//
//  Marvel_CharactersTests.swift
//  Marvel CharactersTests
//
//  Created by Hugo on 5/25/16.
//  Copyright © 2016 halonsoluis. All rights reserved.
//

import XCTest
@testable import Marvel_Characters

class APIHandlerTests: XCTestCase {
    
    func testGetTimeStampAndHash() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        guard let tuple = APIHandler().getSecurityFootprint(1.description, privateAPIKey: "abcd", publicAPIKey: "1234") else {
            XCTAssert(false)
            return
        }
        
        XCTAssert(tuple.timeStamp == 1.description && tuple.hash == "ffd275c5130566a2916217b101f26150")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            let _ = APIHandler().getSecurityFootprint(1.description, privateAPIKey: "abcd", publicAPIKey: "1234")
        }
    }

    
}
