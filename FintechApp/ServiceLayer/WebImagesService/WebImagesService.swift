//
//  WebImagesService.swift
//  FintechApp
//
//  Created by Rudolf Oganesyan on 14.11.2020.
//  Copyright © 2020 Рудольф О. All rights reserved.
//

import Foundation

protocol WebImagesServiceProtocol {
    func fetchImageSource(theme: ImageSourceRequest.SearchTheme, completion: @escaping (ImageSourceModel?) -> Void)
}

final class WebImagesService: WebImagesServiceProtocol {
    
    private let requestSender: RequestSenderProtocol
    
    init(requestSender: RequestSenderProtocol) {
        self.requestSender = requestSender
    }
    
    func fetchImageSource(theme: ImageSourceRequest.SearchTheme, completion: @escaping (ImageSourceModel?) -> Void) {
        
        let requestConfig = getRequestConfigFor(theme: theme)
        requestSender.send(requestConfig: requestConfig) { (imageSource) in
            DispatchQueue.main.async {
                completion(imageSource)
            }
        }
    }
    
    private func getRequestConfigFor(theme: ImageSourceRequest.SearchTheme) -> RequestConfig<ImageSourceParser> {
        switch theme {
        case .harryPotter:
            return RequestsFactory.ImageSourceRequests.harryPotterConfig()
        case .starWars:
            return RequestsFactory.ImageSourceRequests.starWarsConfig()
        case .peakyBlinders:
            return RequestsFactory.ImageSourceRequests.peakyBlindersConfig()
        }
    }
}
