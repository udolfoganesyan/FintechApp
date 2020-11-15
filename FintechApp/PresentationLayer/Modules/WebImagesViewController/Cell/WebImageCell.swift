//
//  WebImageCell.swift
//  FintechApp
//
//  Created by Rudolf Oganesyan on 15.11.2020.
//  Copyright © 2020 Рудольф О. All rights reserved.
//

import UIKit

final class WebImageCell: UICollectionViewCell {
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private var imageURL: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layoutImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutImageView() {
        addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
}

// MARK: - ConfigurableView

extension WebImageCell: ConfigurableView {
    
    func configure(with model: WebImageCellModel) {
        
    }
}
