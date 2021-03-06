//
//  NetworkServicesTests.swift
//  Marvel Characters
//
//  Created by Hugo Alonso on 6/5/16.
//  Copyright © 2016 halonsoluis. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
import Foundation

@testable import Marvel_Characters

class NetworkServicesTests: XCTestCase {

    let disposeBag = DisposeBag()

    var currentPage = BehaviorRelay<Int>(value: 0)
    var searchText = BehaviorRelay<String>(value: "")

    var chs: NetworkService?

    var rxCharacters: Driver<Result<[MarvelCharacter], RequestError>>?
    var rxCrossReference: Driver<Result<[CrossReference], RequestError>>?

    let characterID = 123 //This is ignored when in mockup mode

    let errorValidationMarvelCharacter = { (result: Result<[MarvelCharacter], RequestError>) -> Driver<[MarvelCharacter]> in
        switch result {
        case .success(let character):
            return Driver.just(character)
        case .failure(let error):
            XCTAssert(false)
            return Driver.empty()
        }
    }

    let errorValidationCrossReference = { (result: Result<[CrossReference], RequestError>) -> Driver<[CrossReference]> in
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
        let currentPageObservable = currentPage
            .asObservable()
            .distinctUntilChanged()
            .filter { $0 >= 0 }

        let currentTextObservable = searchText
            .asObservable()
            .distinctUntilChanged()

        chs = NetworkService(withNameObservable: currentTextObservable, pageObservable: currentPageObservable)

        rxCharacters = chs?.getData(Routes.listCharacters)
        rxCrossReference = chs?.getData(Routes.listComicsByCharacter(characterID: characterID))

    }

    func testRequestCrossReferenceList() {
        XCTAssertNotNil(rxCrossReference)

        rxCrossReference!
            .flatMapLatest(errorValidationCrossReference)
            .drive(onNext: { (newPage) in

                XCTAssertEqual(newPage.count, APIHandler.itemsPerPage)
                XCTAssertNotNil(newPage.first?.title)

            }, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)
    }

    func testRequestCharacterList() {
        XCTAssertNotNil(rxCharacters)

        rxCharacters!
            .flatMapLatest(errorValidationMarvelCharacter)
            .drive(onNext: { (newPage) in

                XCTAssertEqual(newPage.count, APIHandler.itemsPerPage)
                XCTAssertNotNil(newPage.first?.name)

            }, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)

    }
}
