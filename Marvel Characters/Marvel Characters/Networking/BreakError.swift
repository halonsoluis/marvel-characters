//
//  BreakError.swift
//  Marvel Characters
//
//  Created by Hugo on 5/26/16.
//  Copyright © 2016 halonsoluis. All rights reserved.
//

import Foundation

enum RequestError: Error{
    case cancelled
    case timeout
    case unknown
    case error(String)
}
