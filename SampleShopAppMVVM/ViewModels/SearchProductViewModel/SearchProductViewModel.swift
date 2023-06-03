//
//  SearchProductViewModel.swift
//  SampleShopAppMVVM
//
//  Created by Nazmul on 03/06/2023.
//

import Foundation

protocol SearchProductViewModelDelegate: AnyObject {
    func didReceiveProductResponseStatus(_ response: ResoponseStatus)
}

class SearchProductViewModel {
    
    weak var delegate: SearchProductViewModelDelegate?
    
    private let networkService: NetworkServiceProtcol
    private var products: Products? = nil
    public var hasMorePage: Bool = false
    public var productArray: [Product] = []
    private var currentResponseStatus: ResoponseStatus = .success
    private var searchText: String = ""
    
    let debounce = Debounce(timeInterval: 0.5, queue: .global(qos: .userInitiated))
    
    init(_ networkService: NetworkServiceProtcol) {
        self.networkService = networkService
    }
    
    public var isNeedLoadMorePage: Bool {
        return productArray.count > 0 && hasMorePage
    }
    
    public var isAvailableProduct: Bool {
        return productArray.isEmpty
    }
    
    public var isSearchBoxEmpty: Bool {
        return searchText.isEmpty
    }
    
    private func reset() -> Void {
        self.hasMorePage = false
        self.products = nil
        self.productArray.removeAll()
        
    }
    
    func startSearchRequest(URLReuquestBuilder: URLRequestBuilder,
                            searchText: String = "") -> Void {
        
        self.searchText = searchText
        debounce.dispatch {
            if !self.searchText.isEmpty {
                self.reset()
                self.requestForSearchProduct(URLReuquestBuilder: URLReuquestBuilder)
            }
            else {
                self.reset()
                self.currentResponseStatus = .success
                self.delegate?.didReceiveProductResponseStatus(self.currentResponseStatus)
            }
        }
    }
    
    private func requestForSearchProduct(URLReuquestBuilder: URLRequestBuilder) {
        self.currentResponseStatus = .loading
        self.delegate?.didReceiveProductResponseStatus(self.currentResponseStatus)
        self.sendRequest(URLReuquestBuilder: URLReuquestBuilder)
    }
    
    private func sendRequest(URLReuquestBuilder: URLRequestBuilder) -> Void {
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
    
    func loadMorePage(URLReuquestBuilder: URLRequestBuilder) -> Void {
        self.currentResponseStatus = .loading
        if !searchText.isEmpty {
            self.sendRequest(URLReuquestBuilder: URLReuquestBuilder)
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