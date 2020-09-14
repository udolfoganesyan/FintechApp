//
//  Logger.swift
//  FintechApp
//
//  Created by Rudolf Oganesyan on 13.09.2020.
//  Copyright © 2020 Рудольф О. All rights reserved.
//

import Foundation

struct Logger {
    
    // in case we dont need logs even in debug mode
    static let isOn = true
    
    static func log(message: String) {
        #if DEBUG
        if isOn {
            print(message, "\n")
        }
        #endif
    }
}
