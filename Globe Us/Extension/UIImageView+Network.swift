//
//  UIImageView+Network.swift
//  Globe Us
//
//  Created by Karim Razhanov on 14.09.2020.
//

import Foundation
import Alamofire
import AlamofireImage

let imageCache = AutoPurgingImageCache(memoryCapacity: 100_000_000, preferredMemoryUsageAfterPurge: 60_000_000)

extension UIImageView {
    
    /// Synchronous image loading
    ///
    /// - Parameter url: image url
    func load(url: URL) {
        if let data = try? Data(contentsOf: url) {
            if let image = UIImage(data: data) {
                self.image = image
            }
        }
    }
    
    /// Asynchronous image loading
    ///
    /// - Parameters:
    ///   - url: image url
    ///   - completion: code executed after image loading
    func loadWithAlamofire(urlString: String, placeholderImage: UIImage = UIImage(), completion: @escaping () -> Void = {}) {
        if let cachedImage = imageCache.image(withIdentifier: urlString) {
            self.image = cachedImage
        } else {
            AF.request(urlString).responseImage { (response) in
                if let imageUrl = response.value {
                    self.image = imageUrl
                    imageCache.add(imageUrl, withIdentifier: urlString)
                    completion()
                } else {
                    self.image = placeholderImage
                }
            }
        }
    }
}
