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
   
    weak var delegate: ProductViewModelDelegate?
   
    private let networkService: NetworkServiceProtcol
    private var products: Products? = nil
    public var hasMorePage: Bool = true
    public var productArray: [Product] = []
    private var currentResponseStatus: ResoponseStatus = .success
    
    init(_ networkService: NetworkServiceProtcol) {
        self.networkService = networkService
    }
    
    public var isNeedLoadMorePage: Bool {
        return productArray.count > 0 && hasMorePage
    }
    
    func startProductRequest(URLReuquestBuilder: URLRequestBuilder) {
        
        self.delegate?.didReceiveProductResponseStatus(.loading)
        self.networkService.sendGetRequest(URLReuquestBuilder: URLReuquestBuilder,
                                           decodingType: Products.self) {
            [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let products):
                    self.currentResponseStatus = .success
                    self.calculateMorePage(newProducts: products)
                case .failure(let error):
                    self.currentResponseStatus = .failure(error.localizedDescription)
                }
                self.delegate?.didReceiveProductResponseStatus(self.currentResponseStatus)
            }
        }
    }
    
    private func calculateMorePage(newProducts: Products) -> Void {
        
        guard let oldProducts = self.products else {
            self.products = newProducts
            self.productArray = self.products!.products
            self.hasMorePage = (productArray.count < newProducts.total) ? true : false
            return
        }
        
        if productArray.count < oldProducts.total {
            productArray += newProducts.products
            self.hasMorePage = (productArray.count < oldProducts.total) ? true : false
        }
        else {
            self.hasMorePage = false
        }
    }
    
    
    public func makeURLRequestBuilder(_ parameters: [String: String],
                                      httpMethod: HTTPMethod,
                                      host: Host,
                                      scheme: Scheme,
                                      endPath: String,
                                      headers: [String: String]? = nil) -> URLRequestBuilder {
        
        var paraDictArray = parameters
        paraDictArray["skip"] = "\(productArray.count)"
        
        return URLRequestBuilder(httpMethod: httpMethod,
                                 host: host,
                                 scheme: scheme,
                                 endPath: endPath,
                                 headers: headers,
                                 queryParams: paraDictArray)
    }
    
}
