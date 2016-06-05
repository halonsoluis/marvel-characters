//
//  NetworkServicesTests.swift
//  Marvel Characters
//
//  Created by Hugo Alonso on 6/5/16.
//  Copyright © 2016 halonsoluis. All rights reserved.
//

import XCTest
import RxSwift
import Result
import RxCocoa
import ObjectMapper
import Foundation

@testable import Marvel_Characters

class NetworkServicesTests: XCTestCase {
    
    let disposeBag = DisposeBag()
    
    var currentPage = Variable<Int>(0)
    var searchText = Variable<String>("")
    
    var chs : NetworkService?
    
    var rx_characters: Driver<Result<[MarvelCharacter],RequestError>>?
    var rx_crossReference: Driver<Result<[CrossReference],RequestError>>?
    
    let characterID = 123 //This is ignored when in mockup mode
   
    let errorValidationMarvelCharacter = { (result: Result<[MarvelCharacter],RequestError>) -> Driver<[MarvelCharacter]> in
        switch result {
        case .Success(let character):
            return Driver.just(character)
        case .Failure(let error):
            XCTAssert(false)
            return Driver.empty()
        }
    }
    
    let errorValidationCrossReference = { (result: Result<[CrossReference],RequestError>) -> Driver<[CrossReference]> in
        switch result {
        case .Success(let character):
            return Driver.just(character)
        case .Failure(let error):
            XCTAssert(false)
            return Driver.empty()
        }
    }
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mockupEnabled = true
        
        let currentPageObservable = currentPage
            .asObservable()
            .distinctUntilChanged()
            .filter { $0 >= 0 }
        
        let currentTextObservable = searchText
            .asObservable()
            .distinctUntilChanged()
        
        
        chs = NetworkService(withNameObservable: currentTextObservable, pageObservable: currentPageObservable)
        
        rx_characters = chs?.getData(Routes.ListCharacters)
        rx_crossReference = chs?.getData(Routes.ListComicsByCharacter(characterID: characterID))
        
    }
    
    func testRequestCrossReferenceList() {
        XCTAssertNotNil(rx_crossReference)
        
        rx_crossReference!
            .flatMapLatest(errorValidationCrossReference)
            .driveNext { (newPage) in
                
                XCTAssertEqual(newPage.count, APIHandler.itemsPerPage)
                XCTAssertNotNil(newPage.first?.title)
            }
            .addDisposableTo(disposeBag)
    }
    
    func testRequestCharacterList() {
        XCTAssertNotNil(rx_characters)
        
        rx_characters!
            .flatMapLatest(errorValidationMarvelCharacter)
            .driveNext { (newPage) in
                XCTAssertEqual(newPage.count, APIHandler.itemsPerPage)
                XCTAssertNotNil(newPage.first?.name)

            }
            .addDisposableTo(disposeBag)

    }
}

