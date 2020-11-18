//
//  OperationUserDataService.swift
//  FintechApp
//
//  Created by Rudolf Oganesyan on 12.10.2020.
//  Copyright © 2020 Рудольф О. All rights reserved.
//

import UIKit

final class OperationUserDataService: UserDataServiceProtocol {
    
    private let userDataCore: UserDataCoreProtocol
    private let operationQueue = OperationQueue()
    
    init(userDataCore: UserDataCoreProtocol) {
        self.userDataCore = userDataCore
    }
    
    func saveUserData(user: User, completion: @escaping BoolClosure) {
        let saveUserDataOperation = SaveUserDataOperation(user: user, userDataCore: userDataCore, completion: completion)
        operationQueue.addOperation(saveUserDataOperation)
    }
    
    func fetchUserData(completion: @escaping FetchUserCompletion) {
        let fetchUserDataOperation = FetchUserDataOperation(userDataCore: userDataCore)
        fetchUserDataOperation.completionBlock = {
            OperationQueue.main.addOperation {
                completion(fetchUserDataOperation.fetchedUser)
            }
        }
        operationQueue.addOperation(fetchUserDataOperation)
    }
}
