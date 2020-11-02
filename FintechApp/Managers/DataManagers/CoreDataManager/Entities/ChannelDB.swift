//
//  ChannelDB.swift
//  FintechApp
//
//  Created by Rudolf Oganesyan on 27.10.2020.
//  Copyright © 2020 Рудольф О. All rights reserved.
//

import CoreData

@objc(ChannelDB)
final class ChannelDB: NSManagedObject {
    
    @NSManaged var identifier: String
    @NSManaged var lastActivity: Date?
    @NSManaged var lastMessage: String?
    @NSManaged var name: String
    @NSManaged var messages: NSOrderedSet?
    
    var about: String {
        let description = "id: \(identifier)\nname: \(name)\nlast activity: \(String(describing: lastActivity))\nlast message: \(String(describing: lastMessage))"
        return description
    }
    
    convenience init(channel: Channel, context: NSManagedObjectContext) {
        self.init(context: context)
        self.identifier = channel.identifier
        self.lastActivity = channel.lastActivity
        self.lastMessage = channel.lastMessage
        self.name = channel.name
    }
    
    @nonobjc class func fetchRequest() -> NSFetchRequest<ChannelDB> {
        return NSFetchRequest<ChannelDB>(entityName: "ChannelDB")
    }
    
    @objc(addMessagesObject:)
    @NSManaged func addToMessages(_ value: MessageDB)
    
    @objc(removeMessagesObject:)
    @NSManaged func removeFromMessages(_ value: MessageDB)
    
    @objc(addMessages:)
    @NSManaged func addToMessages(_ values: NSOrderedSet)
    
    @objc(removeMessages:)
    @NSManaged func removeFromMessages(_ values: NSOrderedSet)
}
