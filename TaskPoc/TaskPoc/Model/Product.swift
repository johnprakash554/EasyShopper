//
//  Product.swift
//  TaskPoc
//
//  Created by Prakash's Mac on 09/11/24.
//

import Foundation

// The model representing a Product
struct Product: Decodable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let category: String
    let image: String
    let rating: Rating
}

// ratings
struct Rating: Decodable {
    let rate: Double
    let count: Int
}

// Cart item model
struct CartItem {
    let product: Product
    var isInCart: Bool
}

