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
    static func requestWithParams<T:Mappable>(parameters: [String:String], route: Routes) -> Observable<Result<[T],RequestError>> {
        let isCharacter = T.self is Character.Type
        guard !mockupEnabled else {
            let json = RxAPICaller.buildJSON(isCharacter ? MockupResource.Character.getMockupData()! : MockupResource.CrossReference.getMockupData()!)
            let box = Mapper<ResponseEnclosure<T>>().map(json)
            let items = box?.data?.results ?? []
            
            return Observable.just(Result.Success(items))
        }
        return RxAPICaller.requestItemWithParams(parameters, route: route)
    }
    
    static private func buildJSON(data:NSData) -> NSDictionary {
        return try! NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as! NSDictionary
    }
   
    private static func requestItemWithParams<T: Mappable>(parameters: [String:String], route: Routes) -> Observable<Result<[T],RequestError>> {
        return RxAlamofire
            .requestJSON(.GET, route.getRoute()!, parameters: parameters)
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