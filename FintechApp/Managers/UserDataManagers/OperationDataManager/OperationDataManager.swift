//
//  OperationDataManager.swift
//  FintechApp
//
//  Created by Rudolf Oganesyan on 12.10.2020.
//  Copyright © 2020 Рудольф О. All rights reserved.
//

import UIKit

class OperationDataManager: AsyncDataManager {
    
    func saveUserData(fullName: String?, about: String?, avatarImage: UIImage?, completion: @escaping DataManagerCompletion) {
        
        let saveUserDataOperation = SaveUserDataOperation(fullName: fullName, about: about, avatarImage: avatarImage, completion: completion)
        let operationQueue = OperationQueue()
        operationQueue.addOperation(saveUserDataOperation)
    }
    
    func fetchUserData() {
        
    }
}
