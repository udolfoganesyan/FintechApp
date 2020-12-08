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
    private var url: URL? {
        let queryItems = query.compactMap { URLQueryItem(name: $0, value: $1) }
        let sortedQueryItems = queryItems.sorted(by: { $0.name < $1.name })
        var comps = URLComponents(string: baseUrl)
        comps?.queryItems = sortedQueryItems
        return comps?.url
    }
    
    var urlRequest: URLRequest? {
        guard let url = url else { return nil }
        return URLRequest(url: url)
    }
    
    init(searchTheme: SearchTheme) {
        self.searchTheme = searchTheme
    }
}
