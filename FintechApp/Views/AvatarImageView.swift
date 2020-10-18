//
//  AvatarImageView.swift
//  FintechApp
//
//  Created by Rudolf Oganesyan on 20.09.2020.
//  Copyright © 2020 Рудольф О. All rights reserved.
//

import UIKit

final class AvatarImageView: UIImageView {
    
    enum AvatarStyle {
        case circle
        case square
    }
    
    private let style: AvatarStyle
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(style: AvatarStyle) {
        self.style = style
        
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        setupLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if style == .circle {
            layer.masksToBounds = true
            layer.cornerRadius = frame.width / 2
        }
        
        nameLabel.font = .systemFont(ofSize: self.frame.height / 2)
    }
    
    private func setupLabel() {
        addSubview(nameLabel)
        
        nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    func setupWith(firstName: String, lastName: String = "", color: UIColor) {
        nameLabel.text = String(firstName.prefix(1)).uppercased()
        nameLabel.text?.append(contentsOf: lastName.prefix(1).uppercased())
        backgroundColor = color
    }
    
    func setupWith(image: UIImage) {
        nameLabel.isHidden = true
        self.image = image
    }
    
    func install(on parentView: UIView) {
        parentView.addSubview(self)
        topAnchor.constraint(equalTo: parentView.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: parentView.bottomAnchor).isActive = true
        leadingAnchor.constraint(equalTo: parentView.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: parentView.trailingAnchor).isActive = true
    }
}
