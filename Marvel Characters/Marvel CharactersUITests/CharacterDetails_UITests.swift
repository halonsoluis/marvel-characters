//
//  CharacterDetails_UITests.swift
//  Marvel CharactersUITests
//
//  Created by Hugo on 5/25/16.
//  Copyright © 2016 halonsoluis. All rights reserved.
//

import XCTest

class CharacterDetails_UITests: XCTestCase {
    let characterName = "3-D Man"
    let app = XCUIApplication()
    
    override func setUp() {
        super.setUp()
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        app.configureSuite()
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        app.goIntoCharacterDetails(characterName: characterName)
    }
    
    func testCharacterNameIsShownOnDetails() {
        XCTAssertTrue(app.scrollViews.otherElements.staticTexts["Text Detail"].label == characterName, "Character name should be shown")
    }
    
    
    func testBackToList() {
        
        XCTAssert(app.backButton.waitForExistence(timeout: 1))
        
        app.backButton.tap()
        
        XCTAssertFalse(app.backButton.waitForExistence(timeout: 1))
    }
    
    func testCharacterNameBehaviourInNavigationBar() {
        XCTAssertFalse(app.navigationBars[characterName].waitForExistence(timeout: 1))
        
        app.swipeUp()
        
        XCTAssert(app.navigationBars[characterName].waitForExistence(timeout: 1))
        
        app.swipeDown()
        
        XCTAssertFalse(app.navigationBars[characterName].waitForExistence(timeout: 1))
    }
    
    func testShowOnlyDataAvailableForMarvelCharacter() {
        
        XCTAssert(app.collectionViews.count == 4, "The mockup for current character '3D-Man' has stories, events, comics and series related")
        
        app.backButton.tap()
        app.goIntoCharacterDetails(characterName: "A-Bomb (HAS)")
        
        XCTAssertTrue(app.collectionViews.count == 0, "The mockup for current character 'A-Bomb (HAS)' has no items on collections")
    }

//  -> No need to test all the collections
    func xtestPaginationIsPossibleInAllCollections() {
        app.collectionViews.allElementsBoundByIndex.forEach { collectionPaginationTest(for: $0) }
    }
    
    func testPaginationIsPossibleInCollections() {
        if let collection = app.collectionViews.allElementsBoundByIndex.first {
            collectionPaginationTest(for: collection)
        }
    }
    
    private func collectionPaginationTest(for collection: XCUIElement) {
        app.locateItemInScreen(element: collection, direction: .down)
        
        let initialCellCount = collection.cells.count
        
        collection.swipeInDirection(.right, times: 4)
        
        XCTAssertTrue(initialCellCount < collection.cells.count)
    }
}
