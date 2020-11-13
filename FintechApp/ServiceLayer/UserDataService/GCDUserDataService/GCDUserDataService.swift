//
//  GCDUserDataService.swift
//  FintechApp
//
//  Created by Rudolf Oganesyan on 12.10.2020.
//  Copyright © 2020 Рудольф О. All rights reserved.
//

import UIKit

final class GCDUserDataService: UserDataServiceProtocol {
    
    private let userDataCore: UserDataCoreProtocol
    private let storageQueue = DispatchQueue(label: "com.rudolf.FintechApp.storage")
    
    init(userDataCore: UserDataCoreProtocol) {
        self.userDataCore = userDataCore
    }
    
    func saveUserData(user: User, completion: @escaping SuccessCompletion) {
        storageQueue.async {
            self.userDataCore.saveUserData(user: user) { (success) in
                DispatchQueue.main.async {
                    completion(success)
                }
            }
        }
    }
    
    func fetchUserData(completion: @escaping FetchUserCompletion) {
        storageQueue.async {
            let user = self.userDataCore.fetchUserData()
            DispatchQueue.main.async {
                completion(user)
            }
        }
    }
}
