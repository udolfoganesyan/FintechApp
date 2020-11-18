//
//  RequestsFactory.swift
//  FintechApp
//
//  Created by Rudolf Oganesyan on 19.11.2020.
//  Copyright © 2020 Рудольф О. All rights reserved.
//

import Foundation

enum RequestsFactory {
    
    enum ImageSourceRequests {
        
        static func harryPotterConfig() -> RequestConfig<ImageSourceParser> { return
            RequestConfig<ImageSourceParser>(request: ImageSourceRequest(searchTheme: .harryPotter),
                                             parser: ImageSourceParser())
        }
        
        static func starWarsConfig() -> RequestConfig<ImageSourceParser> { return
            RequestConfig<ImageSourceParser>(request: ImageSourceRequest(searchTheme: .starWars),
                                             parser: ImageSourceParser())
        }
        
        static func peakyBlindersConfig() -> RequestConfig<ImageSourceParser> { return
            RequestConfig<ImageSourceParser>(request: ImageSourceRequest(searchTheme: .peakyBlinders),
                                             parser: ImageSourceParser())
        }
    }
}
