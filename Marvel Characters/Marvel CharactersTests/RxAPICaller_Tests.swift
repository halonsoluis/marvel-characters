//
//  RxAPICaller_Tests.swift
//  Marvel Characters
//
//  Created by Hugo Alonso on 6/4/16.
//  Copyright © 2016 halonsoluis. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa

@testable import Marvel_Characters

class RxAPICaller_Tests: XCTestCase {
    
    let disposeBag = DisposeBag()
  
    let params = ["":""] //Params are ignored when in mockup mode
    let characterID = 123 //This is ignored when in mockup mode
    
    var characterListObservable : Observable<Result<[MarvelCharacter],RequestError>>!
    var crossReferenceListObservable : Observable<Result<[CrossReference],RequestError>>!
    
    let errorValidationMarvelCharacter = { (result: Result<[MarvelCharacter],RequestError>) -> Driver<[MarvelCharacter]> in
        switch result {
        case .success(let character):
            return Driver.just(character)
        case .failure(let error):
            XCTAssert(false)
            return Driver.empty()
        }
    }
    
    let errorValidationCrossReference = { (result: Result<[CrossReference],RequestError>) -> Driver<[CrossReference]> in
        switch result {
        case .success(let character):
            return Driver.just(character)
        case .failure(let error):
            XCTAssert(false)
            return Driver.empty()
        }
    }
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        characterListObservable = RxAPICaller.requestWithParams(params, route: Routes.listCharacters)
        
        crossReferenceListObservable = RxAPICaller.requestWithParams(params, route: Routes.listComicsByCharacter(characterID: characterID))
        
    }
    
    func testRequestCharacterListObservable() {
        XCTAssertNotNil(characterListObservable)
        
        characterListObservable
            .flatMapLatest(errorValidationMarvelCharacter)
            .subscribe(onNext: { (characters) in
                XCTAssertNotNil(characters)
                XCTAssertFalse(characters.isEmpty)
                let first = characters.first
                XCTAssertNotNil(first)
                
                XCTAssertNotNil(first?.name)
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)
    }
    
    func testRequestCrossReferenceListObservable() {
        XCTAssertNotNil(crossReferenceListObservable)
        
        crossReferenceListObservable
            .flatMapLatest(errorValidationCrossReference)
            .subscribe(onNext: { (characters) in
                XCTAssertNotNil(characters)
                XCTAssertFalse(characters.isEmpty)
                XCTAssertNotNil(characters.first?.title)
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)
    }
}
