//
//  CoreDataManager.swift
//  FintechApp
//
//  Created by Rudolf Oganesyan on 27.10.2020.
//  Copyright © 2020 Рудольф О. All rights reserved.
//

import CoreData

final class CoreDataManager {
    
    var didUpdateDataBase: ((CoreDataManager) -> Void)?
    
    private var storeUrl: URL = {
        guard let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
            fatalError("Documents path not found")
        }
        Logger.log(documentsUrl.appendingPathComponent("Chat.sqlite").absoluteString)
        return documentsUrl.appendingPathComponent("Chat.sqlite")
    }()
    
    private let dataModelName = "Chat"
    private let dataModelExtension = "momd"
    
    init() {
        enableObservers()
    }
    
    private(set) lazy var managedObjectModel: NSManagedObjectModel = {
        guard let modelUrl = Bundle.main.url(forResource: self.dataModelName, withExtension: self.dataModelExtension) else {
            fatalError("model not found")
        }
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelUrl) else {
            fatalError("could not create mom")
        }
        return managedObjectModel
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                               configurationName: nil,
                                               at: self.storeUrl,
                                               options: nil)
        } catch {
            fatalError(error.localizedDescription)
        }
        return coordinator
    }()
    
    private lazy var writerContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = persistentStoreCoordinator
        context.mergePolicy = NSOverwriteMergePolicy
        return context
    }()
    
    private(set) lazy var mainContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.parent = writerContext
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        return context
    }()
    
    private func saveContext() -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = mainContext
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }
    
    func performSave(_ block: @escaping (NSManagedObjectContext) -> Void) {
        let context = saveContext()
        context.perform {
            block(context)
            if context.hasChanges {
                do {
                    try context.obtainPermanentIDs(for: Array(context.insertedObjects))
                    try self.performSave(in: context)
                } catch { assertionFailure(error.localizedDescription) }
            }
        }
    }
    
    private func performSave(in context: NSManagedObjectContext) throws {
        try context.save()
        if let parent = context.parent {
            try performSave(in: parent)
        }
    }
    
    func addChannels(_ channels: [Channel]) {
        performSave { (context) in
            channels.forEach { _ = ChannelDB(channel: $0, context: context) }
        }
    }
    
    func updateChannels(_ channels: [Channel]) {
        performSave { (context) in
            channels.forEach {
                let fetchRequest: NSFetchRequest<ChannelDB> = ChannelDB.fetchRequest()
                let predicate = NSPredicate(format: "identifier = %@", $0.identifier)
                fetchRequest.predicate = predicate
                do {
                    let channelsDB = try context.fetch(fetchRequest)
                    guard let channel = channelsDB.first else { return }
                    channel.setValue($0.lastActivity, forKey: "lastActivity")
                    channel.setValue($0.lastMessage, forKey: "lastMessage")
                    channel.setValue($0.name, forKey: "name")
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
