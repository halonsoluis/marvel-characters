//
//  CharacterSearchUITests.swift
//  Marvel Characters
//
//  Created by Hugo Alonso on 6/4/16.
//  Copyright © 2016 halonsoluis. All rights reserved.
//

import XCTest

class CharacterSearchUITests: XCTestCase {
    let app = XCUIApplication()
    var cells : XCUIElementQuery!
    var textForSearchBar = "Search Me"
    var searchBar : XCUIElement!
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        app.launchArguments.append("MOCKUP_MODE")

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app.launch()
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        
        app.navigationBars["Marvel_Characters.CharacterListView"].buttons["icn nav search"].tap()
        
        cells = app.tables.element.cells
        
        searchBar = app.searchFields["Search..."]
        
    }
    
    func testCancelButtonReturnToList() {
        
        XCTAssertFalse(app.navigationBars["Marvel_Characters.CharacterListView"].buttons["icn nav search"].exists)
        
        app.buttons["Cancel"].tap()
        
        XCTAssertTrue(app.navigationBars["Marvel_Characters.CharacterListView"].buttons["icn nav search"].exists)
        
    }
    
    func testSearchStartsEmpty() {
        let textInside = searchBar.value as! String
        
        XCTAssert(textInside == "")
    }
    
    func testResultsStartsEmpty() {
        XCTAssert(cells.count == 0)
    }
    
    func testSearchInsertsText() {
        searchBar.typeText(textForSearchBar)
        
        let textInside = searchBar.value as! String
        
        XCTAssert(textInside == textForSearchBar)
    }
    
    func testSearchProducesResults() {
        searchBar.typeText(textForSearchBar)
        cells = app.tables.element.cells
        
        _ = self.expectation(for: NSPredicate(format: "self.count > 0"), evaluatedWith: cells, handler: nil)
        self.waitForExpectations(timeout: 5.0, handler: nil)
        
        cells = app.tables.element.cells
        
        XCTAssert(cells.count > 0)
    }
    func testStatusBarIsPresent(){
        let statusBarsQuery = XCUIApplication().statusBars.element
        XCTAssertTrue(statusBarsQuery.exists)
        XCTAssertTrue(statusBarsQuery.isHittable)
    }
}
