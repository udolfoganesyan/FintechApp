//
//  User.swift
//  FintechApp
//
//  Created by Rudolf Oganesyan on 14.10.2020.
//  Copyright © 2020 Рудольф О. All rights reserved.
//

import UIKit

struct User: Equatable {
    let fullName: String?
    let about: String?
    let image: UIImage?
    
    init(fullName: String? = nil, about: String? = nil, image: UIImage? = nil) {
        self.fullName = fullName
        self.about = about
        self.image = image
    }
}
