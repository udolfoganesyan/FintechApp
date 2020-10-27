//
//  ChannelDB.swift
//  FintechApp
//
//  Created by Rudolf Oganesyan on 27.10.2020.
//  Copyright © 2020 Рудольф О. All rights reserved.
//
//

import CoreData

@objc(ChannelDB)
public class ChannelDB: NSManagedObject {
    
    @NSManaged public var identifier: String
    @NSManaged public var lastActivity: Date?
    @NSManaged public var lastMessage: String?
    @NSManaged public var name: String
    @NSManaged public var messages: NSSet?
    
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
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ChannelDB> {
        return NSFetchRequest<ChannelDB>(entityName: "ChannelDB")
    }
    
    @objc(addMessagesObject:)
    @NSManaged public func addToMessages(_ value: MessageDB)
    
    @objc(removeMessagesObject:)
    @NSManaged public func removeFromMessages(_ value: MessageDB)
    
    @objc(addMessages:)
    @NSManaged public func addToMessages(_ values: NSSet)
    
    @objc(removeMessages:)
    @NSManaged public func removeFromMessages(_ values: NSSet)
}
