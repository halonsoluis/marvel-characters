//
//  LargeViewCrossCollectionsUITests.swift
//  Marvel Characters
//
//  Created by Hugo Alonso on 6/4/16.
//  Copyright © 2016 halonsoluis. All rights reserved.
//

import XCTest

class LargeViewCrossCollectionsUITests: XCTestCase {
    let app = XCUIApplication()

    override func setUp() {
        super.setUp()

        app.configureSuite()

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        app.tables.children(matching: .cell).element(boundBy: 0).tap()

        app.collectionViews.cells.element(boundBy: 0).tap()
    }

    func testLargeViewOpensInSelectedItemFromDetailView() {
        app.buttons["icn nav close white"].tap()

        let cell = app.collectionViews.element(boundBy: 0).cells.element(boundBy: 1)

        let selectedName = cell.staticTexts["SmallReferenceName"].label

        cell.tap()

        let largeImageName = app.collectionViews.staticTexts["CrossReferenceName"].label

        XCTAssertTrue(selectedName == largeImageName)
    }

//    func testCollectionIsPaginable() {
//        
//        //  app.buttons["icn nav close white"].tap()
//        let collections = app.collectionViews
//        let collection = app.collectionViews.element
//        
//        let firstCellName = collections.staticTexts["CrossReferenceName"]
//        XCTAssertTrue(firstCellName.exists)
//        
//        let text = firstCellName.label
//        print("Cell text = \(text)")
//        
//        var foundAgain = false
//        
//        collection.swipeLeft()
//        collection.swipeLeft()
//        
//        let cellCount = collections.cells.count
//        
//        for _ in 1..<26 {
//            let newCells = collections.staticTexts.matchingIdentifier("CrossReferenceName")
//            let textPredicate = NSPredicate(format: "self.count == 1")
//            expectationForPredicate(textPredicate, evaluatedWithObject: newCells, handler: nil)
//            self.waitForExpectationsWithTimeout(5.0, handler: nil)
//            
//            
//            let text1 = newCells.element.label
//            print("Cell in cicle text = \(text1)")
//            if firstCellName == text1 {
//                foundAgain = true
//                break
//            }
//            
//            app.swipeLeft()
//        }
//        
//        let newCellCount = collections.cells.count
//        
//        XCTAssertTrue(cellCount < newCellCount)
//    }
}
