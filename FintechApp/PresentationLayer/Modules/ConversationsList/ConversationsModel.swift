//
//  ConversationsModel.swift
//  FintechApp
//
//  Created by Rudolf Oganesyan on 13.11.2020.
//  Copyright © 2020 Рудольф О. All rights reserved.
//

import CoreData

protocol ConversationsModelProtocol {
    var currentTheme: Theme { get }
    
    func createFBChannelWith(_ name: String, completion: @escaping SuccessCompletion)
    func deleteFBChannelWith(channelId: String, completion: @escaping SuccessCompletion)
    
    var fetchedResultsController: NSFetchedResultsController<ChannelDB> { get }
    func fetchSavedChannels()
    func fetchNewChannelsAndSaveToDB()
}

final class ConversationsModel: ConversationsModelProtocol {
    
    private let themeService: ThemeServiceProtocol
    private let firebaseService: FirebaseServiceProtocol
    private let coreDataService: CoreDataServiceProtocol
    
    var currentTheme: Theme {
        themeService.currentTheme
    }
    
    init(themeService: ThemeServiceProtocol, firebaseService: FirebaseServiceProtocol, coreDataService: CoreDataServiceProtocol) {
        self.themeService = themeService
        self.firebaseService = firebaseService
        self.coreDataService = coreDataService
    }
    
    func createFBChannelWith(_ name: String, completion: @escaping SuccessCompletion) {
        firebaseService.createChannelWith(name, completion: completion)
    }
    
    func deleteFBChannelWith(channelId: String, completion: @escaping SuccessCompletion) {
        firebaseService.deleteChannelWith(channelId: channelId, completion: completion)
    }
    
    lazy var fetchedResultsController: NSFetchedResultsController<ChannelDB> = {
        let fetchRequest = ChannelDB.defaultSortedFetchRequest
        
        fetchRequest.returnsObjectsAsFaults = false
        
        fetchRequest.fetchBatchSize = 22
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: coreDataService.mainContext,
                                             sectionNameKeyPath: nil,
                                             cacheName: "channelsCache")
        return frc
    }()
    
    func fetchSavedChannels() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            Logger.log(error.localizedDescription)
        }
    }
    
    func fetchNewChannelsAndSaveToDB() {
        firebaseService.fetchChannels { (channelUpdates) in
            self.coreDataService.addOrUpdateChannels(channelUpdates.added)
            self.coreDataService.addOrUpdateChannels(channelUpdates.modified)
            self.coreDataService.deleteChannels(channelUpdates.removed)
        }
    }
}
