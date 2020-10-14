//
//  SaveUserDataOperation.swift
//  FintechApp
//
//  Created by Rudolf Oganesyan on 14.10.2020.
//  Copyright © 2020 Рудольф О. All rights reserved.
//

import UIKit

class FetchUserDataOperation: Operation {
    
    private let userDataStorage = UserDataStorage()
    private var fullName: String?
    private var about: String?
    private var avatarImage: UIImage?
    private var completion: DataManagerCompletion
    
    init(fullName: String?, about: String?, avatarImage: UIImage?, completion: @escaping DataManagerCompletion) {
        self.fullName = fullName
        self.about = about
        self.avatarImage = avatarImage
        self.completion = completion
    }
    
    override func main() {
        userDataStorage.saveUserData(fullName: fullName, about: about, avatarImage: avatarImage) { (success) in
            OperationQueue.main.addOperation {
                self.completion(success)
            }
        }
    }
}
