//
//  RxAPICaller_Tests.swift
//  Marvel Characters
//
//  Created by Hugo Alonso on 6/4/16.
//  Copyright © 2016 halonsoluis. All rights reserved.
//

import XCTest
import RxSwift
import Result
import RxCocoa
import ObjectMapper

@testable import Marvel_Characters

class RxAPICaller_Tests: XCTestCase {
    
    let disposeBag = DisposeBag()
  
    let params = ["":""] //Params are ignored when in mockup mode
    let characterID = 123 //This is ignored when in mockup mode
    
    
    var characterListObservable : Observable<Result<[MarvelCharacter],RequestError>>!
    var crossReferenceListObservable : Observable<Result<[CrossReference],RequestError>>!
    
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
        characterListObservable = RxAPICaller.requestWithParams(params, route: Routes.ListCharacters)
        
        crossReferenceListObservable = RxAPICaller.requestWithParams(params, route: Routes.ListComicsByCharacter(characterID: characterID))
        
    }
    
    func testRequestCharacterListObservable() {
        XCTAssertNotNil(characterListObservable)
        
        characterListObservable
            .flatMapLatest(errorValidationMarvelCharacter)
            .subscribeNext { (characters) in
                XCTAssertNotNil(characters)
                XCTAssertFalse(characters.isEmpty)
                let first = characters.first
                XCTAssertNotNil(first)
                
                XCTAssertNotNil(first?.name)
            }.addDisposableTo(disposeBag)
    }
    
    func testRequestCrossReferenceListObservable() {
        XCTAssertNotNil(crossReferenceListObservable)
        
        crossReferenceListObservable
            .flatMapLatest(errorValidationCrossReference)
            .subscribeNext { (characters) in
                XCTAssertNotNil(characters)
                XCTAssertFalse(characters.isEmpty)
                XCTAssertNotNil(characters.first?.title)
            }.addDisposableTo(disposeBag)
    }
    
    func testPerformanceRequestCrossReferenceListObservable() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
            self.crossReferenceListObservable
                .flatMapLatest(self.errorValidationCrossReference)
                .subscribeNext { (_) in
                }.addDisposableTo(self.disposeBag)
        }
    }
    
    func testPerformanceRequestCharacterListObservableCreation() {
        // This is an example of a performance test case.
        self.measureBlock {
            self.characterListObservable = RxAPICaller.requestWithParams(self.params, route: Routes.ListCharacters)
        }
    }
    func testPerformanceRequestCrossReferenceListObservableCreation() {
        // This is an example of a performance test case.
        self.measureBlock {
            self.crossReferenceListObservable = RxAPICaller.requestWithParams(self.params, route: Routes.ListComicsByCharacter(characterID: 123))
        }
    }
    
    func testPerformanceRequestCharacterListObservable() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
            self.characterListObservable
                .flatMapLatest(self.errorValidationMarvelCharacter)
                .subscribeNext { (_) in
                }.addDisposableTo(self.disposeBag)
        }
    }
}
