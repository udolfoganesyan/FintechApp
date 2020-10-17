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
    
    // в нашем случае, поскольку родитель(conversationslistviewcontroller)
    //    не держит ссылку на этот vc - retain cycle'а нет, даже если делегата не делать weak
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
        
        dayThemeContainer.layer.borderColor = UIColor.gray.cgColor
        dayThemeContainer.layer.cornerRadius = 8
        
        nightThemeContainer.layer.borderColor = UIColor.gray.cgColor
        nightThemeContainer.layer.cornerRadius = 8
        
        updateButtonState(ThemeManager.currentTheme)
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
            classicThemeContainer.layer.borderWidth = 2
            dayThemeContainer.layer.borderWidth = 0
            nightThemeContainer.layer.borderWidth = 0
            
            classicThemeContainer.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
            dayThemeContainer.backgroundColor = .clear
            nightThemeContainer.backgroundColor = .clear
        case .day:
            classicThemeContainer.layer.borderWidth = 0
            dayThemeContainer.layer.borderWidth = 2
            nightThemeContainer.layer.borderWidth = 0
            
            classicThemeContainer.backgroundColor = .clear
            dayThemeContainer.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
            nightThemeContainer.backgroundColor = .clear
        case .night:
            classicThemeContainer.layer.borderWidth = 0
            dayThemeContainer.layer.borderWidth = 0
            nightThemeContainer.layer.borderWidth = 2
            
            classicThemeContainer.backgroundColor = .clear
            dayThemeContainer.backgroundColor = .clear
            nightThemeContainer.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        }
    }
    
    private func updateTheme(_ theme: Theme) {
        view.backgroundColor = ThemeManager.currentTheme.backgroundColor
        classicLabel.textColor = ThemeManager.currentTheme.primaryTextColor
        dayLabel.textColor = ThemeManager.currentTheme.primaryTextColor
        nightLabel.textColor = ThemeManager.currentTheme.primaryTextColor
    }
}
