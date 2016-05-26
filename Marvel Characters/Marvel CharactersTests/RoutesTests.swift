//
//  RoutesTests.swift
//  Marvel CharactersTests
//
//  Created by Hugo on 5/25/16.
//  Copyright © 2016 halonsoluis. All rights reserved.
//

import XCTest
@testable import Marvel_Characters

class RoutesTests: XCTestCase {
    let characterID = 123123
    
    func testGetRouteListCharacters() {
       XCTAssert(Routes.ListCharacters.getRoute() == "http://gateway.marvel.com:80/v1/public/characters")
    }
    
    func testGetRouteFetchSingleCharacter() {
        XCTAssert(Routes.SingleCharacter.getRoute(characterID) == "http://gateway.marvel.com:80/v1/public/characters/\(characterID)")
    }
    
    func testGetRouteFetchListComicsByCharacter() {
        XCTAssert(Routes.ListComicsByCharacter.getRoute(characterID) == "http://gateway.marvel.com:80/v1/public/characters/\(characterID)/comics")
    }
    
    func testGetRouteFetchListEventsByCharacter() {
        let characterID = 123123
        XCTAssert(Routes.ListEventsByCharacter.getRoute(characterID) == "http://gateway.marvel.com:80/v1/public/characters/\(characterID)/events")
        
    }
    
    func testGetRouteFetchListSeriesByCharacter() {
        XCTAssert(Routes.ListSeriesByCharacter.getRoute(characterID) == "http://gateway.marvel.com:80/v1/public/characters/\(characterID)/series")
    }
    
    func testGetRouteFetchListStoriesByCharacter() {
        XCTAssert(Routes.ListStoriesByCharacter.getRoute(characterID) == "http://gateway.marvel.com:80/v1/public/characters/\(characterID)/stories")
    }
    
    
    func testGetRouteListCharactersNoID() {
        let routes = [ Routes.ListCharacters]
        
        let countNotValid = routes.reduce(0) { $0 + ($1.getRoute() == nil ? 0 : 1) }
        
        XCTAssert(countNotValid == 1)
    }
    
    func testGetRouteCharacterRelatedNoID() {
        
        let routes = [ Routes.SingleCharacter , Routes.ListComicsByCharacter , Routes.ListEventsByCharacter ,Routes.ListSeriesByCharacter , Routes.ListStoriesByCharacter]
        
        let countNotValid = routes.reduce(0) { $0 + ($1.getRoute() == nil ? 0 : 1) }
        
        XCTAssert(countNotValid == 0)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
            let _ = Routes.ListCharacters.getRoute()
        }
    }
    
}
