//
//  MockupNetworking.swift
//  Marvel Characters
//
//  Created by Hugo Alonso on 5/27/16.
//  Copyright © 2016 halonsoluis. All rights reserved.
//

import Foundation

// MARK: Network Access Mockup
enum MockupResource {
    case image, crossReference, character

    func getMockupData() -> Data? {
        let locator : (path: String, ext: String)!
        switch self {
        case .crossReference: locator = (path: "collectionResponsePage", ext: "json")
        case .character: locator = (path: "characterListUnfilteredPage", ext: "json")
        case .image: locator = (path: "characterImage", ext: "jpg")
        }
        return loadFileData(locator.path, ext: locator.ext)
    }

    fileprivate func loadFileData(_ name: String, ext: String) -> Data? {
        let bundle = Bundle.main

        guard
            let path = bundle.path(forResource: name, ofType: ext) ,
            let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {

                return nil
        }
        return data
    }
}
