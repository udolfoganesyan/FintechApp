//
//  CoreDataManager.swift
//  FintechApp
//
//  Created by Rudolf Oganesyan on 27.10.2020.
//  Copyright © 2020 Рудольф О. All rights reserved.
//

import CoreData

final class CoreDataManager {
    
    var didUpdateDataBase: ((CoreDataManager) -> Void)
    
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
        didUpdateDataBase = { manager in
            _ = manager.fetchChannels()
            _ = manager.fetchMessages()
        }
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
    
    func fetchChannels(withPredicate predicate: NSPredicate? = nil, in context: NSManagedObjectContext? = nil) -> [ChannelDB]? {
        do {
            let fetchContext = context ?? mainContext
            let request: NSFetchRequest<ChannelDB> = ChannelDB.fetchRequest()
            request.predicate = predicate
            let channels = try fetchContext.fetch(request)
            channels.forEach { Logger.log($0.about) }
            return channels
        } catch {
            Logger.log(error.localizedDescription)
            return nil
        }
    }
    
    func fetchMessages() -> [MessageDB]? {
        do {
            let messages = try mainContext.fetch(MessageDB.fetchRequest()) as? [MessageDB] ?? []
            messages.forEach { Logger.log($0.about) }
            return messages
        } catch {
            Logger.log(error.localizedDescription)
            return nil
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
        
        didUpdateDataBase(self)
        
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
