//
//  MockupResourceTests.swift
//  Marvel Characters
//
//  Created by Hugo Alonso on 6/4/16.
//  Copyright © 2016 halonsoluis. All rights reserved.
//

import XCTest
@testable import Marvel_Characters

class MockupResourceTests: XCTestCase {

    func testMockupCharactersDataLoaded() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertNotNil(MockupResource.character.getMockupData())
    }

    func testMockupRelatedItemsDataLoaded() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertNotNil(MockupResource.crossReference.getMockupData())
    }

    func testMockupImageDataLoaded() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertNotNil(MockupResource.image.getMockupData())
    }
}
