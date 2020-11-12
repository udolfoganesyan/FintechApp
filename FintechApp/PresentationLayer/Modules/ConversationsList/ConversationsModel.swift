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
    func addOrUpdateChannels(_ channels: [Channel])
    func deleteChannels(_ channels: [Channel])
    func fetchedResultsController(delegate: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController<ChannelDB>
}

final class ConversationsModel: ConversationsModelProtocol {
    
    let themeService: ThemeServiceProtocol
    let coreDataService: CoreDataServiceProtocol
    
    var currentTheme: Theme {
        themeService.currentTheme
    }
    
    init(themeService: ThemeServiceProtocol, coreDataService: CoreDataServiceProtocol) {
        self.themeService = themeService
        self.coreDataService = coreDataService
    }
    
    func addOrUpdateChannels(_ channels: [Channel]) {
        coreDataService.addOrUpdateChannels(channels)
    }
    
    func deleteChannels(_ channels: [Channel]) {
        coreDataService.deleteChannels(channels)
    }
    
    func fetchedResultsController(delegate: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController<ChannelDB> {
        let fetchRequest = ChannelDB.defaultSortedFetchRequest
        
        fetchRequest.returnsObjectsAsFaults = false
        
        fetchRequest.fetchBatchSize = 22
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: coreDataService.mainContext,
                                             sectionNameKeyPath: nil,
                                             cacheName: "channelsCache")
        frc.delegate = delegate
        return frc
    }
}
