//
//  GCDDataManager.swift
//  FintechApp
//
//  Created by Rudolf Oganesyan on 12.10.2020.
//  Copyright © 2020 Рудольф О. All rights reserved.
//

import UIKit

protocol AsyncDataManager {
    func saveUserData(fullName: String?, about: String?, avatarImage: UIImage?, completion: @escaping DataManagerCompletion)
}

struct GCDDataManager: AsyncDataManager {
    
    private let userDataStorage = UserDataStorage()
    
    func saveUserData(fullName: String?, about: String?, avatarImage: UIImage?, completion: @escaping DataManagerCompletion) {
        let storageQueue = DispatchQueue(label: "com.rudolf.FintechApp.storage", attributes: .concurrent)
        storageQueue.async {
            userDataStorage.saveUserData(fullName: fullName, about: about, avatarImage: avatarImage) { (success) in
                DispatchQueue.main.async {
                    completion(success)
                }
            }
        }
    }
}
