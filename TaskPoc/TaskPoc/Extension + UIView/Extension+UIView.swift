//
//  Extension+UIView.swift
//  TaskPoc
//
//  Created by Prakash's Mac on 09/11/24.
//

import UIKit

extension UIView {
    
    // 1. Set corner radius for all corners
    @objc func setCornerRadius(_ radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
    // 2. Set view to a circle based on the minimum dimension (width or height)
    func makeCircular() {
        let radius = min(self.frame.size.width, self.frame.size.height) / 2
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
    func applyCardStyle(cornerRadius: CGFloat = 10.0, shadowColor: UIColor = .black, shadowOpacity: Float = 0.3, shadowOffset: CGSize = CGSize(width: 0, height: 4), shadowRadius: CGFloat = 6.0) {
          
          // Rounded corners
          self.layer.cornerRadius = cornerRadius
          self.layer.masksToBounds = false
          
          // Shadow properties
          self.layer.shadowColor = shadowColor.cgColor
          self.layer.shadowOpacity = shadowOpacity
          self.layer.shadowOffset = shadowOffset
          self.layer.shadowRadius = shadowRadius
          
          // Optional: Apply border if needed
          self.layer.borderWidth = 0.5
          self.layer.borderColor = UIColor.lightGray.cgColor
      }
    
    // 3. Apply tiling pattern to the background of the view
    func applyTiledBackground(with image: UIImage) {
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleToFill
        self.backgroundColor = .clear
        self.insertSubview(imageView, at: 0)
        
        // Make sure the imageView fills the entire view (tile effect)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            imageView.leftAnchor.constraint(equalTo: self.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: self.rightAnchor)
        ])
    }
}

