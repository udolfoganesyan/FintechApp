//
//  MessageDB.swift
//  FintechApp
//
//  Created by Rudolf Oganesyan on 27.10.2020.
//  Copyright © 2020 Рудольф О. All rights reserved.
//
//

import CoreData

@objc(MessageDB)
public class MessageDB: NSManagedObject {

    @NSManaged public var identifier: String
    @NSManaged public var content: String
    @NSManaged public var created: Date
    @NSManaged public var senderId: String
    @NSManaged public var senderName: String
    @NSManaged public var channel: ChannelDB?
    
    var about: String {
        let description = "message id: \(identifier)\nsender id: \(senderId)\nsender name: \(senderName)\ncreated: \(String(describing: created))\ncontent: \(content)"
        return description
    }
    
    convenience init(message: Message, context: NSManagedObjectContext) {
        self.init(context: context)
        self.identifier = message.identifier
        self.content = message.content
        self.created = message.created
        self.senderId = message.senderId
        self.senderName = message.senderName
    }
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<MessageDB> {
        return NSFetchRequest<MessageDB>(entityName: "MessageDB")
    }
}
