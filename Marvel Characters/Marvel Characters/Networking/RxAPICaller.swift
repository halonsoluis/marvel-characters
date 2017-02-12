//
//  RxAPICaller.swift
//  Marvel Characters
//
//  Created by Hugo Alonso on 5/27/16.
//  Copyright © 2016 halonsoluis. All rights reserved.
//

import RxSwift
import RxAlamofire
import Result
import ObjectMapper

struct RxAPICaller {
    
    fileprivate static let mockupEnabled : Bool = { return ProcessInfo.processInfo.arguments.contains("MOCKUP_MODE") }()
    
    static func requestWithParams<T:MainAPISubject>(_ parameters: [String:String], route: Routes) -> Observable<Result<[T],RequestError>> {
        
        switch mockupEnabled {
        case true:   return requestMockupData(parameters, route: route)
        case false:  return RxAPICaller.requestNetworkData(parameters, route: route)
        }
    }
    
    static fileprivate func requestMockupData<T:MainAPISubject>(_ parameters: [String:String], route: Routes) -> Observable<Result<[T],RequestError>> {
        
        let buildJSON = { (data:Data)-> Any in
            return try! JSONSerialization.jsonObject(with: data as Data, options: .mutableContainers)
        }
        
        let isCharacter = T.self is MarvelCharacter.Type
        let json = buildJSON(isCharacter ? MockupResource.character.getMockupData()! : MockupResource.crossReference.getMockupData()!)
        
        let box = Mapper<ResponseEnclosure<T>>().map(JSONObject: json)
        let items = box?.data?.results ?? []
        
        return Observable.just(Result.success(items))
    }
    
    fileprivate static func requestNetworkData<T: MainAPISubject>(_ parameters: [String:String], route: Routes) -> Observable<Result<[T],RequestError>> {
        return RxAlamofire
            .requestJSON(.get, route.getRoute(), parameters: parameters)
            .debug()
            .observeOn(MainScheduler.asyncInstance)
            .flatMapLatest{ (response: HTTPURLResponse, json: Any) -> Observable<Result<[T],RequestError>> in
                guard response.statusCode == 200 else {
                    return Observable.just(Result.failure(RequestError.unknown))
                }
                
                let box = Mapper<ResponseEnclosure<T>>().map(JSONObject: json)
                let items = box?.data?.results ?? []
                
                return Observable.just(Result.success(items))
            }
    }
    
}
