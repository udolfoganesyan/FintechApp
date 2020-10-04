//
//  ThemeSettingsViewController.swift
//  FintechApp
//
//  Created by Rudolf Oganesyan on 03.10.2020.
//  Copyright © 2020 Рудольф О. All rights reserved.
//

import UIKit

protocol SettingsDelegate: class {
    func didChangeTheme()
}

class ThemeSettingsViewController: UIViewController {
    
    @IBOutlet private weak var classicThemeContainer: UIView!
    @IBOutlet private weak var dayThemeContainer: UIView!
    @IBOutlet private weak var nightThemeContainer: UIView!
    @IBOutlet private weak var classicLabel: UILabel!
    @IBOutlet private weak var dayLabel: UILabel!
    @IBOutlet private weak var nightLabel: UILabel!
    
    weak var delegate: SettingsDelegate?
    var changeThemeClosure: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupGestures()
        updateTheme()
    }
    
    private func setupViews() {
        classicThemeContainer.layer.borderColor = UIColor.gray.cgColor
        classicThemeContainer.layer.cornerRadius = 8
        
        dayThemeContainer.layer.borderColor = UIColor.gray.cgColor
        dayThemeContainer.layer.cornerRadius = 8
        
        nightThemeContainer.layer.borderColor = UIColor.gray.cgColor
        nightThemeContainer.layer.cornerRadius = 8
        
        switch ThemeManager.currentTheme {
        case .classic:
            classicThemeContainer.layer.borderWidth = 2
        case .day:
            dayThemeContainer.layer.borderWidth = 2
        case .night:
            nightThemeContainer.layer.borderWidth = 2
        }
    }
    
    private func setupGestures() {
        let classicThemeTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleClassicTheme))
        classicThemeContainer.addGestureRecognizer(classicThemeTapGesture)
        
        let dayThemeTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDayTheme))
        dayThemeContainer.addGestureRecognizer(dayThemeTapGesture)
        
        let nightThemeTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleNightTheme))
        nightThemeContainer.addGestureRecognizer(nightThemeTapGesture)
    }
    
    @objc private func handleClassicTheme() {
        classicThemeContainer.layer.borderWidth = 2
        dayThemeContainer.layer.borderWidth = 0
        nightThemeContainer.layer.borderWidth = 0
        
        if ThemeManager.currentTheme != .classic {
            ThemeManager.updateThemeWith(.classic)
            delegate?.didChangeTheme()
            changeThemeClosure?()
            updateTheme()
        }
    }
    
    @objc private func handleDayTheme() {
        classicThemeContainer.layer.borderWidth = 0
        dayThemeContainer.layer.borderWidth = 2
        nightThemeContainer.layer.borderWidth = 0
        
        if ThemeManager.currentTheme != .day {
            ThemeManager.updateThemeWith(.day)
            delegate?.didChangeTheme()
            changeThemeClosure?()
            updateTheme()
        }
        
    }
    
    @objc private func handleNightTheme() {
        classicThemeContainer.layer.borderWidth = 0
        dayThemeContainer.layer.borderWidth = 0
        nightThemeContainer.layer.borderWidth = 2
        
        if ThemeManager.currentTheme != .night {
            ThemeManager.updateThemeWith(.night)
            delegate?.didChangeTheme()
            changeThemeClosure?()
            updateTheme()
        }
    }
    
    private func updateTheme() {
        view.backgroundColor = ThemeManager.currentTheme.backgroundColor
        classicLabel.textColor = ThemeManager.currentTheme.primaryTextColor
        dayLabel.textColor = ThemeManager.currentTheme.primaryTextColor
        nightLabel.textColor = ThemeManager.currentTheme.primaryTextColor
    }
}
