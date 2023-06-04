//
//  CartProtocol.swift
//  SampleShopAppMVVM
//
//  Created by Nazmul on 04/06/2023.
//

import Foundation

protocol CartProtocol: AnyObject {
    var cartItems: [ProductCart] { get }
    func addToCart(_ product: ProductCart)
    func removeFromCart(_ product: ProductCart)
    func clearCart()
}
