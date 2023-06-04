//
//  ProductCartPathRequestType.swift
//  SampleShopAppMVVM
//
//  Created by Nazmul on 04/06/2023.
//

import Foundation

public enum ProductCartPathRequestType {
    case addCart
    
    fileprivate var cartsBasePath: String {
        return "/carts"
    }
    
    var path: String {
        switch self {
        case .addCart:
            return cartsBasePath + "/add"
        }
    }
}
