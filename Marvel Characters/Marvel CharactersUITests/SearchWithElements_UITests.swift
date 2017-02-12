//
//  SearchWithElementsUITests.swift
//  Marvel Characters
//
//  Created by Hugo Alonso on 6/4/16.
//  Copyright © 2016 halonsoluis. All rights reserved.
//

import XCTest

class SearchWithElementsUITests: XCTestCase {
    
    let app = XCUIApplication()
    var cells : XCUIElementQuery!
    var textForSearchBar = "Search Me"
    var searchBar : XCUIElement!
    
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        
        app.launchArguments.append("MOCKUP_MODE")

        app.launch()
        
        app.navigationBars["Marvel_Characters.CharacterListView"].buttons["icn nav search"].tap()
        
        cells = app.tables.element.cells
        
        searchBar = app.searchFields["Search..."]
        
        XCTAssert(app.keyboards.count == 1)
        
        searchBar.typeText(textForSearchBar)
        
        
        
        _ = self.expectation(for: NSPredicate(format: "self.count > 0"), evaluatedWith: cells, handler: nil)
        self.waitForExpectations(timeout: 5.0, handler: nil)
        
        XCTAssert(app.keyboards.count == 1)
    }
    
    func testSearchResultsIsEmptyAfterTapDeleteKeyUntilEmptyText() {
        let textSize = textForSearchBar.characters.count
       
        for _ in 0..<textSize {
            app.keys["delete"].tap()
        }
        
        _ = self.expectation(for: NSPredicate(format: "self.count == 0"), evaluatedWith: cells, handler: nil)
        self.waitForExpectations(timeout: 5.0, handler: nil)
        XCTAssert(app.keyboards.count == 1)
        
        XCTAssert(app.tables.element.cells.count == 0)
    }
    
    func testSearchResultsIsEmptyAfterSelectAllAndEmptyTextIntroduced() {
       
        searchBar.press(forDuration: 1.2)
        app.menuItems["Select All"].tap()
        app.keys["delete"].tap()
        
        
        _ = self.expectation(for: NSPredicate(format: "self.count == 0"), evaluatedWith: cells, handler: nil)
        self.waitForExpectations(timeout: 5.0, handler: nil)
        XCTAssert(app.keyboards.count == 1)
        
        XCTAssert(app.tables.element.cells.count == 0)
    }
    
    
    func testForElementsExistsInViewWithMockup() {
        XCTAssert(app.tables.count == 1)
        
        XCTAssert(cells.count >= 1)
        
        XCTAssert(cells.element(boundBy: 0).staticTexts.count == 1)
        XCTAssert(cells.element(boundBy: 0).images["Character Image"].exists)
        
        XCTAssert(app.keyboards.count == 1)
    }
    
    func testCharacterNameIsDisplayedInCell() {
        
        let characterName = cells.element(boundBy: 0).staticTexts.element(boundBy: 0)
        XCTAssert(characterName.exists)
        XCTAssert(!characterName.label.isEmpty)
    }
    
    
    func testNavigatesIntoCharacterDetailsWhenTappingOverCell() {
       
        XCTAssert(!app.navigationBars["Marvel_Characters.BlurredImageContainerView"].exists)
        
        app.tables.children(matching: .cell).element(boundBy: 0).tap()
        
        XCTAssert(app.navigationBars["Marvel_Characters.BlurredImageContainerView"].exists)
    }
    
//    func testPagination() {
//        
//        let numCells = cells.count
//        
//        app.tables.element.swipeUp()
//        app.tables.element.swipeUp()
//        app.tables.element.swipeUp()
//        app.tables.element.swipeUp()
//        
//        _ = self.expectationForPredicate(NSPredicate(format: "self.count != \(numCells)"), evaluatedWithObject: cells, handler: nil)
//        self.waitForExpectationsWithTimeout(5.0, handler: nil)
//        
//        
//        let newCells = cells.count
//        
//        XCTAssert(numCells < newCells)
//    }
//    
//    
//    func testCorrectCellCountPaginationIsShown() {
//        
//        let numCells = cells.count
//        XCTAssert(numCells == 20)
//        
//        app.tables.element.swipeUp()
//        app.tables.element.swipeUp()
//     
//        let newCells = cells.count
//        XCTAssert(newCells == 40)
//    }
    
    func testBackButtonInDetailsReturnsToSearchList() {
        
        app.tables.children(matching: .cell).element(boundBy: 0).tap()
        
        app.navigationBars["Marvel_Characters.BlurredImageContainerView"].children(matching: .button).matching(identifier: "Back").element(boundBy: 1).tap()
        
        XCTAssert(!app.navigationBars["Marvel_Characters.BlurredImageContainerView"].exists)
        
        cells = app.tables.element.cells
        XCTAssert(cells.count > 0)
    }
    func testStatusBarIsPresent(){
        let statusBarsQuery = XCUIApplication().statusBars.element
        XCTAssertTrue(statusBarsQuery.exists)
        XCTAssertTrue(statusBarsQuery.isHittable)
    }
}
