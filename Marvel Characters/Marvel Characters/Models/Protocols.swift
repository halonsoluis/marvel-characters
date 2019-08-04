//
//  Protocols.swift
//  Marvel Characters
//
//  Created by Hugo on 5/26/16.
//  Copyright © 2016 halonsoluis. All rights reserved.
//

protocol ImageLocatorDelegate: class {
    func url() -> String?
}

protocol MainAPISubject: Codable { }
