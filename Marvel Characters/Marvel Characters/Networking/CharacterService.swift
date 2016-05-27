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

class CharacterService {
    
   func getCharacters(pageNumber : Int = 0) -> Driver<Result<[Character],RequestError>>  {
    
        let route = Routes.ListCharacters.getRoute()!
        let parameters = APIHandler().getDefaultParamsAsDictForPage(pageNumber)
        
        return RxAlamofire
            .requestJSON(.GET, route, parameters: parameters)
            .debug()
            .observeOn(ConcurrentDispatchQueueScheduler(globalConcurrentQueueQOS: .Background))
            .flatMapLatest { (response: NSHTTPURLResponse, json: AnyObject) -> Observable<Result<[Character],RequestError>> in
                
                guard response.statusCode == 200 else {
                    return Observable.just(Result.Failure(RequestError.Unknown))
                }
                
                let charactersBox = Mapper<ResponseEnclosure<Character>>().map(json)!
                let characters = charactersBox.data?.results ?? []
                
                return Observable.just(Result.Success(characters))
            }
            .asDriver(onErrorJustReturn: Result.Failure(RequestError.Error("There is some problem with your connection. Please try again.")))
    }
}
