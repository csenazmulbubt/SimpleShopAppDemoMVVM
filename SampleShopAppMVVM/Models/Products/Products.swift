//
//  Products.swift
//  SampleShopAppMVVM
//
//  Created by Nazmul on 02/06/2023.
//

import Foundation

struct Products: Decodable {
    let products: [Product]
    let total, skip, limit: Int
}

struct Product: Decodable {
    let id: Int
    let title, description: String
    let price: Int
    let discountPercentage, rating: Double
    let stock: Int
    let brand, category: String
    let thumbnail: String
    let images: [String]
}
