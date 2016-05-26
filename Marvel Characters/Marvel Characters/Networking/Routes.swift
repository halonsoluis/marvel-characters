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
enum Routes : String {
    
    private static let baseURL = "http://gateway.marvel.com:80"
    private static let apiSubURL = "/v1/public/"
    private static let characterIdPlaceHolder = "{characterId}"
    
    //Fetches lists of characters.
    case ListCharacters = "characters"
    
    //Fetches a single character by id.
    case SingleCharacter = "characters/{characterId}"
    
    //Fetches lists of comics filtered by a character id.
    case ListComicsByCharacter = "characters/{characterId}/comics"
 
    //Fetches lists of events filtered by a character id.
    case ListEventsByCharacter = "characters/{characterId}/events"
  
    //Fetches lists of series filtered by a character id.
    case ListSeriesByCharacter = "characters/{characterId}/series"
  
    //Fetches lists of stories filtered by a character id.
    case ListStoriesByCharacter = "characters/{characterId}/stories"
    
    func getRoute(characterID: Int? = nil ) -> String? {
        let characterID = characterID?.description ?? ""
        
        //If there's no id entered then only valid is the first call
        guard self == .ListCharacters || !characterID.isEmpty else { return nil }
  
        return Routes.baseURL + Routes.apiSubURL + self.rawValue.stringByReplacingOccurrencesOfString(Routes.characterIdPlaceHolder, withString: characterID)
    }
}