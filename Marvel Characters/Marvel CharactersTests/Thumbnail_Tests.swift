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

    let thumbnailJSON: Dictionary<String, Any> = [
        "path": "testPath",
        "extension": "testExtension"
    ]
    var thumbnail: Thumbnail?

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let data = try! JSONSerialization.data(withJSONObject: thumbnailJSON, options: .prettyPrinted)
        thumbnail = try? JSONDecoder().decode(Thumbnail.self, from: data)
    }

    func testThumbnailCreated() {
        XCTAssert(thumbnail != nil)
    }

    func testThumbnailUrlCreation() {
        guard let url = thumbnail?.url() else { XCTAssert(false) ; return}

        XCTAssertEqual(url, "testPath.testExtension")
    }
}
