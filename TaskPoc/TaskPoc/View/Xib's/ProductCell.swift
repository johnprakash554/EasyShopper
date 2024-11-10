//
//  ProductCell.swift
//  TaskPoc
//
//  Created by Prakash's Mac on 09/11/24.
//

import UIKit

class ProductCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var productImg: UIImageView!
    @IBOutlet weak var productView: UIView!
    @IBOutlet weak var favouriteBtn: UIButton!
    
    var viewModel = ProductViewModel()

    var heartButtonAction: (() -> Void)?
    
    var isFavourite: Bool = false
    
    private let xImage = UIImage(named: "fav")
        private let yImage = UIImage(named: "favorite (1)")
    override func awakeFromNib() {
        super.awakeFromNib()
        favouriteBtn.makeCircular()
        productView.applyCardStyle(cornerRadius: 15.0, shadowColor: .gray, shadowOpacity: 0.5, shadowOffset: CGSize(width: 0, height: 3), shadowRadius: 10.0)
    }
    @IBAction func heartButtonTapped(_ sender: UIButton) {
        favouriteBtn.isSelected.toggle()
        isFavourite.toggle()
        if isFavourite {
            favouriteBtn.setImage(yImage, for: .normal)
        } else {
            favouriteBtn.setImage(xImage, for: .normal)
        }
        heartButtonAction?()
    }
    func configureCell(with product: Product) {
        favouriteBtn.setImage(xImage, for: .normal)
        isFavourite = false
        titleLbl.text = product.title
        priceLbl.text = "$\(product.price)"
        ratingLbl.text = "Rating: \(product.rating.rate)"
        self.setPriceWithDiscount(originalPrice: Double(product.rating.count), discountedPrice: product.price, originalLabel: priceLbl, discountedLabel: ratingLbl)
        if let cartItem = viewModel.cartItems.first(where: { $0.product.id == product.id }) {
            favouriteBtn.isSelected = cartItem.isInCart
        }
        let imageUrlString = product.image
        if let cachedImage = ImageCache.shared.getImage(forKey: imageUrlString) {
            productImg.image = cachedImage
        } else {
            // Load the image asynchronously if not cached
            DispatchQueue.global().async {
                if let url = URL(string: imageUrlString), let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                    // Cache the image
                    ImageCache.shared.saveImage(image, forKey: imageUrlString)
                    
                    // Update the UI on the main thread
                    DispatchQueue.main.async {
                        self.productImg.image = image
                    }
                }
            }
        }
    }
    func setPriceWithDiscount(originalPrice: Double, discountedPrice: Double, originalLabel: UILabel, discountedLabel: UILabel) {
        let originalPriceText = "$\(originalPrice)"
        let discountedPriceText = "$\(discountedPrice)"
        
        // Apply strikethrough to original price label
        let strikethroughAttributes: [NSAttributedString.Key: Any] = [
            .strikethroughStyle: NSUnderlineStyle.single.rawValue,
            .strikethroughColor: UIColor.red,
            .foregroundColor: UIColor.gray
        ]
        let originalAttributedString = NSAttributedString(string: originalPriceText, attributes: strikethroughAttributes)
        ratingLbl.attributedText = originalAttributedString
        
        // Set discounted price without strikethrough
        priceLbl.text = discountedPriceText
    }
}
