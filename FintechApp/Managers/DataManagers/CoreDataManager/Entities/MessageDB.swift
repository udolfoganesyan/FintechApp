//
//  MessageDB.swift
//  FintechApp
//
//  Created by Rudolf Oganesyan on 27.10.2020.
//  Copyright © 2020 Рудольф О. All rights reserved.
//

import CoreData

@objc(MessageDB)
final class MessageDB: NSManagedObject {
    
    @NSManaged var identifier: String
    @NSManaged var content: String
    @NSManaged var created: Date
    @NSManaged var senderId: String
    @NSManaged var senderName: String
    @NSManaged var dateForSection: Date
    @NSManaged var channel: ChannelDB?
    
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
        self.dateForSection = getDateWithoutTimeFrom(message.created)
    }
    
    private func getDateWithoutTimeFrom(_ date: Date) -> Date {
        let calendar = Calendar.current
        let dateForSection = calendar.date(from: calendar.dateComponents([.year, .month, .day], from: date))
        return dateForSection ?? Date()
    }
    
    @nonobjc class func fetchRequest() -> NSFetchRequest<MessageDB> {
        return NSFetchRequest<MessageDB>(entityName: "MessageDB")
    }
}
