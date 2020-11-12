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
    var coreDataService: CoreDataServiceProtocol { get }
//    var tracksService: ITracksService { get }
//    var appService: IAppsService { get }
}

final class ServicesAssembly: ServicesAssemblyProtocol {
    
    private let coreAssembly: CoreAssemblyProtocol
    
    lazy var themeService: ThemeServiceProtocol = ThemeService()
    lazy var coreDataService: CoreDataServiceProtocol = CoreDataService(dataModelName: CoreDataService.chatDataModelName)
    
    init(coreAssembly: CoreAssemblyProtocol) {
        self.coreAssembly = coreAssembly
    }
    
//    lazy var tracksService: ITracksService = TracksService(requestSender: self.coreAssembly.requestSender)
//    lazy var appService: IAppsService = AppsService(requestSender: self.coreAssembly.requestSender)
}
