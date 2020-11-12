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

final class ThemeSettingsViewController: UIViewController {
    
    @IBOutlet private weak var classicThemeContainer: UIView!
    @IBOutlet private weak var dayThemeContainer: UIView!
    @IBOutlet private weak var nightThemeContainer: UIView!
    @IBOutlet private weak var classicLabel: UILabel!
    @IBOutlet private weak var dayLabel: UILabel!
    @IBOutlet private weak var nightLabel: UILabel!
    
    weak var delegate: SettingsDelegate?
    
    private let themeSettingsModel: ThemeSettingsModelProtocol
    
    init(themeSettingsModel: ThemeSettingsModelProtocol) {
        self.themeSettingsModel = themeSettingsModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        
        updateButtonState(themeSettingsModel.currentTheme)
        updateTheme(themeSettingsModel.currentTheme)
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
        if themeSettingsModel.currentTheme != theme {
            themeSettingsModel.updateThemeWith(theme) {
                self.delegate?.didChangeTheme()
                
                self.updateThemeAnimated(theme)
            }
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
        view.backgroundColor = themeSettingsModel.currentTheme.backgroundColor
        classicLabel.textColor = themeSettingsModel.currentTheme.primaryTextColor
        dayLabel.textColor = themeSettingsModel.currentTheme.primaryTextColor
        nightLabel.textColor = themeSettingsModel.currentTheme.primaryTextColor
    }
}
