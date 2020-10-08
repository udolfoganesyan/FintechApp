//
//  UIColor+Random.swift
//  FintechApp
//
//  Created by Rudolf Oganesyan on 26.09.2020.
//  Copyright © 2020 Рудольф О. All rights reserved.
//

import UIKit

extension UIColor {
    
    static var randomLightColor: UIColor {
        return UIColor(red: .random(in: 0.2...1),
                       green: .random(in: 0.2...1),
                       blue: .random(in: 0.2...1),
                       alpha: 1.0)
    }
}
