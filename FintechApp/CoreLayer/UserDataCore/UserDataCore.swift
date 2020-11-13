//
//  UserDataCore.swift
//  FintechApp
//
//  Created by Rudolf Oganesyan on 14.11.2020.
//  Copyright © 2020 Рудольф О. All rights reserved.
//

import UIKit

typealias SuccessCompletion = (_ success: Bool) -> Void

protocol UserDataCoreProtocol {
    func saveUserData(user: User, completion: @escaping SuccessCompletion)
    func fetchUserData() -> User
}

enum UserDataStorageError: Error {
    case writingError
}

final class UserDataCore: UserDataCoreProtocol {
    
    private var fullNameFileURL: URL {
        getDocumentsDirectory().appendingPathComponent("name.txt")
    }
    private var aboutFileURL: URL {
        getDocumentsDirectory().appendingPathComponent("about.txt")
    }
    private var avatarFileURL: URL {
        getDocumentsDirectory().appendingPathComponent("avatar.jpeg")
    }
    
    func saveUserData(user: User, completion: @escaping SuccessCompletion) {
        
        do {
            if let fullName = user.fullName {
                try saveFullName(fullName)
            }
            if let about = user.about {
                try saveAbout(about)
            }
            if let avatarImage = user.image {
                try saveAvatarImage(avatarImage)
            }
            completion(true)
        } catch {
            completion(false)
        }
    }
    
    private func saveFullName(_ fullName: String) throws {
        
        do {
            try fullName.write(to: fullNameFileURL, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            throw UserDataStorageError.writingError
        }
    }
    
    private func saveAbout(_ about: String) throws {
        
        do {
            try about.write(to: aboutFileURL, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            throw UserDataStorageError.writingError
        }
    }
    
    private func saveAvatarImage(_ image: UIImage) throws {
        guard let data = image.jpegData(compressionQuality: 0.8) else {
            throw UserDataStorageError.writingError
        }
        
        do {
            try data.write(to: avatarFileURL)
        } catch {
            throw UserDataStorageError.writingError
        }
    }
    
    func fetchUserData() -> User {
        let fullName = getFullName()
        let about = getAbout()
        let image = getAvatar()
        let user = User(fullName: fullName, about: about, image: image)
        return user
    }
    
    private func getFullName() -> String? {
        
        do {
            let fullNameData = try Data(contentsOf: fullNameFileURL)
            
            if let fullNameString = String(data: fullNameData, encoding: .utf8) {
                return fullNameString
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }
    
    private func getAbout() -> String? {
        
        do {
            let aboutData = try Data(contentsOf: aboutFileURL)
            
            if let aboutString = String(data: aboutData, encoding: .utf8) {
                return aboutString
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }
    
    private func getAvatar() -> UIImage? {
        
        do {
            let avatarData = try Data(contentsOf: avatarFileURL)
            
            if let avatarImage = UIImage(data: avatarData) {
                return avatarImage
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
