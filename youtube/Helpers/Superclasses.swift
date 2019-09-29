//
//  Superclasses.swift
//  youtube
//
//  Created by adam on 29/09/2019.
//  Copyright © 2019 adam. All rights reserved.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()

class NetworkImageView: UIImageView {
    
    var imageUrl: String?
    
    func loadFromUrlString(_ urlString: String) {
        imageUrl = urlString
        if let imageFromCache = imageCache.object(forKey: urlString as NSString) {
            self.image = imageFromCache
            return
        }
        guard let url = URL(string: urlString) else { return }
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        let imageToCache = UIImage(data: data)
                        if self?.imageUrl == urlString {
                            self?.image = imageToCache
                        }
                        imageCache.setObject(imageToCache!, forKey: urlString as NSString)
                    }
            }
        }
    }
}

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    func setupViews(){
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
