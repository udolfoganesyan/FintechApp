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
    
    static func fetchChannels(completion: @escaping (FirestoreUpdate<Channel>) -> Void) {
        channelsReference.addSnapshotListener { (snapshot, error) in
            guard error == nil else { return }
            guard let snapshot = snapshot else { return }
            
            let documentChanges = snapshot.documentChanges
            let channelUpdates = FirestoreUpdate<Channel>(documentChanges: documentChanges)
            completion(channelUpdates)
        }
    }
    
    static func createChannelWith(_ name: String, completion: @escaping SuccessCompletion) {
        let data: [FirebaseKeys: Any?] = [
            FirebaseKeys.name: name,
            FirebaseKeys.lastMessage: nil,
            FirebaseKeys.lastActivity: nil
        ]
        channelsReference.addDocument(data: data, completion: completion)
    }
    
    static func deleteChannelWith(channelId: String, completion: @escaping SuccessCompletion) {
        channelsReference.document(channelId).delete { (error) in
            let success = error == nil
            completion(success)
        }
    }
    
    static func fetchMessagesFor(_ channelId: String, completion: @escaping (FirestoreUpdate<Message>) -> Void) {
        channelsReference.document(channelId).collection(FirebaseKeys.messages.rawValue).addSnapshotListener { (snapshot, error) in
            guard error == nil else { return }
            guard let snapshot = snapshot else { return }
            
            let documentChanges = snapshot.documentChanges
            let messageUpdates = FirestoreUpdate<Message>(documentChanges: documentChanges)
            completion(messageUpdates)
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
