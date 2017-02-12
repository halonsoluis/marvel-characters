//
//  Routes.swift
//  Marvel Characters
//
//  Created by Hugo Alonso on 5/25/16.
//  Copyright © 2016 halonsoluis. All rights reserved.
//

/**
 Store all the URLs used for networking requests
 
 */
enum Routes {
    
    fileprivate static let baseURL = "http://gateway.marvel.com:80"
    fileprivate static let apiSubURL = "/v1/public/"
    fileprivate static let characterIdPlaceHolder = "{characterId}"
    //Fetches lists of characters.
    case listCharacters
    
    //Fetches a single character by id.
    case singleCharacter(characterID:Int)
    
    //Fetches lists of comics filtered by a character id.
    case listComicsByCharacter(characterID:Int)
    
    //Fetches lists of events filtered by a character id.
    case listEventsByCharacter(characterID:Int)
    
    //Fetches lists of series filtered by a character id.
    case listSeriesByCharacter(characterID:Int)
    
    //Fetches lists of stories filtered by a character id.
    case listStoriesByCharacter(characterID:Int)
    
    func getRoute() -> String {
        return Routes.baseURL + Routes.apiSubURL + getGenericAPIPath()
    }
    
    fileprivate func getGenericAPIPath() -> String {
        switch self {
        case .listCharacters: return "characters"
            
        //Fetches a single character by id.
        case let .singleCharacter(characterID): return "characters/\(characterID)"
            
        //Fetches lists of comics filtered by a character id.
        case let .listComicsByCharacter(characterID): return "characters/\(characterID)/comics"
            
        //Fetches lists of events filtered by a character id.
        case let .listEventsByCharacter(characterID): return "characters/\(characterID)/events"
            
        //Fetches lists of series filtered by a character id.
        case let .listSeriesByCharacter(characterID): return "characters/\(characterID)/series"
            
        //Fetches lists of stories filtered by a character id.
        case let .listStoriesByCharacter(characterID): return "characters/\(characterID)/stories"
            
        }
    }
}
