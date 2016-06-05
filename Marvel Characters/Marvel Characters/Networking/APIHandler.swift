//
//  APIHandler.swift
//  Marvel Characters
//
//  Created by Hugo Alonso on 5/26/16.
//  Copyright © 2016 halonsoluis. All rights reserved.
//

import Foundation


struct APIHandler {
    
    static let itemsPerPage = 20
    
    //This should not be here, here only for debugging and testing purposes
    //This should not have being versionated
    private static let privateAPIKey = "da9b58ab629e94bb1d66ea165fe1fe92c896ba08"
    
    private static let publicAPIKey = "19972fbcfc8ba75736070bc42fbca671"
    
    private static func getPaginationConfigFor(page page: Int) -> (offset: Int, limit : Int)? {
        guard page >= 0 else {return nil }
        return (offset: page * APIHandler.itemsPerPage, limit : APIHandler.itemsPerPage)
    }
    
    private static func getDefaultParamsForPage(page: Int = 0) -> (offset: Int, limit : Int, APIKey: String, timeStamp: String, hash: String)?{
        guard
            let securityData = getSecurityFootprint(),
            let paginationData = getPaginationConfigFor(page: page)
            else { return nil }
        return (offset: paginationData.offset, limit : paginationData.limit, securityData.APIKey, timeStamp: securityData.timeStamp, hash: securityData.hash)
    }
    
    static func getDefaultParamsAsDictForPage(page: Int = 0) -> [String:String]? {
        guard let params = getDefaultParamsForPage(page) else { return nil }
        
        return {
            
            var dict = [String:String]()
            
            dict["apikey"] = params.APIKey
            dict["hash"]   = params.hash
            dict["ts"]     = params.timeStamp
            dict["limit"]  = params.limit.description
            dict["offset"] = params.offset.description
            
            return dict
        }()
        
    }
    
    static func getSecurityFootprint(timestamp: String = NSDate.timeIntervalSinceReferenceDate().description, privateAPIKey : String = APIHandler.privateAPIKey, publicAPIKey: String = APIHandler.publicAPIKey) -> (timeStamp: String, hash: String, APIKey: String)? {
        let tuple =  (timeStamp: timestamp, hash: MD5Digester.digest("\(timestamp)\(privateAPIKey)\(publicAPIKey)"))
        
        guard let hash = tuple.hash else { return nil }
        
        return (timeStamp: tuple.timeStamp, hash: hash, APIKey: APIHandler.publicAPIKey)
    }
    
}