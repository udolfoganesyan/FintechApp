//
//  FirebaseManager.swift
//  FintechApp
//
//  Created by Rudolf Oganesyan on 18.10.2020.
//  Copyright © 2020 Рудольф О. All rights reserved.
//

import FirebaseFirestore

public enum FirebaseKeys: String {
    case channels
    case messages
    
    case identifier
    case name
    case lastMessage
    case lastActivity
    
    case content
    case created
    case senderId
    case senderName
}

enum FirebaseManager {
    
    static let myId = UIDevice.current.identifierForVendor?.uuidString
    
    private static let database = Firestore.firestore()
    private static let channelsReference = database.collection(FirebaseKeys.channels.rawValue)
    
    static func fetchChannels(completion: @escaping ([Channel]) -> Void) {
        channelsReference.addSnapshotListener { (snapshot, error) in
            guard error == nil else { return }
            guard let snapshot = snapshot else { return }
            
            let documents = snapshot.documents
            let channels = parseChannelsFrom(documents)
            completion(channels)
        }
    }
    
    private static func parseChannelsFrom(_ documents: [QueryDocumentSnapshot]) -> [Channel] {
        var channels = documents.compactMap { Channel($0) }
        channels.sort { $0.lastActivity ?? Date() > $1.lastActivity ?? Date() }
        return channels
    }
    
    static func createChannelWith(_ name: String, completion: @escaping SuccessCompletion) {
        let data: [FirebaseKeys: Any?] = [
            FirebaseKeys.name: name,
            FirebaseKeys.lastMessage: nil,
            FirebaseKeys.lastActivity: nil
        ]
        channelsReference.addDocument(data: data, completion: completion)
    }
    
    static func fetchMessagesFor(_ channelId: String, completion: @escaping ([Message]) -> Void) {
        channelsReference.document(channelId).collection(FirebaseKeys.messages.rawValue).addSnapshotListener { (snapshot, error) in
            guard error == nil else { return }
            guard let snapshot = snapshot else { return }
            
            let documents = snapshot.documents
            let messages = parseMessagesFrom(documents)
            completion(messages)
        }
    }
    
    private static func parseMessagesFrom(_ documents: [QueryDocumentSnapshot]) -> [Message] {
        var messages = documents.compactMap { Message($0) }
        messages.sort { $0.created < $1.created }
        return messages
    }
    
    static func sendMessage(_ message: String, to channelId: String, completion: @escaping SuccessCompletion) {
        let data: [FirebaseKeys: Any?] = [
            FirebaseKeys.content: message,
            FirebaseKeys.created: Timestamp(),
            FirebaseKeys.senderId: myId,
            FirebaseKeys.senderName: "Rudolf"
        ]
        
        channelsReference.document(channelId).collection(FirebaseKeys.messages.rawValue).addDocument(data: data, completion: completion)
    }
}
