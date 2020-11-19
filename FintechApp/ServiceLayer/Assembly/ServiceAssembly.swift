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
}

final class ServicesAssembly: ServicesAssemblyProtocol {
    
    private let coreAssembly: CoreAssemblyProtocol
    
    lazy var themeService: ThemeServiceProtocol = ThemeService()
    lazy var firebaseService: FirebaseServiceProtocol = FirebaseService()
    lazy var coreDataService: CoreDataServiceProtocol = CoreDataService(dataModelName: CoreDataService.chatDataModelName)
    
    init(coreAssembly: CoreAssemblyProtocol) {
        self.coreAssembly = coreAssembly
    }
}
