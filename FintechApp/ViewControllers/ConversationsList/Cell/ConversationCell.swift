//
//  ConversationCell.swift
//  FintechApp
//
//  Created by Rudolf Oganesyan on 25.09.2020.
//  Copyright © 2020 Рудольф О. All rights reserved.
//

import UIKit

protocol ConfigurableView {
    associatedtype ConfigurationModel
    func configure(with model: ConfigurationModel)
}

final class ConversationCell: UITableViewCell {
    
    @IBOutlet private weak var avatarContainer: UIView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var messageLabel: UILabel!
    
    private lazy var onlineBadge = OnlineBadgeView()
    private lazy var avatarView = AvatarImageView(style: .circle)
    
    private static let dateFormatter = DateFormatter()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        avatarView.install(on: avatarContainer)
        onlineBadge.install(on: avatarContainer)
    }
}

// MARK: - ConfigurableView

extension ConversationCell: ConfigurableView {
    
    func configure(with model: ConversationCellModel) {
        nameLabel.text = model.name
        avatarView.setupWith(firstName: model.name, lastName: "", color: .randomLightColor)
        onlineBadge.isHidden = !model.isOnline
        backgroundColor = model.isOnline ? #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 0.07) : .white
        messageLabel.text = model.message
        messageLabel.font = .systemFont(ofSize: 16)
        if model.message.isEmpty {
            messageLabel.text = "No messages yet"
            messageLabel.font = .italicSystemFont(ofSize: 16)
        } else if model.hasUnreadMessages {
            messageLabel.font = .boldSystemFont(ofSize: 16)
        }
        
        setDate(model.date)
    }
    
    private func setDate(_ date: Date) {
        let calendar = Calendar.current
        if calendar.isDateInToday(date) {
            ConversationCell.dateFormatter.dateFormat = "HH:mm"
        } else {
            ConversationCell.dateFormatter.dateFormat = "dd MMM"
        }
        let dateString = ConversationCell.dateFormatter.string(from: date)
        dateLabel.text = dateString
    }
}
