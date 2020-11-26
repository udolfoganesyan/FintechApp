//
//  WebImagesInteractor.swift
//  FintechApp
//
//  Created by Rudolf Oganesyan on 14.11.2020.
//  Copyright © 2020 Рудольф О. All rights reserved.
//

import Foundation

protocol WebImagesInteractorProtocol {
    var currentTheme: Theme { get }
    func getImageURLs(completion: @escaping ([ImageURL]) -> Void)
}

final class WebImagesInteractor: WebImagesInteractorProtocol {
    
    private let themeService: ThemeServiceProtocol
    private let webImagesService: WebImagesServiceProtocol
    
    var currentTheme: Theme {
        themeService.currentTheme
    }
        
    init(themeService: ThemeServiceProtocol, webImagesService: WebImagesServiceProtocol) {
        self.themeService = themeService
        self.webImagesService = webImagesService
    }
    
    func getImageURLs(completion: @escaping ([ImageURL]) -> Void) {
        webImagesService.fetchImageSource { (imageSource) in
            guard let imageSource = imageSource else {
                completion([])
                return
            }

            completion(imageSource.urls)
        }
    }
}
