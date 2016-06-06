//
//  MockupResource_Tests.swift
//  Marvel Characters
//
//  Created by Hugo Alonso on 6/4/16.
//  Copyright © 2016 halonsoluis. All rights reserved.
//

import XCTest
@testable import Marvel_Characters

class MockupResource_Tests: XCTestCase {
    
    func testMockupCharactersDataLoaded() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertNotNil(MockupResource.Character.getMockupData())
    }
   
    func testMockupRelatedItemsDataLoaded() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertNotNil(MockupResource.CrossReference.getMockupData())
    }
    
    func testMockupImageDataLoaded() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertNotNil(MockupResource.Image.getMockupData())
    }
    
    func testPerformanceMockupCharactersDataLoaded() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
            MockupResource.Character.getMockupData()
        }
    }
    func testPerformanceMockupRelatedItemsDataLoaded() {
        // This is an example of a performance test case.
        self.measureBlock {
            MockupResource.CrossReference.getMockupData()
        }
    }
    func testPerformanceMockupImageDataLoaded() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
            MockupResource.Image.getMockupData()
        }
    }
}
