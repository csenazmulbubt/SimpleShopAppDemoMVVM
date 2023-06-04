//
//  ProductCart.swift
//  SampleShopAppMVVM
//
//  Created by Nazmul on 04/06/2023.
//

import Foundation

struct ProductCarts: Codable {
    var userId: Int
    var products: [ProductCart]
}

struct ProductCart: Codable {
    var id: Int
    var quantity: Int
}
