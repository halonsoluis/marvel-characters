//
//  CharacterService.swift
//  Marvel Characters
//
//  Created by Hugo on 5/26/16.
//  Copyright © 2016 halonsoluis. All rights reserved.
//

import RxAlamofire
import RxSwift
import RxCocoa

class NetworkService {

    fileprivate lazy var rx_params: Observable<[String: String]> = self.getParams()

    fileprivate var characterName: Observable<String>
    fileprivate var currentPage: Observable<Int>

    init(withNameObservable nameObservable: Observable<String> = Observable.just(""), pageObservable: Observable<Int>  = Observable.just(0)) {
        self.characterName = nameObservable
        self.currentPage = pageObservable
    }

    fileprivate func getParams() -> Observable<[String: String]> {
        return Observable.combineLatest(characterName, currentPage) { (name, page) -> [String: String] in

            var parameters = APIHandler.getDefaultParamsAsDictForPage(page)!
            if !name.isEmpty {
                parameters["nameStartsWith"] = name
            }

            print("for name= \(name) and page = \(page). parameters: \n \(parameters.description) \n")

            return parameters
        }
    }

    func getData<T: MainAPISubject>(_ route: Routes) -> Driver<Result<[T], RequestError>> {
        return rx_params
            .subscribeOn(MainScheduler.instance)
            .do(onNext: { (_) in
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            }, onError: nil, onCompleted: nil, onSubscribe: nil, onDispose: nil)
            .flatMapLatest { parameters in
                return RxAPICaller.requestWithParams(parameters, route: route)
            }
            .observeOn(MainScheduler.instance)
            .do(onNext: { (_) in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }, onError: nil, onCompleted: nil, onSubscribe: nil, onDispose: nil)
            .asDriver(onErrorJustReturn: Result.failure(RequestError.error("There is some problem with your connection. Please try again.")))
    }

}
