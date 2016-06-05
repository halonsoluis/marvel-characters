//
//  CharacterService.swift
//  Marvel Characters
//
//  Created by Hugo on 5/26/16.
//  Copyright © 2016 halonsoluis. All rights reserved.
//

import RxAlamofire
import RxSwift
import ObjectMapper
import RxCocoa
import Result

class NetworkService {
    
    private lazy var rx_params: Observable<[String:String]> = self.getParams()
    
    private var characterName: Observable<String>
    private var currentPage: Observable<Int>
    
    init(withNameObservable nameObservable: Observable<String> = Observable.just(""), pageObservable: Observable<Int>  = Observable.just(0)) {
        self.characterName = nameObservable
        self.currentPage = pageObservable
    }
    
    func getParams() -> Observable<[String:String]> {
        return Observable.combineLatest(characterName, currentPage) { (name, page) -> [String:String] in
            
            var parameters = APIHandler.getDefaultParamsAsDictForPage(page)!
            if !name.isEmpty {
                parameters["nameStartsWith"] = name
            }
            
            print("for name= \(name) and page = \(page). parameters: \n \(parameters.description) \n")
            
            return parameters
        }
    }
    
    func getData<T:MainAPISubject>(route: Routes) -> Driver<Result<[T],RequestError>>  {
        return rx_params
            .subscribeOn(MainScheduler.instance)
            .doOn({ response in
                UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            })
            .flatMapLatest { parameters in
                return RxAPICaller.requestWithParams(parameters, route: route)
            }
            .observeOn(MainScheduler.instance)
            .doOn({ response in
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            })
            .asDriver(onErrorJustReturn: Result.Failure(RequestError.Error("There is some problem with your connection. Please try again.")))
    }
    
}
