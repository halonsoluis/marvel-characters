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
    fileprivate static let privateAPIKey = "da9b58ab629e94bb1d66ea165fe1fe92c896ba08"

    fileprivate static let publicAPIKey = "19972fbcfc8ba75736070bc42fbca671"

    fileprivate static func getPaginationConfigFor(page: Int) -> (offset: Int, limit: Int)? {
        return (offset: page * APIHandler.itemsPerPage, limit : APIHandler.itemsPerPage)
    }

    struct SecurityParamsForPage {
        var APIKey: String
        var timeStamp: String
        var hash: String
    }
    struct ParamsForPage {
        var offset: Int
        var limit: Int
        var securytyParams: SecurityParamsForPage
    }
    fileprivate static func getDefaultParamsForPage(_ page: Int = 0) -> ParamsForPage? {
        guard
            let securityData = getSecurityFootprint(),
            let paginationData = getPaginationConfigFor(page: page)
            else { return nil }
        return ParamsForPage(
            offset: paginationData.offset,
            limit: paginationData.limit,
            securytyParams: SecurityParamsForPage(
                APIKey: securityData.APIKey,
                timeStamp: securityData.timeStamp,
                hash: securityData.hash
            )
        )
    }

    static func getDefaultParamsAsDictForPage(_ page: Int = 0) -> [String: String]? {
        guard
            page >= 0,
            let params = getDefaultParamsForPage(page)
        else { return nil }

        return {

            var dict = [String: String]()

            dict["apikey"] = params.securytyParams.APIKey
            dict["hash"]   = params.securytyParams.hash
            dict["ts"]     = params.securytyParams.timeStamp
            dict["limit"]  = params.limit.description
            dict["offset"] = params.offset.description

            return dict
        }()

    }

    static func getSecurityFootprint(_ timestamp: String = Date.timeIntervalSinceReferenceDate.description,
                                     privateAPIKey: String = APIHandler.privateAPIKey,
                                     publicAPIKey: String = APIHandler.publicAPIKey) -> SecurityParamsForPage? {

        guard let hash = MD5Digester.digest("\(timestamp)\(privateAPIKey)\(publicAPIKey)") else { return nil }

        return SecurityParamsForPage(APIKey: APIHandler.publicAPIKey, timeStamp: timestamp, hash: hash)
    }

}
