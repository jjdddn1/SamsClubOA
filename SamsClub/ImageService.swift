//
//  ImageService.swift
//  SamsClub
//
//  Created by Huiyuan Ren on 8/9/17.
//  Copyright © 2017 Huiyuan Ren. All rights reserved.
//

import UIKit

class ImageService {
    // MARK: - properties
    static let shared = ImageService()
    private var cache = NSCache<NSString, UIImage>()
    
    // MARK: - private
    private func image(for url: URL?) -> UIImage? {
        guard let url = url as NSURL?, let urlStr = url.absoluteString else {
            return nil
        }
        return cache.object(forKey: urlStr as NSString)
    }
    
    private func cache(image: UIImage, for url: URL) {
        
    }
    
    // MARK: - public
    func downloadImageFrom(url: URL?, success:@escaping (UIImage?) -> ()) {
        guard let url = url else {
            return
        }
        
        if let image = image(for: url) {
            success(image)
        }
        
        DispatchQueue.global().async { [weak self] in
            let imageData = try? Data(contentsOf: url)
            if let data = imageData, let image = UIImage(data: data) {
                success(image)
                self?.cache(image: image, for: url)
            }
        }
        
    }
    
}
