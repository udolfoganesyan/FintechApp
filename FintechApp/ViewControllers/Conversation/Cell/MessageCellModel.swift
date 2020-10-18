//
//  MessageCellModel.swift
//  FintechApp
//
//  Created by Rudolf Oganesyan on 26.09.2020.
//  Copyright © 2020 Рудольф О. All rights reserved.
//

import UIKit

struct MessageCellModel {
    let attributedText: NSMutableAttributedString
    let isIncoming: Bool
    
    init(message: Message) {
        let isIncoming = message.senderId != FirebaseManager.myId
        self.isIncoming = isIncoming
        
        let attributedText = NSMutableAttributedString(string: message.content, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)])
        if isIncoming {
            attributedText.append(NSAttributedString(string: "\n\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 4)]))
            
            attributedText.append(NSAttributedString(string: message.senderName, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 8, weight: .light)]))
        }
        self.attributedText = attributedText
    }
}
