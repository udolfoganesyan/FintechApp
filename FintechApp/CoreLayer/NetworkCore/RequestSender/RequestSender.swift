//
//  RequestSender.swift
//  FintechApp
//
//  Created by Rudolf Oganesyan on 18.11.2020.
//  Copyright © 2020 Рудольф О. All rights reserved.
//

import Foundation

final class RequestSender: RequestSenderProtocol {
    
    private let session = URLSession.shared
    
    func send<Parser>(requestConfig config: RequestConfig<Parser>, completion: @escaping (Parser.Model?) -> Void) where Parser: ParserProtocol {
        guard let urlRequest = config.request.urlRequest else {
            completion(nil)
            return
        }
        
        let task = session.dataTask(with: urlRequest) { (data, _, error) in
            guard error == nil,
                  let data = data,
                  let parsedModel: Parser.Model = config.parser.parse(data: data) else {
                completion(nil)
                return
            }
            
            completion(parsedModel)
        }
        task.resume()
    }
}
