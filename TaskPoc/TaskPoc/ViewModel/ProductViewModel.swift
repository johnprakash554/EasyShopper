//
//  ProductViewModel.swift
//  TaskPoc
//
//  Created by Prakash's Mac on 09/11/24.
//

import Foundation

class ProductViewModel {
    
    private var productService = ProductService()
    
    var products: [Product] = []
    var cartItems: [CartItem] = []
    var categories = [String]()
    
    // Closure to notify when data is fetched and ready to be displayed
    
    var onDataFetched: (() -> Void)?
    var onError: ((String) -> Void)?
    
    // Fetch products from API
    func fetchProducts() {
        productService.fetchProducts { [weak self] result in
            switch result {
            case .success(let fetchedProducts):
                self?.products = fetchedProducts
                self?.cartItems = fetchedProducts.map { CartItem(product: $0, isInCart: false) }
                for i in fetchedProducts{
                    self!.categories.append(i.category)
                    self?.categories = Array(Set((self?.categories)!))
                }
                DispatchQueue.main.async {
                    self?.onDataFetched?()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.onError?(error.localizedDescription)
                }
            }
        }
    }
    
    // Toggle cart status for a product
    func toggleCart(for productId: Int) {
        if let index = cartItems.firstIndex(where: { $0.product.id == productId }) {
            cartItems[index].isInCart.toggle()
        }
    }
    
    // Get the number of items in the cart
    func cartItemCount() -> Int {
        return cartItems.filter { $0.isInCart }.count
    }
}
