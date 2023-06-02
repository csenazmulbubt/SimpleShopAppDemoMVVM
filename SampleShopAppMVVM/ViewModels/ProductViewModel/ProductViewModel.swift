//
//  ProductViewModel.swift
//  SampleShopAppMVVM
//
//  Created by Nazmul on 02/06/2023.
//

import Foundation

protocol ProductViewModelDelegate: NSObjectProtocol {
    func didReceiveProductResponseStatus(_ Response: ResoponseStatus)
}

class ProductViewModel {
   
    private let networkService: NetworkServiceProtcol
    
    var products: Products? = nil
    weak var delegate: ProductViewModelDelegate?
    
    init(_ networkService: NetworkServiceProtcol) {
        self.networkService = networkService
    }
    
    func getProducts(URLReuquestBuilder: URLRequestBuilder) {
        
        self.networkService.sendGetRequest(URLReuquestBuilder: URLReuquestBuilder,
                                           decodingType: Products.self) {
            [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let products):
                self.products = products
                self.productSetup()
                self.delegate?.didReceiveProductResponseStatus(.success)
            case .failure(let error):
                self.delegate?.didReceiveProductResponseStatus(.failure(error.localizedDescription))
            }
        }
    }
    
    private func productSetup() -> Void {
        
        guard let products = products else {
            return
        }
        
        products.products.forEach { product in
            print("PPPP",product.id,product.title)
        }
    }
}
