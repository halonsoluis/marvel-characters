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
        app.configureSuite()

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testForElementsExistsInViewWithMockup() {
        XCTAssert(app.tables.count == 1)

        XCTAssert(app.tables.cells.count >= 1)

        XCTAssert(app.tables.cells.element(boundBy: 0).buttons.count == 1)
        XCTAssert(app.tables.cells.element(boundBy: 0).images["Character Image"].exists)

        XCTAssert(app.keyboards.count == 0)
    }

    func testForActivityIndicatorExistance() {
        let indicator = app.tables.activityIndicators["In progress"]
         XCTAssert(indicator.exists)
    }

    func testCharacterNameIsDisplayedInCell() {
        let cellButton = app.tables.cells.element(boundBy: 0).buttons.element(boundBy: 0)
        XCTAssert(cellButton.exists)
        XCTAssert(!cellButton.label.isEmpty)
    }

    func testPagination() {

        let cellsQuery = app.tables.children(matching: .cell)
        let numCells = cellsQuery.count

        let table = app.tables.element(boundBy: 0)
        let lastCell = table.cells.element(boundBy: numCells + 5)
        table.scrollToElement(.down, element: lastCell)

        _ = self.expectation(for: NSPredicate(format: "self.count != \(numCells)"), evaluatedWith: cellsQuery, handler: nil)
        self.waitForExpectations(timeout: 5.0, handler: nil)

        let newCells = cellsQuery.count

        XCTAssert(numCells < newCells)
    }

    func testLoadingPagesIndicatorIsNotShown() {
        let tablesQuery = XCUIApplication().tables
        XCTAssert(tablesQuery.activityIndicators["In progress"].exists)

        XCTAssert(!tablesQuery.activityIndicators["In progress"].isHittable)

    }

    func testCorrectCellCountPaginationIsShown() {
        let numCells = app.tables.children(matching: .cell).count
        XCTAssert(numCells == 20)

        let table = app.tables.element(boundBy: 0)
        let lastCell = table.cells.element(boundBy: numCells + 5)
        table.scrollToElement(.down, element: lastCell)

        let newCells = app.tables.children(matching: .cell).count
        XCTAssert(newCells == 40)
    }
}
