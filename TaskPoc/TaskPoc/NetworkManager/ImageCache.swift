//
//  ImageCache.swift
//  TaskPoc
//
//  Created by Prakash's Mac on 09/11/24.
//

import Foundation
import UIKit

class ImageCache {
    
    static let shared = ImageCache()
    
    private let cache = NSCache<NSString, UIImage>()
    
    func getImage(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
    func saveImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
}