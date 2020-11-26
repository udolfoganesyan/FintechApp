//
//  ConversationDateHeader.swift
//  FintechApp
//
//  Created by Rudolf Oganesyan on 03.11.2020.
//  Copyright © 2020 Рудольф О. All rights reserved.
//

import UIKit

final class ConversationDateHeader: UIView {
    
    private static let dateFormatter = DateFormatter()
    
    private let theme: Theme
    private lazy var dateLabel = HeaderDateLabel(theme: theme)
    
    init(dateString: String, theme: Theme) {
        self.theme = theme
        super.init(frame: .zero)
        
        addSubviewCentered(dateLabel)
        setupLabel(with: dateString)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLabel(with dateString: String) {
        ConversationDateHeader.dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        let date = ConversationDateHeader.dateFormatter.date(from: dateString) ?? Date()
        dateLabel.text = getStringFrom(date: date)
    }
    
    private func getStringFrom(date: Date) -> String {
        let calendar = Calendar.current
        if calendar.isDateInToday(date) {
            return "Today"
        } else if calendar.isDateInYesterday(date) {
            return "Yesterday"
        } else {
            ConversationDateHeader.dateFormatter.dateFormat = "EEEE, MMM d"
            return ConversationDateHeader.dateFormatter.string(from: date)
        }
    }
}
