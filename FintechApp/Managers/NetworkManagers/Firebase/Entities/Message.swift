//
//  Message.swift
//  FintechApp
//
//  Created by Rudolf Oganesyan on 18.10.2020.
//  Copyright © 2020 Рудольф О. All rights reserved.
//

import FirebaseFirestore

struct Message {
    
    let identifier: String
    let content: String
    let created: Date
    let senderId: String
    let senderName: String
    
    init?(_ document: QueryDocumentSnapshot) {
        guard let keyedData = document.keyedData() else { return nil }
        guard let content = keyedData[.content] as? String,
              let created = keyedData[.created] as? Timestamp,
              let senderId = keyedData[.senderId] as? String,
              let senderName = keyedData[.senderName] as? String else { return nil }
        self.identifier = document.documentID
        self.content = content
        self.created = created.dateValue()
        self.senderId = senderId
        self.senderName = senderName
    }
}
