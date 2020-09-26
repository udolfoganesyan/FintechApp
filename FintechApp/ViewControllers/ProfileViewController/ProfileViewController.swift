//
//  ProfileViewController.swift
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
    @IBOutlet private weak var aboutLabel: UILabel!
    @IBOutlet private weak var saveButton: UIButton!
    @IBOutlet private weak var editButton: UIButton!
    
    private let avatarView = AvatarImageView(style: .circle)
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        setupSubviews()
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
    
    @IBAction private func editButtonTouched(_ sender: UIButton) {
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
        
        #if !targetEnvironment(simulator)
        alertController.addAction(cameraAction)
        #endif
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
            imagePickerController.cameraDevice = .front
        }
        imagePickerController.allowsEditing = true
        
        present(imagePickerController, animated: true)
    }
    
    @IBAction private func closeButtonTouched(_ sender: UIButton) {
        dismiss(animated: true)
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
