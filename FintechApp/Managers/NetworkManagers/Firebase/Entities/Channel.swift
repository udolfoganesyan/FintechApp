//
//  Channel.swift
//  FintechApp
//
//  Created by Rudolf Oganesyan on 18.10.2020.
//  Copyright © 2020 Рудольф О. All rights reserved.
//

import FirebaseFirestore

struct Channel: FirestoreSnapshotInitializable {
    
    let identifier: String
    let name: String
    let lastMessage: String?
    let lastActivity: Date?
    
    init?(_ document: QueryDocumentSnapshot) {
        guard let keyedData = document.keyedData() else { return nil }
        guard let name = keyedData[.name] as? String else { return nil }
        self.identifier = document.documentID
        self.name = name
        self.lastMessage = keyedData[.lastMessage] as? String
        self.lastActivity = (keyedData[.lastActivity] as? Timestamp)?.dateValue()
    }
}
