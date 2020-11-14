//
//  WebImagesInteractor.swift
//  FintechApp
//
//  Created by Rudolf Oganesyan on 14.11.2020.
//  Copyright © 2020 Рудольф О. All rights reserved.
//

import Foundation

protocol WebImagesInteractorProtocol {
    
}

final class WebImagesInteractor: WebImagesInteractorProtocol {
    
    private let webImagesService: WebImagesServiceProtocol
    
    init(webImagesService: WebImagesServiceProtocol) {
        self.webImagesService = webImagesService
    }
}
