//
//  WebImagesService.swift
//  FintechApp
//
//  Created by Rudolf Oganesyan on 14.11.2020.
//  Copyright © 2020 Рудольф О. All rights reserved.
//

import Foundation

struct ImageSourceResponse: Codable, Hashable {
    
    let urls: [ImageURL]
    
    enum CodingKeys: String, CodingKey {
        case urls = "hits"
    }
}

struct ImageURL: Codable, Hashable {
    let webformatURL: String
}

protocol WebImagesServiceProtocol {
    func fetchImageSource(completion: @escaping (ImageSourceResponse?) -> Void)
}

final class WebImagesService: WebImagesServiceProtocol {
    
    private let apiKey = "19121692-1bd9206998dd87f9d136ef50a"
    
    func fetchImageSource(completion: @escaping (ImageSourceResponse?) -> Void) {
        guard let url = URL(string: "https://pixabay.com/api/?key=\(apiKey)&q=harry+potter&image_type=photo&per_page=100") else {
            completion(nil)
            return
        }
        let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                if let data = data,
                   (response as? HTTPURLResponse)?.statusCode == 200,
                   error == nil {
                    let forecast = self.parseForecast(from: data)
                    completion(forecast)
                } else {
                    completion(nil)
                }
            }
        }
        dataTask.resume()
    }
    
    private func parseForecast(from data: Data) -> ImageSourceResponse? {
        let decoder = JSONDecoder()
        
        if let response = try? decoder.decode(ImageSourceResponse.self, from: data) {
            return response
        }
        return nil
    }
}
