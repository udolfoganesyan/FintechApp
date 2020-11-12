//
//  ConversationModel.swift
//  FintechApp
//
//  Created by Rudolf Oganesyan on 13.11.2020.
//  Copyright © 2020 Рудольф О. All rights reserved.
//

import CoreData

protocol ConversationModelProtocol {
    var currentTheme: Theme { get }
    
    func fetchMessages(completion: @escaping (FirestoreUpdate<Message>) -> Void)
    func sendMessage(_ message: String, completion: @escaping SuccessCompletion)
    
    var title: String { get }
    var channelId: String { get }
    var channelObjectID: NSManagedObjectID { get }
    func addMessages(_ messages: [Message], forChannelWith objectID: NSManagedObjectID)
    func fetchedResultsController(delegate: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController<MessageDB>
}

final class ConversationModel: ConversationModelProtocol {
    
    private let channel: ChannelDB
    private let themeService: ThemeServiceProtocol
    private let firebaseService: FirebaseServiceProtocol
    private let coreDataService: CoreDataServiceProtocol
    
    let channelId: String
    
    var currentTheme: Theme {
        themeService.currentTheme
    }
    
    var title: String {
        channel.name
    }
    
    var channelObjectID: NSManagedObjectID {
        channel.objectID
    }
    
    init(themeService: ThemeServiceProtocol, firebaseService: FirebaseServiceProtocol, coreDataService: CoreDataServiceProtocol, channel: ChannelDB) {
        self.themeService = themeService
        self.firebaseService = firebaseService
        self.coreDataService = coreDataService
        self.channel = channel
        self.channelId = channel.identifier
    }
    
    func fetchMessages(completion: @escaping (FirestoreUpdate<Message>) -> Void) {
        firebaseService.fetchMessagesFor(channelId, completion: completion)
    }
    
    func sendMessage(_ message: String, completion: @escaping SuccessCompletion) {
        firebaseService.sendMessage(message, to: channelId, completion: completion)
    }
    
    func addMessages(_ messages: [Message], forChannelWith objectID: NSManagedObjectID) {
        coreDataService.addMessages(messages, forChannelWith: objectID)
    }
    
    func fetchedResultsController(delegate: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController<MessageDB> {
        let fetchRequest = MessageDB.defaultSortedFetchRequest
        
        let predicate = NSPredicate(format: "channel == %@", channel)
        fetchRequest.predicate = predicate
        
        fetchRequest.returnsObjectsAsFaults = false
        
        fetchRequest.fetchBatchSize = 45
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: coreDataService.mainContext,
                                             sectionNameKeyPath: "dateForSection",
                                             cacheName: nil)
        frc.delegate = delegate
        return frc
    }
}
