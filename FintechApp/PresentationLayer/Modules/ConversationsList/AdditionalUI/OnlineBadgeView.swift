//
//  OnlineBadgeView.swift
//  FintechApp
//
//  Created by Rudolf Oganesyan on 25.09.2020.
//  Copyright © 2020 Рудольф О. All rights reserved.
//

import UIKit

final class OnlineBadgeView: UIView {
    
    private let onlineBadgeGreen = UIColor(red: 0.353, green: 0.831, blue: 0.224, alpha: 1)
    private lazy var innerBadge = UIView()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.masksToBounds = true
        layer.cornerRadius = frame.width / 2
        
        innerBadge.layer.cornerRadius = innerBadge.bounds.width / 2
        innerBadge.layer.masksToBounds = true
    }
    
    func install(on parentView: UIView) {
        backgroundColor = .white
        
        parentView.addSubview(self)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        widthAnchor.constraint(equalTo: parentView.widthAnchor, multiplier: 0.3).isActive = true
        heightAnchor.constraint(equalTo: parentView.heightAnchor, multiplier: 0.3).isActive = true
        topAnchor.constraint(equalTo: parentView.topAnchor, constant: 2).isActive = true
        rightAnchor.constraint(equalTo: parentView.rightAnchor).isActive = true
        
        innerBadge.translatesAutoresizingMaskIntoConstraints = false
        addSubview(innerBadge)
        
        innerBadge.backgroundColor = onlineBadgeGreen
        innerBadge.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.65).isActive = true
        innerBadge.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.65).isActive = true
        innerBadge.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        innerBadge.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
}
