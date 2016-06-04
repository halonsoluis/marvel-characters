//
//  CharacterList_UITests.swift
//  Marvel Characters
//
//  Created by Hugo Alonso on 6/4/16.
//  Copyright © 2016 halonsoluis. All rights reserved.
//

import XCTest

class CharacterList_UITests: XCTestCase {
    
    override func setUp() {
        super.setUp()
       
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mockupEnabled = true
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testForElementsExistsInViewWithMockup() {
        let app = XCUIApplication()
        
        
        XCTAssert(app.tables.count == 1)
        
        XCTAssert(app.tables.cells.count >= 1)
        
        XCTAssert(app.tables.cells.elementBoundByIndex(0).buttons.count == 1)
        XCTAssert(app.tables.cells.elementBoundByIndex(0).images["Character Image"].exists)
    }

    func testThereIsAnImageInCellButton() {
        let app = XCUIApplication()
        let cell = app.tables.cells.elementBoundByIndex(0)
        let cellImage = cell.images.elementBoundByIndex(0)
        
        XCTAssert(cellImage.exists)
    }

    func testCharacterNameIsDisplayedInCell() {
        let app = XCUIApplication()
        
        let cellButton = app.tables.cells.elementBoundByIndex(0).buttons.elementBoundByIndex(0)
        XCTAssert(cellButton.exists)
        XCTAssert(!cellButton.label.isEmpty)
    }

    
    func testNavigatesIntoCharacterDetailsWhenTappingOverCell() {
        let app = XCUIApplication()
        
        XCTAssert(!app.navigationBars["Marvel_Characters.BlurredImageContainerView"].exists)
        
        app.tables.childrenMatchingType(.Cell).elementBoundByIndex(0).tap()
        
        XCTAssert(app.navigationBars["Marvel_Characters.BlurredImageContainerView"].exists)
    }
}
