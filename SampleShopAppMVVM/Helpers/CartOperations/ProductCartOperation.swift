//
//  Cart.swift
//  SampleShopAppMVVM
//
//  Created by Nazmul on 04/06/2023.
//

import Foundation

class ProductCartOperation: CartProtocol {
    
    private var items: [ProductCart] = []
    
    var cartItems: [ProductCart] {
        return items
    }
    
    func addToCart(_ product: ProductCart) {
        if let index = items.firstIndex(where: { $0.id == product.id }) {
            items[index].quantity += 1
            return
        }
        items.append(product)
    }
    
    func removeFromCart(_ product: ProductCart) {
        if let index = items.firstIndex(where: { $0.id == product.id}) {
            guard items[index].quantity > 0 else {
                items.remove(at: index)
                return
            }
            items[index].quantity -= 1
            return
        }
    }
    
    func clearCart() {
        items.removeAll()
    }
}


/*class CartViewModel: where CartProtocol == ProductCart {
    private let cart: CartProtocol
    
    init(cart: CartProtocol) {
        self.cart = cart
    }
    
    func addToCart(_ product: Product) {
        cart.addToCart(product)
    }
    
    func removeFromCart(_ product: Product) {
        cart.removeFromCart(product)
    }
    
    func clearCart() {
        cart.clearCart()
    }
}*/





