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
    @IBOutlet private weak var classicThemeBackground: UIView!
    @IBOutlet private weak var dayThemeBackground: UIView!
    @IBOutlet private weak var nightThemeBackground: UIView!
    
    weak var delegate: SettingsDelegate?
    var changeThemeClosure: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupGestures()
    }
    
    private func setupViews() {
        classicThemeContainer.layer.borderColor = UIColor.gray.cgColor
        classicThemeContainer.layer.cornerRadius = 8
        classicThemeBackground.layer.cornerRadius = 8
        classicThemeBackground.alpha = 0
        
        dayThemeContainer.layer.borderColor = UIColor.gray.cgColor
        dayThemeContainer.layer.cornerRadius = 8
        dayThemeBackground.layer.cornerRadius = 8
        dayThemeBackground.alpha = 0
        
        nightThemeContainer.layer.borderColor = UIColor.gray.cgColor
        nightThemeContainer.layer.cornerRadius = 8
        nightThemeBackground.layer.cornerRadius = 8
        nightThemeBackground.alpha = 0
        
        updateTheme(ThemeManager.currentTheme)
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
        changeThemeTo(.classic)
    }
    
    @objc private func handleDayTheme() {
        changeThemeTo(.day)
    }
    
    @objc private func handleNightTheme() {
        changeThemeTo(.night)
    }
    
    private func changeThemeTo(_ theme: Theme) {
        if ThemeManager.currentTheme != theme {
            ThemeManager.updateThemeWith(theme)
            delegate?.didChangeTheme()
            changeThemeClosure?()
            
            updateThemeAnimated(theme)
        }
    }
    
    private func updateThemeAnimated(_ theme: Theme) {
        UIView.animate(withDuration: 0.2) {
            self.updateButtonState(theme)
            self.updateTheme(theme)
        }
    }
    
    private func updateButtonState(_ theme: Theme) {
        switch theme {
        case .classic:
            self.classicThemeContainer.layer.borderWidth = 2
            self.dayThemeContainer.layer.borderWidth = 0
            self.nightThemeContainer.layer.borderWidth = 0
            
            self.classicThemeBackground.alpha = 0.3
            self.dayThemeBackground.alpha = 0
            self.nightThemeBackground.alpha = 0
        case .day:
            self.classicThemeContainer.layer.borderWidth = 0
            self.dayThemeContainer.layer.borderWidth = 2
            self.nightThemeContainer.layer.borderWidth = 0
            
            self.classicThemeBackground.alpha = 0
            self.dayThemeBackground.alpha = 0.3
            self.nightThemeBackground.alpha = 0
        case .night:
            self.classicThemeContainer.layer.borderWidth = 0
            self.dayThemeContainer.layer.borderWidth = 0
            self.nightThemeContainer.layer.borderWidth = 2
            
            self.classicThemeBackground.alpha = 0
            self.dayThemeBackground.alpha = 0
            self.nightThemeBackground.alpha = 0.3
        }
    }
    
    private func updateTheme(_ theme: Theme) {
        view.backgroundColor = ThemeManager.currentTheme.backgroundColor
        classicLabel.textColor = ThemeManager.currentTheme.primaryTextColor
        dayLabel.textColor = ThemeManager.currentTheme.primaryTextColor
        nightLabel.textColor = ThemeManager.currentTheme.primaryTextColor
    }
}
