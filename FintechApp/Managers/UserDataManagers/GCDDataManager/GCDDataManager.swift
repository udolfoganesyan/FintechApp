//
//  GCDDataManager.swift
//  FintechApp
//
//  Created by Rudolf Oganesyan on 12.10.2020.
//  Copyright © 2020 Рудольф О. All rights reserved.
//

import UIKit

typealias FetchUserCompletion = (User) -> Void

protocol AsyncDataManager {
    func saveUserData(user: User, completion: @escaping SuccessCompletion)
    func fetchUserData(completion: @escaping FetchUserCompletion)
}

struct GCDDataManager: AsyncDataManager {
    
    private let userDataStorage = UserDataStorage()
    private let storageQueue = DispatchQueue(label: "com.rudolf.FintechApp.storage")
    
    func saveUserData(user: User, completion: @escaping SuccessCompletion) {
        storageQueue.async {
            userDataStorage.saveUserData(user: user) { (success) in
                DispatchQueue.main.async {
                    completion(success)
                }
            }
        }
    }
    
    func fetchUserData(completion: @escaping FetchUserCompletion) {
        storageQueue.async {
            let fullName = userDataStorage.getFullName()
            let about = userDataStorage.getAbout()
            let image = userDataStorage.getAvatar()
            let user = User(fullName: fullName, about: about, image: image)
            DispatchQueue.main.async {
                completion(user)
            }
        }
    }
}
