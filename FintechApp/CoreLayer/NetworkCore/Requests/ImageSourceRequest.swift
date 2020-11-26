//
//  ImageSourceRequest.swift
//  FintechApp
//
//  Created by Rudolf Oganesyan on 18.11.2020.
//  Copyright © 2020 Рудольф О. All rights reserved.
//

import Foundation

final class ImageSourceRequest: RequestProtocol {
    
    enum SearchTheme: String {
        case harryPotter = "harry+potter"
        case starWars = "star+wars"
        case peakyBlinders = "peaky+blinders"
    }
    
    private let baseUrl = "https://pixabay.com/api/"
    private let apiKey = "19121692-1bd9206998dd87f9d136ef50a"
    private let searchTheme: SearchTheme
    private var query: [String: String] {
        return ["key": apiKey,
                "q": searchTheme.rawValue,
                "image_type": "photo",
                "per_page": "100"]
    }
    private var urlString: String {
        let getParams = query.compactMap({ "\($0.key)=\($0.value)"}).joined(separator: "&")
        return baseUrl + "?" + getParams
    }
    
    var urlRequest: URLRequest? {
        if let url = URL(string: urlString) {
            return URLRequest(url: url)
        }
        return nil
    }
    
    init(searchTheme: SearchTheme) {
        self.searchTheme = searchTheme
    }
}
