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
    
    // MARK: - ConversationsViewController
    
    func profileViewController() -> ProfileViewController {
        let profileModel = ProfileModel(themeService: serviceAssembly.themeService)
        let profileVC = ProfileViewController(profileModel: profileModel)
        return profileVC
    }
    
    // MARK: - ConversationsViewController
    
    func conversationsListViewController() -> ConversationsViewController {
        let conversationsModel =
            ConversationsModel(themeService: serviceAssembly.themeService,
                               firebaseService: serviceAssembly.firebaseService,
                               coreDataService: serviceAssembly.coreDataService)
        let rootVC = ConversationsViewController(conversationsModel: conversationsModel, presentationAssembly: self)
        return rootVC
    }
    
    // MARK: - ConversationViewController
    
    func conversationViewController(forChannel channel: ChannelDB) -> ConversationViewController {
        let conversationModel =
            ConversationModel(themeService: serviceAssembly.themeService,
                              firebaseService: serviceAssembly.firebaseService,
                              coreDataService: serviceAssembly.coreDataService,
                              channel: channel)
        let conversationVC = ConversationViewController(conversationModel: conversationModel)
        return conversationVC
    }
    
    // MARK: - ThemeSettingsViewController

    func themeSettingsViewController() -> ThemeSettingsViewController {
        let themeSettingsModel = ThemeSettingsModel(themeService: serviceAssembly.themeService)
        let themeSettingsVC = ThemeSettingsViewController(themeSettingsModel: themeSettingsModel)
        return themeSettingsVC
    }
    
//    func demoViewCotnroller() -> DemoViewController {
//        let model = demoModel()
//        let demoVC = DemoViewController(model: model, presentationAssembly: self)
//        model.delegate = demoVC
//        return demoVC
//    }
//
//    private func demoModel() -> IDemoModel {
//        return DemoModel(appsService: serviceAssembly.appService,
//                         tracksService: serviceAssembly.tracksService)
//    }
}
