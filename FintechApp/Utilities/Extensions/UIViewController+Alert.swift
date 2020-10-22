//
//  UIViewController+Alert.swift
//  FintechApp
//
//  Created by Rudolf Oganesyan on 12.10.2020.
//  Copyright © 2020 Рудольф О. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showOkAlert(_ title: String?, _ message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default) { _ in
            alertController.dismiss(animated: true, completion: nil)
        })
        self.present(alertController, animated: true)
    }
}
