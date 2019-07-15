//
//  Thumbnail_Tests.swift
//  Marvel Characters
//
//  Created by Hugo Alonso on 6/4/16.
//  Copyright © 2016 halonsoluis. All rights reserved.
//

import XCTest
@testable import Marvel_Characters


class Thumbnail_Tests: XCTestCase {
    
    let thumbnailJSON = "{ \"path\": \"testPath\", \"extension\" : \"testExtension\" }"
    var thumbnail : Thumbnail?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    
        thumbnail = try? JSONDecoder().decode(Thumbnail.self, from: thumbnailJSON as! Data)
    }
    
    func testThumbnailCreated() {
        XCTAssert(thumbnail != nil)
    }
    
    
    func testThumbnailUrlCreation() {
        guard let url = thumbnail?.url() else { XCTAssert(false) ; return}
        
        XCTAssertEqual(url, "testPath.testExtension")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
            _ = self.thumbnail?.url()
        }
    }
    
}
