//
//  UITableViewCell+reuseIdentifier.swift
//  FintechApp
//
//  Created by Rudolf Oganesyan on 25.09.2020.
//  Copyright © 2020 Рудольф О. All rights reserved.
//

import UIKit

protocol ConfigurableCell: class {
    static var nib: UINib { get }
    static var reuseIdentifier: String { get }
    
    associatedtype ConfigurationModel
    func configure(with model: ConfigurationModel)
}

extension ConfigurableCell {
    
    static var nib: UINib {
        return UINib(nibName: reuseIdentifier, bundle: nil)
    }
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
