//
//  FirebaseExtensions.swift
//  FintechApp
//
//  Created by Rudolf Oganesyan on 20.10.2020.
//  Copyright © 2020 Рудольф О. All rights reserved.
//

import FirebaseFirestore

typealias KeyedData = [FirebaseKeys: Any]

public extension DocumentSnapshot {
    
    internal func keyedData() -> KeyedData? {
        guard let documentData: [String: Any] = self.data() else {
            return nil
        }
        var data: KeyedData = [:]
        for (key, value) in documentData {
            guard let dbKey: FirebaseKeys = FirebaseKeys(rawValue: key) else {
                continue
            }
            data[dbKey] = value
        }
        return data
    }
}

public extension CollectionReference {
    
    internal func addDocument(data: [FirebaseKeys: Any?], completion: @escaping SuccessCompletion) {
        var documentData: [String: Any] = [:]
        for (key, value) in data {
            documentData[key.rawValue] = value
        }
        addDocument(data: documentData) { (error) in
            let success = error == nil
            completion(success)
        }
    }
}
