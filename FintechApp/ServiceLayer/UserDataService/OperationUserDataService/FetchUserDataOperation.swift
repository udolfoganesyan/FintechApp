//
//  SaveUserDataOperation.swift
//  FintechApp
//
//  Created by Rudolf Oganesyan on 14.10.2020.
//  Copyright © 2020 Рудольф О. All rights reserved.
//

import UIKit

final class FetchUserDataOperation: Operation {
    
    var fetchedUser = User(fullName: nil, about: nil, image: nil)
    
    private let userDataCore: UserDataCoreProtocol
    
    init(userDataCore: UserDataCoreProtocol) {
        self.userDataCore = userDataCore
    }
    
    override func main() {
        fetchedUser = userDataCore.fetchUserData()
    }
}
