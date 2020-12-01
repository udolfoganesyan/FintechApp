//
//  CoreAssembly.swift
//  FintechApp
//
//  Created by Rudolf Oganesyan on 13.11.2020.
//  Copyright © 2020 Рудольф О. All rights reserved.
//

import Foundation

protocol CoreAssemblyProtocol {
    var themeCore: ThemeCoreProtocol { get }
    var userDataCore: UserDataCoreProtocol { get }
    var requestSender: RequestSenderProtocol { get }
}

final class CoreAssembly: CoreAssemblyProtocol {
    
    lazy var themeCore: ThemeCoreProtocol = ThemeCore()
    lazy var userDataCore: UserDataCoreProtocol = UserDataCore()
    lazy var requestSender: RequestSenderProtocol = RequestSender()
}
