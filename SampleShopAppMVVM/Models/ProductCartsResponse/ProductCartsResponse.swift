//
//  ProductCartResponse.swift
//  SampleShopAppMVVM
//
//  Created by Nazmul on 04/06/2023.
//

import Foundation

struct ProductCartsResponse: Decodable {
    let id: Int
    let products: [ProductCartResponse]
    let total, discountedTotal, userId, totalProducts: Int
    let totalQuantity: Int
}

// MARK: - Product
struct ProductCartResponse: Decodable {
    let id: Int
    let title: String
    let price, quantity, total: Int
    let discountPercentage: Double
    let discountedPrice: Int
}
