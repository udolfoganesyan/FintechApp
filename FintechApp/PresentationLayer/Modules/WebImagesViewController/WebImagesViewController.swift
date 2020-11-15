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
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = cellPadding
        layout.minimumInteritemSpacing = cellPadding
        layout.sectionInset = UIEdgeInsets(top: 0, left: cellPadding, bottom: 0, right: cellPadding)
        let itemsPerRow: CGFloat = 3
        let itemWidth = (view.frame.width - 4 * cellPadding) / itemsPerRow
        let itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.itemSize = itemSize
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(WebImageCell.self, forCellWithReuseIdentifier: WebImageCell.reuseIdentifier)
        collectionView.backgroundColor = webImagesInteractor.currentTheme.backgroundColor
        return collectionView
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "close"), for: .normal)
        button.tintColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleClose), for: .touchUpInside)
        return button
    }()
    
    private let cellPadding: CGFloat = 2
    private let webImagesInteractor: WebImagesInteractorProtocol
    private var imageURLs = [ImageURL]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    init(webImagesInteractor: WebImagesInteractorProtocol) {
        self.webImagesInteractor = webImagesInteractor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = webImagesInteractor.currentTheme.backgroundColor
        
        layoutCloseButton()
        layoutCollectionView()
        
        webImagesInteractor.getImageURLs { (imageURLs) in
            self.imageURLs = imageURLs
        }
    }
    
    private func layoutCloseButton() {
        view.addSubview(closeButton)
        closeButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        closeButton.heightAnchor.constraint(equalTo: closeButton.widthAnchor).isActive = true
        closeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
    }
    
    private func layoutCollectionView() {
        view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 12).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    @objc private func handleClose() {
        dismiss(animated: true)
    }
}

// MARK: - UICollectionViewDelegate

extension WebImagesViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? WebImageCell,
              let selectedImage = cell.image else { return }
        delegate?.didChooseImage(selectedImage)
        dismiss(animated: true)
    }
}

// MARK: - UICollectionViewDataSource

extension WebImagesViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        imageURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WebImageCell.reuseIdentifier, for: indexPath) as? WebImageCell else {
            return UICollectionViewCell()
        }
        
        let model = WebImageCellModel(imageURL: imageURLs[indexPath.row].webformatURL)
        cell.configure(with: model)
        
        return cell
    }
}
