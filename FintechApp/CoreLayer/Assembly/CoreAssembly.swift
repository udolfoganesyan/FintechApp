//
//  CoreAssembly.swift
//  FintechApp
//
//  Created by Rudolf Oganesyan on 13.11.2020.
//  Copyright © 2020 Рудольф О. All rights reserved.
//

import Foundation

protocol CoreAssemblyProtocol {
    var userDataCore: UserDataCoreProtocol { get }
}

final class CoreAssembly: CoreAssemblyProtocol {
    
    lazy var userDataCore: UserDataCoreProtocol = UserDataCore()
}
