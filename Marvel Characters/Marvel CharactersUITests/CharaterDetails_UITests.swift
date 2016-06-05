//
//  CharacterDetails_UITests.swift
//  Marvel CharactersUITests
//
//  Created by Hugo on 5/25/16.
//  Copyright © 2016 halonsoluis. All rights reserved.
//

import XCTest

class CharacterDetails_UITests: XCTestCase {
    var characterName = ""
    let app = XCUIApplication()
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mockupEnabled = true
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        
        characterName = app.tables.cells.elementBoundByIndex(0).buttons.elementBoundByIndex(0).label
        
        app.tables.childrenMatchingType(.Cell).elementBoundByIndex(0).tap()
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
    }
    
    func testBackToList() {
        let backButton = app.navigationBars["Marvel_Characters.BlurredImageContainerView"].childrenMatchingType(.Button).matchingIdentifier("Back").elementBoundByIndex(1)
        backButton.tap()
        
        XCTAssert(!backButton.exists)
    }
    
    func testCharacterNameIsShownOnNavigationBarAfterScrollingDown() {
        
        XCTAssert(!app.navigationBars[characterName].exists)
        
        app.scrollViews.element.swipeUp()
        app.scrollViews.element.swipeUp()
        
        XCTAssert(app.navigationBars[characterName].exists)
        XCTAssert(app.navigationBars[characterName].staticTexts[characterName].exists)
    }
    
    func testCharacterNameIsHiddenOnNavigationBarAfterScrollingUp() {
        
        XCTAssert(!app.navigationBars[characterName].staticTexts[characterName].exists)
        app.scrollViews.element.swipeUp()
        app.scrollViews.element.swipeUp()
        
        XCTAssert(app.navigationBars[characterName].staticTexts[characterName].exists)
        
        app.scrollViews.element.swipeDown()
        app.scrollViews.element.swipeDown()
        app.scrollViews.element.swipeDown()
        
        XCTAssert(!app.navigationBars[characterName].staticTexts[characterName].exists)
   //     XCTAssert(app.navigationBars[characterName].staticTexts[""].exists)
    //    XCTAssert(app.navigationBars[""].staticTexts[""].exists)
    }
    
 
    
    func backButtonReturnsToSearchResults() {
        app.navigationBars["Marvel_Characters.BlurredImageContainerView"].childrenMatchingType(.Button).matchingIdentifier("Back").elementBoundByIndex(1).tap()
        
    }
}
