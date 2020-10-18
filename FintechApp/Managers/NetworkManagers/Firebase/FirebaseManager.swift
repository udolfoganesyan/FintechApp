//
//  FirebaseManager.swift
//  FintechApp
//
//  Created by Rudolf Oganesyan on 18.10.2020.
//  Copyright © 2020 Рудольф О. All rights reserved.
//

import FirebaseFirestore

public enum FirebaseKeys: String {
    case identifier
    case name
    case lastMessage
    case lastActivityty
    
    case content
    case created
    case senderId
    case senderName
}

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

enum FirebaseManager {
    
    private static let database = Firestore.firestore()
    private static let channelsReference = database.collection("channels")
    
    static func fetchChannels(completion: @escaping ([Channel]) -> Void) {
        channelsReference.getDocuments { (snapshot, error) in
            guard error == nil else {
                return
            }
            guard let snapshot = snapshot else { return }
            
            let documents = snapshot.documents
            let channels = parseChannelsFrom(documents)
            completion(channels)
        }
    }
    
    private static func parseChannelsFrom(_ documents: [QueryDocumentSnapshot]) -> [Channel] {
        var channels = [Channel]()
        for document in documents {
            guard let keyedData = document.keyedData() else { continue }
            guard let name = keyedData[.name] as? String,
                  let identifier = keyedData[.identifier] as? String else { continue }
            var lastMessage: String?
            if let message = keyedData[.lastMessage] as? String {
                lastMessage = message
            }
            var lastActivity: Date?
            if let date = keyedData[.lastActivityty] as? Timestamp {
                lastActivity = date.dateValue()
            }
            let channel = Channel(identifier: identifier,
                                  name: name,
                                  lastMessage: lastMessage,
                                  lastActivity: lastActivity)
            channels.append(channel)
        }
        channels.sort { $0.lastActivity ?? Date() > $1.lastActivity ?? Date() }
        return channels
    }
    
    static func createChannelWith(_ name: String, completion: @escaping SuccessCompletion) {
        let data: [FirebaseKeys: Any?] = [
            FirebaseKeys.name: name,
            FirebaseKeys.identifier: UUID().uuidString,
            FirebaseKeys.lastMessage: nil,
            FirebaseKeys.lastActivityty: Timestamp(date: Date())
        ]
        channelsReference.addDocument(data: data, completion: completion)
    }
}
