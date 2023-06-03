//
//  SearchProductViewModel.swift
//  SampleShopAppMVVM
//
//  Created by Nazmul on 03/06/2023.
//

import Foundation

protocol SearchProductListViewModelDelegate: AnyObject {
    func didReceiveProductResponseStatus(_ response: ResoponseStatus)
}

class SearchProductListViewModel {
    
    weak var delegate: SearchProductListViewModelDelegate?
    
    private let networkService: NetworkServiceProtcol
    private var products: Products? = nil
    private var currentResponseStatus: ResoponseStatus = .success
    private var searchText: String = ""
    public var hasMorePage: Bool = false
    public var productArray: [Product] = []
    
    let searchDebounce = Debounce(timeInterval: 0.5, queue: .global(qos: .userInitiated))
    
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
    
    func startSearchRequest(URLReuquestBuilder: URLRequestBuilder,
                            searchText: String = "") -> Void {
        
        self.searchText = searchText
        
        self.searchDebounce.dispatch {
            if !self.searchText.isEmpty {
                self.reset()
                self.requestForSearchProduct(URLReuquestBuilder: URLReuquestBuilder)
            }
            else {
                self.forcelyResetWhenSearchTextEmpty()
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
        searchDebounce.dispatch {
            self.currentResponseStatus = .loading
            if !self.searchText.isEmpty {
                self.sendRequest(URLReuquestBuilder: URLReuquestBuilder)
            }
            else {
                self.forcelyResetWhenSearchTextEmpty()
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
    
    private func reset() -> Void {
        self.hasMorePage = false
        self.products = nil
        self.productArray.removeAll()
    }
    
    private func forcelyResetWhenSearchTextEmpty() -> Void {
        self.reset()
        self.currentResponseStatus = .success
        self.delegate?.didReceiveProductResponseStatus(self.currentResponseStatus)
    }
}

//MARK: - MakeURLRequestBuilder
extension SearchProductListViewModel {
    
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
