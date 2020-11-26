//
//  UserDataServiceProtocol.swift
//  FintechApp
//
//  Created by Rudolf Oganesyan on 14.11.2020.
//  Copyright © 2020 Рудольф О. All rights reserved.
//

import Foundation

typealias FetchUserCompletion = (User) -> Void

protocol UserDataServiceProtocol {
    func saveUserData(user: User, completion: @escaping BoolClosure)
    func fetchUserData(completion: @escaping FetchUserCompletion)
}
