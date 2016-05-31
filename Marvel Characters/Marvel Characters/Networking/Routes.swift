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
    
    private static let baseURL = "http://gateway.marvel.com:80"
    private static let apiSubURL = "/v1/public/"
    private static let characterIdPlaceHolder = "{characterId}"
    //Fetches lists of characters.
    case ListCharacters
    
    //Fetches a single character by id.
    case SingleCharacter(characterID:Int)
    
    //Fetches lists of comics filtered by a character id.
    case ListComicsByCharacter(characterID:Int)
    
    //Fetches lists of events filtered by a character id.
    case ListEventsByCharacter(characterID:Int)
    
    //Fetches lists of series filtered by a character id.
    case ListSeriesByCharacter(characterID:Int)
    
    //Fetches lists of stories filtered by a character id.
    case ListStoriesByCharacter(characterID:Int)
    
    func getRoute() -> String {
        return Routes.baseURL + Routes.apiSubURL + getGenericAPIPath()
    }
    
    private func getGenericAPIPath() -> String {
        switch self {
        case ListCharacters: return "characters"
            
        //Fetches a single character by id.
        case let .SingleCharacter(characterID): return "characters/\(characterID)"
            
        //Fetches lists of comics filtered by a character id.
        case let .ListComicsByCharacter(characterID): return "characters/\(characterID)/comics"
            
        //Fetches lists of events filtered by a character id.
        case let .ListEventsByCharacter(characterID): return "characters/\(characterID)/events"
            
        //Fetches lists of series filtered by a character id.
        case let .ListSeriesByCharacter(characterID): return "characters/\(characterID)/series"
            
        //Fetches lists of stories filtered by a character id.
        case let .ListStoriesByCharacter(characterID): return "characters/\(characterID)/stories"
            
        }
    }
}