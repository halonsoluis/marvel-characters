//
//  CharacterList_UITests.swift
//  Marvel Characters
//
//  Created by Hugo Alonso on 6/4/16.
//  Copyright © 2016 halonsoluis. All rights reserved.
//

import XCTest

class CharacterList_UITests: XCTestCase {
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
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testForElementsExistsInViewWithMockup() {
        XCTAssert(app.tables.count == 1)
        
        XCTAssert(app.tables.cells.count >= 1)
        
        XCTAssert(app.tables.cells.elementBoundByIndex(0).buttons.count == 1)
        XCTAssert(app.tables.cells.elementBoundByIndex(0).images["Character Image"].exists)
        
        XCTAssert(app.keyboards.count == 0)
    }

    func testForActivityIndicatorExistance() {
        let indicator = app.tables.activityIndicators["In progress"]
         XCTAssert(indicator.exists)
    }

    func testCharacterNameIsDisplayedInCell() {
        let cellButton = app.tables.cells.elementBoundByIndex(0).buttons.elementBoundByIndex(0)
        XCTAssert(cellButton.exists)
        XCTAssert(!cellButton.label.isEmpty)
    }

    
    func testNavigatesIntoCharacterDetailsWhenTappingOverCell() {
        XCTAssert(!app.navigationBars["Marvel_Characters.BlurredImageContainerView"].exists)
        
        app.tables.childrenMatchingType(.Cell).elementBoundByIndex(0).tap()
        
        XCTAssert(app.navigationBars["Marvel_Characters.BlurredImageContainerView"].exists)
    }
    
    func testPagination() {

        let cellsQuery = app.tables.childrenMatchingType(.Cell)
        let numCells = cellsQuery.count
        
        app.tables.element.swipeUp()
        app.tables.element.swipeUp()
        app.tables.element.swipeUp()
        app.tables.element.swipeUp()
    
        _ = self.expectationForPredicate(NSPredicate(format: "self.count != \(numCells)"), evaluatedWithObject: cellsQuery, handler: nil)
        self.waitForExpectationsWithTimeout(5.0, handler: nil)
        
        
        let newCells = cellsQuery.count
        
        XCTAssert(numCells < newCells)
    }
    
    func testLoadingPagesIndicatorIsNotShown() {
        let tablesQuery = XCUIApplication().tables
        XCTAssert(tablesQuery.activityIndicators["In progress"].exists)
        
        XCTAssert(!tablesQuery.activityIndicators["In progress"].hittable)
     
    }
    
    func testCorrectCellCountPaginationIsShown() {
        let numCells = app.tables.childrenMatchingType(.Cell).count
        XCTAssert(numCells == 20)
        
        app.tables.element.swipeUp()
        app.tables.element.swipeUp()
        app.tables.element.swipeUp()
        app.tables.element.swipeUp()
        
        let newCells = app.tables.childrenMatchingType(.Cell).count
        XCTAssert(newCells == 40)
    }
}
