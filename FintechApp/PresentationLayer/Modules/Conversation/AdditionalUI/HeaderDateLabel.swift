//
//  HeaderDateLabel.swift
//  FintechApp
//
//  Created by Rudolf Oganesyan on 03.11.2020.
//  Copyright © 2020 Рудольф О. All rights reserved.
//

import UIKit

final class HeaderDateLabel: UILabel {
    
    private let theme: Theme
    
    override var intrinsicContentSize: CGSize {
        let originalSize = super.intrinsicContentSize
        return CGSize(width: originalSize.width + 12, height: originalSize.height + 6)
    }
    
    init(theme: Theme) {
        self.theme = theme
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        textAlignment = .center
        textColor = theme.secondaryTextColor
        backgroundColor = theme.backgroundColor.withAlphaComponent(0.9)
        
        layer.cornerRadius = 8
        layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
