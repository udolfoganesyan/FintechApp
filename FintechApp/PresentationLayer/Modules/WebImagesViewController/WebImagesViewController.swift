//
//  WebImagesViewController.swift
//  FintechApp
//
//  Created by Rudolf Oganesyan on 14.11.2020.
//  Copyright © 2020 Рудольф О. All rights reserved.
//

import UIKit

protocol WebImagesViewControllerDelegate: class {
    func didChooseImage(_ image: UIImage)
}

final class WebImagesViewController: UIViewController {
    
    weak var delegate: WebImagesViewControllerDelegate?
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(WebImageCell.self, forCellWithReuseIdentifier: WebImageCell.reuseIdentifier)
        return collectionView
    }()
    
    private let webImagesInteractor: WebImagesInteractorProtocol
    
    init(webImagesInteractor: WebImagesInteractorProtocol) {
        self.webImagesInteractor = webImagesInteractor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutCollectionView()
    }
    
    private func layoutCollectionView() {
        view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
}

// MARK: - UICollectionViewDelegate

extension WebImagesViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedImage = UIImage()
        delegate?.didChooseImage(selectedImage)
        dismiss(animated: true)
    }
}

// MARK: - UICollectionViewDataSource

extension WebImagesViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WebImageCell.reuseIdentifier, for: indexPath) as? WebImageCell else {
            return UICollectionViewCell()
        }
        
        return cell
    }
}
