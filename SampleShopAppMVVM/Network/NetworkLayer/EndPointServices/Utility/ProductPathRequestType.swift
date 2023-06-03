//
//  EndPath.swift
//  SampleShopAppMVVM
//
//  Created by Nazmul on 01/06/2023.
//

import Foundation

public enum ProductPathRequestType {
    case getProducts,
         getProduct(productId: Int),
         getProductCatgeories,
         getproductCategory(categoryName: String),
         searchProduct,
         addProduct
    
    
    fileprivate var productBasePath: String {
        return "/products"
    }
    
    var path: String {
        switch self {
        case .getProducts:
            return productBasePath
        case .getProduct(let productId):
            return productBasePath + "/\(productId)"
        case .getProductCatgeories:
            return productBasePath + "/categories"
        case .getproductCategory(let categoryName):
            return productBasePath + "/categories" + "/\(categoryName)"
        case .searchProduct:
            return productBasePath + "/search"
        case .addProduct:
            return productBasePath + "/add"
        }
    }
}
