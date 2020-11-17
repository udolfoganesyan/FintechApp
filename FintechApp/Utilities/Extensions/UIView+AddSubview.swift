//
//  UIView+AddSubview.swift
//  FintechApp
//
//  Created by Rudolf Oganesyan on 17.11.2020.
//  Copyright © 2020 Рудольф О. All rights reserved.
//

import UIKit

extension UIView {
    
    func addSubviewInBounds(_ view: UIView, topPadding: CGFloat = 0, bottomPadding: CGFloat = 0, leadingPadding: CGFloat = 0, trailingPadding: CGFloat = 0) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: self.topAnchor, constant: topPadding),
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: leadingPadding),
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: trailingPadding),
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: bottomPadding)
        ])
    }
    
    func addSubviewWithSameSizeAndSafeTop(_ view: UIView) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    func addSubviewCentered(_ view: UIView) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            view.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}
