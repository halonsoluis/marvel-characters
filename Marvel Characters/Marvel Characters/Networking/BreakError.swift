//
//  BreakError.swift
//  Marvel Characters
//
//  Created by Hugo on 5/26/16.
//  Copyright © 2016 halonsoluis. All rights reserved.
//

import Foundation

enum RequestError: ErrorType{
    case Cancelled
    case Timeout
    case Unknown
    case Error(String)
}