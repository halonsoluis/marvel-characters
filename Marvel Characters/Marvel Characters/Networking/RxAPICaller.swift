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
    
    private static let mockupEnabled : Bool = { return NSProcessInfo.processInfo().arguments.contains("MOCKUP_MODE") }()
    
    static func requestWithParams<T:MainAPISubject>(parameters: [String:String], route: Routes) -> Observable<Result<[T],RequestError>> {
        
        switch mockupEnabled {
        case true:   return requestMockupData(parameters, route: route)
        case false:  return RxAPICaller.requestNetworkData(parameters, route: route)
        }
    }
    
    static private func requestMockupData<T:MainAPISubject>(parameters: [String:String], route: Routes) -> Observable<Result<[T],RequestError>> {
        
        let buildJSON = { (data:NSData)-> NSDictionary in
            return try! NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as! NSDictionary
        }
        
        let isCharacter = T.self is MarvelCharacter.Type
        let json = buildJSON(isCharacter ? MockupResource.Character.getMockupData()! : MockupResource.CrossReference.getMockupData()!)
        
        let box = Mapper<ResponseEnclosure<T>>().map(json)
        let items = box?.data?.results ?? []
        
        return Observable.just(Result.Success(items))
    }
    
    private static func requestNetworkData<T: MainAPISubject>(parameters: [String:String], route: Routes) -> Observable<Result<[T],RequestError>> {
        return RxAlamofire
            .requestJSON(.GET, route.getRoute(), parameters: parameters)
            .debug()
            .observeOn(ConcurrentDispatchQueueScheduler(globalConcurrentQueueQOS: .Background))
            .flatMapLatest { (response: NSHTTPURLResponse, json: AnyObject) -> Observable<Result<[T],RequestError>> in
                
                guard response.statusCode == 200 else {
                    return Observable.just(Result.Failure(RequestError.Unknown))
                }
                
                let box = Mapper<ResponseEnclosure<T>>().map(json)
                let items = box?.data?.results ?? []
                
                return Observable.just(Result.Success(items))
        }
        
    }
    
}