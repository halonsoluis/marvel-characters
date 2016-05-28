//
//  MockupNetworking.swift
//  Marvel Characters
//
//  Created by Hugo Alonso on 5/27/16.
//  Copyright © 2016 halonsoluis. All rights reserved.
//

import Foundation

//Mark: Network Access Mockup
struct MockupNetworking {
    static let mockupEnabled = true
    
    private func loadFileData(name:String, ext: String) -> NSData? {
        let bundle = NSBundle.mainBundle()
        
        guard
            let path = bundle.pathForResource(name, ofType: ext) ,
            let data = NSData(contentsOfFile: path) else {
            
            return nil
        }
        return data
    }
    
    
    func getCharactersList()-> NSData? {
        return loadFileData("characterListUnfilteredPage", ext: "json")
    }
    
    func getPostImage()-> NSData? {
        return loadFileData("characterImage", ext: "jpg")
    }
}