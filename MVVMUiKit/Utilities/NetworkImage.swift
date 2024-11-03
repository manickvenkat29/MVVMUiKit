//
//  NetworkImage.swift
//  MVVMUiKit
//
//  Created by Manickam on 03/11/24.
//

import Foundation
import UIKit

// UIImageView extension to load and cache images
extension UIImageView {
    private static let imageCache = NSCache<NSURL, UIImage>()
    
    func loadImage(from url: URL, placeholder: UIImage? = nil) {
        // Set placeholder image, if provided
        self.image = placeholder
        
        // Check if the image is already cached
        if let cachedImage = UIImageView.imageCache.object(forKey: url as NSURL) {
            self.image = cachedImage
            return
        }
        
        // Download the image if it's not cached
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                print("Failed to load image: \(error.localizedDescription)")
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                print("Failed to decode image")
                return
            }
            
            // Cache the image
            UIImageView.imageCache.setObject(image, forKey: url as NSURL)
            
            // Update the UIImageView on the main thread
            DispatchQueue.main.async {
                self?.image = image
            }
        }.resume()
    }
}
