//
//  SaveUserDataOperation.swift
//  FintechApp
//
//  Created by Rudolf Oganesyan on 13.10.2020.
//  Copyright © 2020 Рудольф О. All rights reserved.
//

import UIKit

final class SaveUserDataOperation: Operation {
    
    private let userDataCore: UserDataCoreProtocol
    private let user: User
    private let completion: SuccessCompletion
    
    init(user: User, userDataCore: UserDataCoreProtocol, completion: @escaping SuccessCompletion) {
        self.user = user
        self.userDataCore = userDataCore
        self.completion = completion
    }
    
    override func main() {
        userDataCore.saveUserData(user: user) { (success) in
            OperationQueue.main.addOperation {
                self.completion(success)
            }
        }
    }
}
