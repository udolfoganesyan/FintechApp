//
//  MockRequestSender.swift
//  FintechAppTests
//
//  Created by Rudolf Oganesyan on 02.12.2020.
//  Copyright © 2020 Рудольф О. All rights reserved.
//

import Foundation
@testable import FintechApp

final class MockRequestSender: RequestSenderProtocol {
    
    var urlRequest: URLRequest?
    var callsCounter = 0
    
    func send<Parser>(requestConfig config: RequestConfig<Parser>, completion: @escaping (Parser.Model?) -> Void) where Parser: ParserProtocol {
        urlRequest = config.request.urlRequest
        callsCounter += 1
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(40)) {
            completion(nil)
        }
    }
}
