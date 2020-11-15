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
    let theme: Theme
    
    init(channelDB: ChannelDB, theme: Theme) {
        self.name = channelDB.name
        self.message = channelDB.lastMessage ?? ""
        self.date = ConversationCellModel.getFormattedDateStringFrom(channelDB.lastActivity)
        self.theme = theme
    }
    
    static private func getFormattedDateStringFrom(_ date: Date?) -> String {
        guard let date = date else { return "" }
        let calendar = Calendar.current
        if calendar.isDateInToday(date) {
            dateFormatter.dateFormat = "HH:mm"
        } else {
            dateFormatter.dateFormat = "dd MMM"
        }
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
}
