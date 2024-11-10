//
//  Extension+UIButton.swift
//  TaskPoc
//
//  Created by Prakash's Mac on 09/11/24.
//

import UIKit

//extension UIButton {
//
//    // 1. Set corner radius for the button
//    func setCornerRadius(_ radius: CGFloat) {
//        self.layer.cornerRadius = radius
//        self.layer.masksToBounds = true
//    }
//
//    // 2. Make the button circular (based on the minimum dimension)
//    func makeCircular() {
//        let radius = min(self.frame.size.width, self.frame.size.height) / 2
//        self.layer.cornerRadius = radius
//        self.layer.masksToBounds = true
//    }
//
//    // 3. Apply tiled background image
//    func applyTiledBackground(with image: UIImage) {
//        let imageView = UIImageView(image: image)
//        imageView.contentMode = .scaleToFill
//        self.backgroundColor = .clear
//        self.insertSubview(imageView, at: 0)
//        
//        // Make sure the imageView f      ills the entire button
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            imageView.topAnchor.constraint(equalTo: self.topAnchor),
//            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
//            imageView.leftAnchor.constraint(equalTo: self.leftAnchor),
//            imageView.rightAnchor.constraint(equalTo: self.rightAnchor)
//        ])
//    }
//}

