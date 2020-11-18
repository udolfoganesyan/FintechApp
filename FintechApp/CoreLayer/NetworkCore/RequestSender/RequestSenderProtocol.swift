//
//  RequestSenderProtocol.swift
//  FintechApp
//
//  Created by Rudolf Oganesyan on 18.11.2020.
//  Copyright © 2020 Рудольф О. All rights reserved.
//

import Foundation

struct RequestConfig<Parser> where Parser: ParserProtocol {
    let request: RequestProtocol
    let parser: Parser
}

protocol RequestSenderProtocol {
    func send<Parser>(requestConfig config: RequestConfig<Parser>, completion: @escaping(Parser.Model?) -> Void)
}
