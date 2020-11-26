//
//  ConvenientCell.swift
//  FintechApp
//
//  Created by Rudolf Oganesyan on 25.09.2020.
//  Copyright © 2020 Рудольф О. All rights reserved.
//

import UIKit

protocol ConvenientCell {
    
}

extension ConvenientCell {
    
    static var nib: UINib {
        return UINib(nibName: reuseIdentifier, bundle: nil)
    }
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ConvenientCell {
    
}

extension UICollectionViewCell: ConvenientCell {
    
}
