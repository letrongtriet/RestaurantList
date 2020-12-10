//
//  UIImageView+Extension.swift
//  RestaurantList
//
//  Created by Le, Triet on 9.12.2020.
//

import UIKit

extension UIImageView {
    func loadImage(_ urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let imageCache = NSCache<NSString, UIImage>()
        
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            image = cachedImage
        } else {
            DispatchQueue.global().async { [weak self] in
                if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        imageCache.setObject(image, forKey: url.absoluteString as NSString)
                        self?.image = image
                    }
                }
            }
        }
    }
}
