//
//  RxAPICaller.swift
//  Marvel Characters
//
//  Created by Hugo Alonso on 5/27/16.
//  Copyright © 2016 halonsoluis. All rights reserved.
//

import Foundation
import RxSwift
import RxAlamofire
import Result
import ObjectMapper

struct RxAPICaller {
    static func requestWithParams(parameters: [String:String], route: Routes) -> Observable<Result<[Character],RequestError>> {
        
        guard !MockupNetworking.mockupEnabled else {
            let json = RxAPICaller.buildJSON(MockupNetworking().getCharactersList()!)
            let charactersBox = Mapper<ResponseEnclosure<Character>>().map(json)
            let characters = charactersBox?.data?.results ?? []
            
            return Observable.just(Result.Success(characters))
        }
        return RxAPICaller.requestCharactersWithParams(parameters, route: route)
    }
    
    static private func buildJSON(data:NSData) -> NSDictionary {
        return try! NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as! NSDictionary
    }
    
    private static func requestCharactersWithParams(parameters: [String:String], route: Routes = Routes.ListCharacters) -> Observable<Result<[Character],RequestError>> {
        return RxAlamofire
            .requestJSON(.GET, route.getRoute()!, parameters: parameters)
            .debug()
            .observeOn(ConcurrentDispatchQueueScheduler(globalConcurrentQueueQOS: .Background))
            .flatMapLatest { (response: NSHTTPURLResponse, json: AnyObject) -> Observable<Result<[Character],RequestError>> in
                
                guard response.statusCode == 200 else {
                    return Observable.just(Result.Failure(RequestError.Unknown))
                }
                
                let charactersBox = Mapper<ResponseEnclosure<Character>>().map(json)
                let characters = charactersBox?.data?.results ?? []
                
                return Observable.just(Result.Success(characters))
        }
        
    }
}