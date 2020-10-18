//
//  SaveUserDataOperation.swift
//  FintechApp
//
//  Created by Rudolf Oganesyan on 13.10.2020.
//  Copyright © 2020 Рудольф О. All rights reserved.
//

import UIKit

class SaveUserDataOperation: Operation {
    
    private let userDataStorage = UserDataStorage()
    private var user: User
    private var completion: SuccessCompletion
    
    init(user: User, completion: @escaping SuccessCompletion) {
        self.user = user
        self.completion = completion
    }
    
    override func main() {
        userDataStorage.saveUserData(user: user) { (success) in
            OperationQueue.main.addOperation {
                self.completion(success)
            }
        }
    }
}
