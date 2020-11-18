//
//  FirebaseService.swift
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

protocol FirebaseServiceProtocol {
    func fetchChannels(completion: @escaping (FirestoreUpdate<Channel>) -> Void)
    func createChannelWith(_ name: String, completion: @escaping BoolClosure)
    func deleteChannelWith(channelId: String, completion: @escaping BoolClosure)
    func fetchMessagesFor(_ channelId: String, completion: @escaping (FirestoreUpdate<Message>) -> Void)
    func sendMessage(_ message: String, to channelId: String, completion: @escaping BoolClosure)
}

final class FirebaseService: FirebaseServiceProtocol {
    
    static let myId = UIDevice.current.identifierForVendor?.uuidString
    
    private let database = Firestore.firestore()
    private lazy var channelsReference = database.collection(FirebaseKeys.channels.rawValue)
    
    func fetchChannels(completion: @escaping (FirestoreUpdate<Channel>) -> Void) {
        channelsReference.addSnapshotListener { (snapshot, error) in
            guard error == nil else { return }
            guard let snapshot = snapshot else { return }
            
            let documentChanges = snapshot.documentChanges
            let channelUpdates = FirestoreUpdate<Channel>(documentChanges: documentChanges)
            completion(channelUpdates)
        }
    }
    
    func createChannelWith(_ name: String, completion: @escaping BoolClosure) {
        let data: [FirebaseKeys: Any?] = [
            FirebaseKeys.name: name,
            FirebaseKeys.lastMessage: nil,
            FirebaseKeys.lastActivity: nil
        ]
        channelsReference.addDocument(data: data, completion: completion)
    }
    
    func deleteChannelWith(channelId: String, completion: @escaping BoolClosure) {
        channelsReference.document(channelId).delete { (error) in
            let success = error == nil
            completion(success)
        }
    }
    
    func fetchMessagesFor(_ channelId: String, completion: @escaping (FirestoreUpdate<Message>) -> Void) {
        channelsReference.document(channelId).collection(FirebaseKeys.messages.rawValue).addSnapshotListener { (snapshot, error) in
            guard error == nil else { return }
            guard let snapshot = snapshot else { return }
            
            let documentChanges = snapshot.documentChanges
            let messageUpdates = FirestoreUpdate<Message>(documentChanges: documentChanges)
            completion(messageUpdates)
        }
    }
    
    func sendMessage(_ message: String, to channelId: String, completion: @escaping BoolClosure) {
        let data: [FirebaseKeys: Any?] = [
            FirebaseKeys.content: message,
            FirebaseKeys.created: Timestamp(),
            FirebaseKeys.senderId: FirebaseService.myId,
            FirebaseKeys.senderName: "Rudolf"
        ]
        channelsReference.document(channelId).collection(FirebaseKeys.messages.rawValue).addDocument(data: data, completion: completion)
    }
}
