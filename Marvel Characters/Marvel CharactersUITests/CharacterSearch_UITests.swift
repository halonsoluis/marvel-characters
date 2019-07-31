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
    var cells: XCUIElementQuery {
        return app.tables["SearchCharacterList"].cells
    }
    
    var textForSearchBar = "Search Me"
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
        
        app.configureSuite()
        searchButton.tap()
    }
    
    func testInterationWithCancelButton() {
        
        XCTAssertFalse(app.navigationBars["Marvel_Characters.CharacterListView"].exists)
        XCTAssertTrue(cancelButton.exists)
        XCTAssertFalse(searchButton.exists)
        
        cancelButton.tap()
        
        XCTAssertTrue(app.navigationBars["Marvel_Characters.CharacterListView"].waitForExistence(timeout: 1))
        XCTAssertFalse(cancelButton.waitForExistence(timeout: 1))
        XCTAssertTrue(searchButton.waitForExistence(timeout: 1))
    }
    
    func testSearchProducesResults() {
        XCTAssertEqual(cells.count, 0) //"At the beginning is empty"
        XCTAssertTrue(searchBar.title.isEmpty, "search box starts Empty")
        
        searchBar.typeText(textForSearchBar)
        
        XCTAssertTrue(cells.count > 0, "The search has created results")
    }
}
