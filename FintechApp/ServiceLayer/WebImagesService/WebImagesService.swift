//
//  WebImagesService.swift
//  FintechApp
//
//  Created by Rudolf Oganesyan on 14.11.2020.
//  Copyright © 2020 Рудольф О. All rights reserved.
//

import Foundation

protocol WebImagesServiceProtocol {
    func fetchImageSource(completion: @escaping (ImageSourceModel?) -> Void)
}

final class WebImagesService: WebImagesServiceProtocol {
    
    private let requestSender: RequestSenderProtocol
    
    init(requestSender: RequestSenderProtocol) {
        self.requestSender = requestSender
    }
    
    func fetchImageSource(completion: @escaping (ImageSourceModel?) -> Void) {
        let requestConfig = RequestsFactory.ImageSourceRequests.harryPotterConfig()
        requestSender.send(requestConfig: requestConfig) { (imageSource) in
            DispatchQueue.main.async {
                completion(imageSource)
            }
        }
    }
}
