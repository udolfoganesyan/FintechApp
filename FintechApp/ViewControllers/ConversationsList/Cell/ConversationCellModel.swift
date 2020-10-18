//
//  ConversationCellModel.swift
//  FintechApp
//
//  Created by Rudolf Oganesyan on 25.09.2020.
//  Copyright © 2020 Рудольф О. All rights reserved.
//

import Foundation

struct ConversationCellModel {
    
    static private let dateFormatter = DateFormatter()
    
    let name: String
    let message: String
    let date: String
    let isOnline: Bool
    let hasUnreadMessages: Bool
    
    init(channel: Channel) {
        self.name = channel.name
        self.message = channel.lastMessage ?? "No messages yet"
        self.date = ConversationCellModel.getFormattedDateStringFrom(channel.lastActivity ?? Date())
        
        self.isOnline = false
        self.hasUnreadMessages = false
    }
    
    static private func getFormattedDateStringFrom(_ date: Date) -> String {
        let calendar = Calendar.current
        if calendar.isDateInToday(date) {
            ConversationCellModel.dateFormatter.dateFormat = "HH:mm"
        } else {
            ConversationCellModel.dateFormatter.dateFormat = "dd MMM"
        }
        let dateString = ConversationCellModel.dateFormatter.string(from: date)
        return dateString
    }
}
