//
//  OperationDataManager.swift
//  FintechApp
//
//  Created by Rudolf Oganesyan on 12.10.2020.
//  Copyright © 2020 Рудольф О. All rights reserved.
//

import UIKit

struct OperationDataManager: AsyncDataManager {
    
    private let operationQueue = OperationQueue()
    
    func saveUserData(user: User, completion: @escaping SuccessCompletion) {
        
        let saveUserDataOperation = SaveUserDataOperation(user: user, completion: completion)
        operationQueue.addOperation(saveUserDataOperation)
    }
    
    func fetchUserData(completion: @escaping FetchUserCompletion) {
        
        let fetchUserDataOperation = FetchUserDataOperation()
        fetchUserDataOperation.completionBlock = {
            OperationQueue.main.addOperation {
                completion(fetchUserDataOperation.fetchedUser)
            }
        }
        operationQueue.addOperation(fetchUserDataOperation)
    }
}
