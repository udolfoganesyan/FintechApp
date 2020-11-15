//
//  WebImageView.swift
//  FintechApp
//
//  Created by Rudolf Oganesyan on 15.11.2020.
//  Copyright © 2020 Рудольф О. All rights reserved.
//

import UIKit

final class WebImageView: UIImageView {
    
    private static var imageCache = [String: UIImage]()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    var task: URLSessionDataTask?
    
    init() {
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        contentMode = .scaleAspectFill
        clipsToBounds = true
        
        layoutActivityIndicator()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadImage(from url: URL) {
        
        image = nil
        
        activityIndicator.startAnimating()
        
        if let task = task {
            task.cancel()
        }
        
        if let imageFromCache = WebImageView.imageCache[url.absoluteString] {
            self.image = imageFromCache
            activityIndicator.stopAnimating()
            return
        }
        
        task = URLSession.shared.dataTask(with: url, completionHandler: { (data, _, _) in
            guard let data = data,
                  let newImage = UIImage(data: data) else { return }
            WebImageView.imageCache[url.absoluteString] = newImage
            
            DispatchQueue.main.async {
                self.image = newImage
                self.activityIndicator.stopAnimating()
            }
        })
        
        task?.resume()
    }
    
    private func layoutActivityIndicator() {
        addSubview(activityIndicator)
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
}
