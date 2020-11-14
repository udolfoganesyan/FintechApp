//
//  PresentationAssembly.swift
//  FintechApp
//
//  Created by Rudolf Oganesyan on 13.11.2020.
//  Copyright © 2020 Рудольф О. All rights reserved.
//

import Foundation

protocol PresentationAssemblyProtocol {
    func profileViewController() -> ProfileViewController
    func webImagesViewController() -> WebImagesViewController
    func conversationsListViewController() -> ConversationsViewController
    func conversationViewController(forChannel channel: ChannelDB) -> ConversationViewController
    func themeSettingsViewController() -> ThemeSettingsViewController
}

final class PresentationAssembly: PresentationAssemblyProtocol {
    
    private let serviceAssembly: ServicesAssemblyProtocol
    
    init(serviceAssembly: ServicesAssemblyProtocol) {
        self.serviceAssembly = serviceAssembly
        serviceAssembly.themeService.setupNavigationBarAppearance()
    }
    
    // MARK: - ProfileViewController
    
    func profileViewController() -> ProfileViewController {
        let profileInteractor =
            ProfileInteractor(themeService: serviceAssembly.themeService,
                              gcdUserDataService: serviceAssembly.gcdUserDataService,
                              operationUserDataService: serviceAssembly.operationUserDataService)
        let profileVC = ProfileViewController(profileInteractor: profileInteractor, presentationAssembly: self)
        return profileVC
    }
    
    // MARK: - WebImagesViewController
    
    func webImagesViewController() -> WebImagesViewController {
        let webImagesInteractor =
            WebImagesInteractor(themeService: serviceAssembly.themeService,
                                webImagesService: serviceAssembly.webImagesService)
        let webImagesVC = WebImagesViewController(webImagesInteractor: webImagesInteractor)
        return webImagesVC
    }
    
    // MARK: - ConversationsViewController
    
    func conversationsListViewController() -> ConversationsViewController {
        let conversationsInteractor =
            ConversationsInteractor(themeService: serviceAssembly.themeService,
                                    firebaseService: serviceAssembly.firebaseService,
                                    coreDataService: serviceAssembly.coreDataService)
        let conversationsVC = ConversationsViewController(conversationsInteractor: conversationsInteractor, presentationAssembly: self)
        return conversationsVC
    }
    
    // MARK: - ConversationViewController
    
    func conversationViewController(forChannel channel: ChannelDB) -> ConversationViewController {
        let conversationInteractor =
            ConversationInteractor(themeService: serviceAssembly.themeService,
                                   firebaseService: serviceAssembly.firebaseService,
                                   coreDataService: serviceAssembly.coreDataService,
                                   channel: channel)
        let conversationVC = ConversationViewController(conversationInteractor: conversationInteractor)
        return conversationVC
    }
    
    // MARK: - ThemeSettingsViewController
    
    func themeSettingsViewController() -> ThemeSettingsViewController {
        let themeSettingsInteractor = ThemeSettingsInteractor(themeService: serviceAssembly.themeService)
        let themeSettingsVC = ThemeSettingsViewController(themeSettingsInteractor: themeSettingsInteractor)
        return themeSettingsVC
    }
}
