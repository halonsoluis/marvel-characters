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
        app.launchArguments.append("MOCKUP_MODE")
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app.launch()
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        
        characterName = app.tables.cells.elementBoundByIndex(0).buttons.elementBoundByIndex(0).label
        
        app.tables.childrenMatchingType(.Cell).elementBoundByIndex(0).tap()
        
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
    }
    
    func testStatusBarIsPresent(){
        let statusBarsQuery = XCUIApplication().statusBars.element
        XCTAssertTrue(statusBarsQuery.exists)
        XCTAssertTrue(statusBarsQuery.hittable)
    }
    
    func testCharacterNameIsShownOnDetails() {
        let detailTexts = app.staticTexts[characterName]
        XCTAssertTrue(detailTexts.exists)
    }
    
    func testShowOnlyDataAvailableForMarvelCharacter() {
        
        let tablesQuery = app.tables
        let collectionsQuery = app.collectionViews
        
        //The mockup for current character '3D-Man' has stories, events, comics and series related
        let numberOfScrolls = collectionsQuery.count
        
        app.navigationBars["Marvel_Characters.BlurredImageContainerView"].childrenMatchingType(.Button).matchingIdentifier("Back").elementBoundByIndex(1).tap()
        
        tablesQuery.childrenMatchingType(.Cell).elementBoundByIndex(1).tap()
        
        //The mockup for current character 'A-Bomb (HAS)' has no related collections
        let numberOfScrollsSecond = collectionsQuery.count
        
        XCTAssertTrue(numberOfScrolls > numberOfScrollsSecond)
    }
    
//    func testCrossReferenceArePaginable() {
//        
//        let collectionsQuery = app.collectionViews
//        
//        XCTAssertTrue(collectionsQuery.count == 4)
//        
//        let comics = collectionsQuery.elementBoundByIndex(0)
//        
//        let series = collectionsQuery.elementBoundByIndex(1)
//        
//        let stories = collectionsQuery.elementBoundByIndex(2)
//        
//        let events = collectionsQuery.elementBoundByIndex(3)
//        
//        let comicCellCount = comics.cells.count
//        let seriesCellCount = series.cells.count
//        let storiesCellCount = stories.cells.count
//        let eventsCellCount = events.cells.count
//        
//        app.staticTexts[characterName].scrollToElement(.Down, element: comics)
//        
//        //comics.scrollToElement(.Right, element: comics.cells.elementBoundByIndex(comicCellCount))
//        comics.swipeInDirection(.Right, times: 4)
//        XCTAssertTrue(comicCellCount < comics.cells.count)
//        
//        comics.scrollToElement(.Down, element: series)
//        
//        //series.scrollToElement(.Right, element: series.cells.elementBoundByIndex(seriesCellCount))
//        series.swipeInDirection(.Right, times: 4)
//        
//        XCTAssertTrue(seriesCellCount < series.cells.count)
//        
//        series.scrollToElement(.Down, element: stories)
//        
//        //stories.scrollToElement(.Right, element: stories.cells.elementBoundByIndex(storiesCellCount))
//        stories.swipeInDirection(.Right, times: 4)
//        XCTAssertTrue(storiesCellCount < stories.cells.count)
//        
//        stories.scrollToElement(.Down, element: events)
//        
//        //events.scrollToElement(.Right, element: events.cells.elementBoundByIndex(eventsCellCount))
//        events.swipeInDirection(.Right, times: 4)
//        XCTAssertTrue(eventsCellCount < events.cells.count)
//    }
}
