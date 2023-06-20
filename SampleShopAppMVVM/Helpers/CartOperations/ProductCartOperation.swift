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
        return items.sorted { $0.id < $1.id }
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






