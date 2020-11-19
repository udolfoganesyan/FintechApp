//
//  CoreDataService.swift
//  FintechApp
//
//  Created by Rudolf Oganesyan on 27.10.2020.
//  Copyright © 2020 Рудольф О. All rights reserved.
//

import CoreData

protocol CoreDataServiceProtocol {
    var mainContext: NSManagedObjectContext { get }
    func addOrUpdateChannels(_ channels: [Channel])
    func deleteChannels(_ channels: [Channel])
    func addMessages(_ messages: [Message], forChannelWith objectID: NSManagedObjectID)
}

final class CoreDataService: CoreDataServiceProtocol {
    
    static let chatDataModelName = "Chat"
    
    var didUpdateDataBase: ((CoreDataService) -> Void)?
    
    private let dataModelName: String
    
    private lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: dataModelName)
        container.loadPersistentStores { (_, error) in
            if let error = error as NSError? {
                Logger.log("Unresolved error \(error), \(error.userInfo)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    lazy var mainContext: NSManagedObjectContext = {
        return self.storeContainer.viewContext
    }()
    
    init(dataModelName: String) {
        self.dataModelName = dataModelName
        enableObservers()
    }
    
    func performSave(_ block: @escaping (NSManagedObjectContext) -> Void) {
        storeContainer.performBackgroundTask { (context) in
            context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            block(context)
            if context.hasChanges {
                do {
                    try self.performSave(in: context)
                } catch {
                    assertionFailure(error.localizedDescription)
                }
            }
        }
    }
    
    private func performSave(in context: NSManagedObjectContext) throws {
        try context.save()
        if let parent = context.parent {
            try performSave(in: parent)
        }
    }
    
    func addOrUpdateChannels(_ channels: [Channel]) {
        performSave { (context) in
            channels.forEach {
                let fetchRequest: NSFetchRequest<ChannelDB> = ChannelDB.fetchRequest()
                let predicate = NSPredicate(format: "identifier = %@", $0.identifier)
                fetchRequest.predicate = predicate
                do {
                    let channelsDB = try context.fetch(fetchRequest)
                    if let channel = channelsDB.first {                    channel.setValue($0.lastActivity, forKey: "lastActivity")
                        channel.setValue($0.lastMessage, forKey: "lastMessage")
                        channel.setValue($0.name, forKey: "name")
                    } else {
                        _ = ChannelDB(channel: $0, context: context)
                    }
                } catch {
                    Logger.log(error.localizedDescription)
                }
            }
        }
    }
    
    func deleteChannels(_ channels: [Channel]) {
        performSave { (context) in
            channels.forEach {
                let fetchRequest: NSFetchRequest<ChannelDB> = ChannelDB.fetchRequest()
                let predicate = NSPredicate(format: "identifier = %@", $0.identifier)
                fetchRequest.predicate = predicate
                do {
                    let channelsDB = try context.fetch(fetchRequest)
                    guard let channelToDelete = channelsDB.first else { return }
                    context.delete(channelToDelete)
                } catch {
                    Logger.log(error.localizedDescription)
                }
            }
        }
    }
    
    func addMessages(_ messages: [Message], forChannelWith objectID: NSManagedObjectID) {
        performSave { (context) in
            guard let channelToAddMessages = context.object(with: objectID) as? ChannelDB else { return }
            
            let messagesDB = messages.map { MessageDB(message: $0, context: context) }
            let setOfMessagesToAdd = NSOrderedSet(array: messagesDB)
            channelToAddMessages.addToMessages(setOfMessagesToAdd)
        }
    }
    
    func enableObservers() {
        let notificationsCenter = NotificationCenter.default
        notificationsCenter.addObserver(self,
                                        selector: #selector(handleMOCdidChange),
                                        name: .NSManagedObjectContextObjectsDidChange,
                                        object: mainContext)
    }
    
    @objc private func handleMOCdidChange(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        
        Logger.log("something changed in database")
        
        didUpdateDataBase?(self)
        
        if let inserts = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject> {
            Logger.log("Added: \(inserts.count)")
        }
        if let updates = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject> {
            Logger.log("Updated: \(updates.count)")
        }
        if let deletes = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject> {
            Logger.log("Added: \(deletes.count)")
        }
    }
}
