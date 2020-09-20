//
//  UIAlertController+ConstraintsFix.swift
//  FintechApp
//
//  Created by Rudolf Oganesyan on 20.09.2020.
//  Copyright © 2020 Рудольф О. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    func pruneNegativeWidthConstraints() {
        for subView in self.view.subviews {
            for constraint in subView.constraints where constraint.debugDescription.contains("width == - 16") {
                subView.removeConstraint(constraint)
            }
        }
    }
}
