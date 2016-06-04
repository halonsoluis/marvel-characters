//
//  MockupNetworking.swift
//  Marvel Characters
//
//  Created by Hugo Alonso on 5/27/16.
//  Copyright © 2016 halonsoluis. All rights reserved.
//

import Foundation


var mockupEnabled = true

//Mark: Network Access Mockup
enum MockupResource {
    case Image, CrossReference, Character
    
    func getMockupData() -> NSData? {
        let locator : (path:String, ext: String)!
        switch self  {
        case .CrossReference: locator = (path: "collectionResponsePage", ext: "json")
        case .Character: locator = (path: "characterListUnfilteredPage", ext: "json")
        case .Image: locator = (path: "characterImage", ext: "jpg")
        }
        return loadFileData(locator.path, ext: locator.ext)
    }
    
    private func loadFileData(name:String, ext: String) -> NSData? {
        let bundle = NSBundle.mainBundle()
        
        guard
            let path = bundle.pathForResource(name, ofType: ext) ,
            let data = NSData(contentsOfFile: path) else {
                
                return nil
        }
        return data
    }
}