//
//  APIHandler.swift
//  Marvel Characters
//
//  Created by Hugo Alonso on 5/26/16.
//  Copyright © 2016 halonsoluis. All rights reserved.
//

import Foundation

struct APIHandler {
    private static let itemsPerPage = 20
    
    //This should not be here, here only for debugging and testing purposes
    //This should even not be versionated
    private static let privateAPIKey = "da9b58ab629e94bb1d66ea165fe1fe92c896ba08"
    
    private static let publicAPIKey = "19972fbcfc8ba75736070bc42fbca671"
 
    func getTimeStampAndHash(timestamp: String = NSDate.timeIntervalSinceReferenceDate().description, privateAPIKey : String = APIHandler.privateAPIKey, publicAPIKey: String = APIHandler.publicAPIKey) -> (timeStamp: String, hash: String)? {
        let tuple =  (timeStamp: timestamp, hash: MD5Digester.digest("\(timestamp)\(privateAPIKey)\(publicAPIKey)"))
        
        guard let hash = tuple.hash else { return nil }
        
        return (timeStamp: tuple.timeStamp, hash: hash)
    }
    
    
    
}