//
//  ProfileInteractor.swift
//  FintechApp
//
//  Created by Rudolf Oganesyan on 13.11.2020.
//  Copyright © 2020 Рудольф О. All rights reserved.
//

import Foundation

enum UserDataServiceType {
    case gcd
    case operation
}

protocol ProfileInteractorProtocol {
    var currentTheme: Theme { get }
    func setServiceType(_ type: UserDataServiceType)
    func saveUserData(user: User, completion: @escaping SuccessCompletion)
    func fetchUserData(completion: @escaping FetchUserCompletion)
}

final class ProfileInteractor: ProfileInteractorProtocol {
    
    private var serviceTypeToUse: UserDataServiceType = .gcd
    
    let themeService: ThemeServiceProtocol
    let gcdUserDataService: UserDataServiceProtocol
    let operationUserDataService: UserDataServiceProtocol
    
    var currentTheme: Theme {
        themeService.currentTheme
    }
    
    init(themeService: ThemeServiceProtocol, gcdUserDataService: UserDataServiceProtocol, operationUserDataService: UserDataServiceProtocol) {
        self.themeService = themeService
        self.gcdUserDataService = gcdUserDataService
        self.operationUserDataService = operationUserDataService
    }
    
    func setServiceType(_ type: UserDataServiceType) {
        serviceTypeToUse = type
    }
    
    func saveUserData(user: User, completion: @escaping SuccessCompletion) {
        switch serviceTypeToUse {
        case .gcd:
            gcdUserDataService.saveUserData(user: user, completion: completion)
        case .operation:
            operationUserDataService.saveUserData(user: user, completion: completion)
        }
    }
    
    func fetchUserData(completion: @escaping FetchUserCompletion) {
        switch serviceTypeToUse {
        case .gcd:
            gcdUserDataService.fetchUserData(completion: completion)
        case .operation:
            operationUserDataService.fetchUserData(completion: completion)
        }
    }
}
