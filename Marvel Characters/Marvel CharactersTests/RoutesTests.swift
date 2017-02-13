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
       XCTAssert(Routes.listCharacters.getRoute() == "http://gateway.marvel.com:80/v1/public/characters")
    }
    
    func testGetRouteFetchSingleCharacter() {
        XCTAssert(Routes.singleCharacter(characterID: characterID).getRoute() == "http://gateway.marvel.com:80/v1/public/characters/\(characterID)")
    }
    
    func testGetRouteFetchListComicsByCharacter() {
        XCTAssert(Routes.listComicsByCharacter(characterID: characterID).getRoute() == "http://gateway.marvel.com:80/v1/public/characters/\(characterID)/comics")
    }
    
    func testGetRouteFetchListEventsByCharacter() {
        XCTAssert(Routes.listEventsByCharacter(characterID: characterID).getRoute() == "http://gateway.marvel.com:80/v1/public/characters/\(characterID)/events")
     }
    
    func testGetRouteFetchListSeriesByCharacter() {
        XCTAssert(Routes.listSeriesByCharacter(characterID: characterID).getRoute() == "http://gateway.marvel.com:80/v1/public/characters/\(characterID)/series")
    }
    
    func testGetRouteFetchListStoriesByCharacter() {
        XCTAssert(Routes.listStoriesByCharacter(characterID: characterID).getRoute() == "http://gateway.marvel.com:80/v1/public/characters/\(characterID)/stories")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
            let _ = Routes.listCharacters.getRoute()
        }
    }
    
}
