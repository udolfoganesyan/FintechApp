//
//  ConversationInteractor.swift
//  FintechApp
//
//  Created by Rudolf Oganesyan on 13.11.2020.
//  Copyright © 2020 Рудольф О. All rights reserved.
//

import CoreData

protocol ConversationInteractorProtocol {
    var currentTheme: Theme { get }
    
    func fetchMessages(completion: @escaping (FirestoreUpdate<Message>) -> Void)
    func sendMessage(_ message: String, completion: @escaping SuccessCompletion)
    
    var channelTitle: String { get }
    var fetchedResultsController: NSFetchedResultsController<MessageDB> { get }
    func fetchSavedMessages()
    func fetchNewMessagesAndSaveToDB()
}

final class ConversationInteractor: ConversationInteractorProtocol {
    
    private let themeService: ThemeServiceProtocol
    private let firebaseService: FirebaseServiceProtocol
    private let coreDataService: CoreDataServiceProtocol
    private let channel: ChannelDB
    private let channelId: String
    
    private var channelObjectID: NSManagedObjectID {
        channel.objectID
    }
    
    var currentTheme: Theme {
        themeService.currentTheme
    }
    
    var channelTitle: String {
        channel.name
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
    
    lazy var fetchedResultsController: NSFetchedResultsController<MessageDB> = {
        let fetchRequest = MessageDB.defaultSortedFetchRequest
        
        let predicate = NSPredicate(format: "channel == %@", channel)
        fetchRequest.predicate = predicate
        
        fetchRequest.returnsObjectsAsFaults = false
        
        fetchRequest.fetchBatchSize = 45
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: coreDataService.mainContext,
                                             sectionNameKeyPath: "dateForSection",
                                             cacheName: nil)
        return frc
    }()
    
    func fetchSavedMessages() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            Logger.log(error.localizedDescription)
        }
    }
    
    func fetchNewMessagesAndSaveToDB() {
        fetchMessages { [weak self] (messageUpdates) in
            guard let self = self else { return }
            
            self.coreDataService.addMessages(messageUpdates.added, forChannelWith: self.channelObjectID)
        }
    }
}
