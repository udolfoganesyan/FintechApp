//
//  WebImageCell.swift
//  FintechApp
//
//  Created by Rudolf Oganesyan on 15.11.2020.
//  Copyright © 2020 Рудольф О. All rights reserved.
//

import UIKit

final class WebImageCell: UICollectionViewCell {
    
    private lazy var imageView = WebImageView()
    private var imageURL: String?
    
    var image: UIImage? {
        imageView.image
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
        addSubviewInBounds(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - ConfigurableView

extension WebImageCell: ConfigurableView {
    
    func configure(with model: WebImageCellModel) {
        guard let url = URL(string: model.imageURL) else { return }
        imageView.loadImage(from: url)
    }
}
