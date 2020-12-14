//
//  ServiceAssembly.swift
//  FintechApp
//
//  Created by Rudolf Oganesyan on 13.11.2020.
//  Copyright © 2020 Рудольф О. All rights reserved.
//

import Foundation

protocol ServicesAssemblyProtocol {
    var themeService: ThemeServiceProtocol { get }
    var firebaseService: FirebaseServiceProtocol { get }
    var coreDataService: CoreDataServiceProtocol { get }
    var gcdUserDataService: UserDataServiceProtocol { get }
    var operationUserDataService: UserDataServiceProtocol { get }
    var webImagesService: WebImagesServiceProtocol { get }
}

final class ServicesAssembly: ServicesAssemblyProtocol {
    
    private let coreAssembly: CoreAssemblyProtocol
    
    lazy var themeService: ThemeServiceProtocol = ThemeService(themeCore: coreAssembly.themeCore)
    lazy var firebaseService: FirebaseServiceProtocol = FirebaseService()
    lazy var coreDataService: CoreDataServiceProtocol = CoreDataService(dataModelName: CoreDataService.chatDataModelName)
    lazy var gcdUserDataService: UserDataServiceProtocol = GCDUserDataService(userDataCore: coreAssembly.userDataCore)
    lazy var operationUserDataService: UserDataServiceProtocol = OperationUserDataService(userDataCore: coreAssembly.userDataCore)
    lazy var webImagesService: WebImagesServiceProtocol = WebImagesService(requestSender: coreAssembly.requestSender)
    
    init(coreAssembly: CoreAssemblyProtocol) {
        self.coreAssembly = coreAssembly
    }
}
