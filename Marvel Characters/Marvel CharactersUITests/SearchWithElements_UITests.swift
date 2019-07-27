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
    var textForSearchBar = "srch"
    
    var cells: XCUIElementQuery {
        return app.tables["SearchCharacterList"].cells
    }
    
    var searchBar: XCUIElement {
        return app.searchFields["Search..."]
    }
    
    var searchButton: XCUIElement {
        return app.navigationBars["Marvel_Characters.CharacterListView"].children(matching: .button).element
    }
    
    var cancelButton: XCUIElement {
        return app.buttons["Cancel"]
    }
    
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        
        app.configureSuite()
        
        searchButton.tap()
        searchBar.typeText(textForSearchBar)
    }
    
    func testSearchResultsIsEmptyAfterTapDeleteKeyUntilEmptyText() {
        XCTAssert(app.keyboards.count == 1)
        
        for _ in 0..<textForSearchBar.count {
            app.keys["delete"].tap()
        }
        
        XCTAssert(app.keyboards.count == 1)
        sleep(1)
        XCTAssert(cells.count == 0)
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
    
    func testReturningToSearchFromDetailsKeepsTheSearchResultsInPlace() {
        
        let firstCell = cells.element(boundBy: 0)
        XCTAssertTrue(firstCell.waitForExistence(timeout: 2))
        firstCell.tap()
        
        XCTAssertTrue(app.backButton.waitForExistence(timeout: 2))
        app.backButton.tap()
        
        //The search is not resetted
        sleep(1)
        XCTAssertTrue(cells.count > 0)
    }
}
