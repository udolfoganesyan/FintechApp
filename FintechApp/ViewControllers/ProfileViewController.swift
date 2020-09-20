//
//  ViewController.swift
//  FintechApp
//
//  Created by Rudolf Oganesyan on 13.09.2020.
//  Copyright © 2020 Рудольф О. All rights reserved.
//

import UIKit
import MobileCoreServices

class ProfileViewController: UIViewController {
    
    @IBOutlet private weak var avatarContainerView: UIView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var saveButton: UIButton!
    @IBOutlet private weak var editButton: UIButton!
    
    private let avatarView = AvatarImageView(style: .circle)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Logger.log("\(saveButton.frame)")
        
        setupSubviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Logger.log("\(saveButton.frame)")
    }
    
    private func setupSubviews() {
        setupSaveButton()
        setupAvatarView()
    }
    
    private func setupSaveButton() {
        saveButton.layer.cornerRadius = 14
        saveButton.layer.masksToBounds = true
    }
    
    private func setupAvatarView() {
        avatarView.install(on: avatarContainerView)
        avatarView.setupWith(firstName: "Rudolf", lastName: "Oganesyan", color: #colorLiteral(red: 0.8941176471, green: 0.9098039216, blue: 0.168627451, alpha: 1))
        
        avatarContainerView.bringSubviewToFront(editButton)
    }
    
    @IBAction func editButtonTouched(_ sender: UIButton) {
        presentaActionSheet()
    }
    
    private func presentaActionSheet() {
        let alertController = UIAlertController(title: "Choose Image from", message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) {
            action in
            self.showImagePicker(for: .camera)
        }
        let galleryAction = UIAlertAction(title: "Gallery", style: .default) {
            action in
            self.showImagePicker(for: .photoLibrary)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(cameraAction)
        alertController.addAction(galleryAction)
        alertController.addAction(cancelAction)
        alertController.pruneNegativeWidthConstraints()
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func showImagePicker(for type: UIImagePickerController.SourceType) {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            Logger.log("SourceType is unavailable")
            return
        }
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = type
        if type == .camera {
            #if !targetEnvironment(simulator)
            imagePickerController.cameraDevice = .front
            #endif
        }
        imagePickerController.allowsEditing = true
        imagePickerController.mediaTypes = [String(kUTTypeImage)]
        
        present(imagePickerController, animated: true)
    }
}

// MARK: - UIImagePickerControllerDelegate

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        avatarView.setupWith(image: image)
        
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}
