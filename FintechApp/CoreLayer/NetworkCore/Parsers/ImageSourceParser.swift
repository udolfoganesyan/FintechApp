//
//  ImageSourceParser.swift
//  FintechApp
//
//  Created by Rudolf Oganesyan on 18.11.2020.
//  Copyright © 2020 Рудольф О. All rights reserved.
//

import Foundation

struct ImageSourceModel: Codable, Hashable {
    
    let urls: [ImageURL]
    
    enum CodingKeys: String, CodingKey {
        case urls = "hits"
    }
}

struct ImageURL: Codable, Hashable {
    let webformatURL: String
}

final class ImageSourceParser: ParserProtocol {

    func parse(data: Data) -> ImageSourceModel? {
        let decoder = JSONDecoder()
        
        if let response = try? decoder.decode(ImageSourceModel.self, from: data) {
            return response
        }
        return nil
    }
}
