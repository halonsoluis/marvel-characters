//
//  LargeViewCrossCollections_UITests.swift
//  Marvel Characters
//
//  Created by Hugo Alonso on 6/4/16.
//  Copyright © 2016 halonsoluis. All rights reserved.
//

import XCTest

class LargeViewCrossCollections_UITests: XCTestCase {
    let app = XCUIApplication()
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        app.launchArguments.append("MOCKUP_MODE")

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        app.tables.childrenMatchingType(.Cell).elementBoundByIndex(0).tap()
        
        app.collectionViews.cells.elementBoundByIndex(0).tap()
    }
    
    func testExample() {
        
        let count = app.collectionViews.count
        XCTAssertTrue(count == 1)
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
//        scrollViewsQuery.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).elementBoundByIndex(1).collectionViews.cells.otherElements.containingType(.StaticText, identifier:"Original Sin (2014) #6 (Dell'otto Variant)").images["Image_not_found"].tap()
//        app.buttons["icn nav close white"].tap()
    }
    
    func testStatusBarIsPresent(){
        let statusBarsQuery = XCUIApplication().statusBars.element
        XCTAssertTrue(statusBarsQuery.exists)
        XCTAssertTrue(statusBarsQuery.hittable)
    }
    
}
