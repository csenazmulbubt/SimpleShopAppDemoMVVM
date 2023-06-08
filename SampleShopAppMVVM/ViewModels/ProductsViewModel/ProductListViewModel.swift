//
//  ProductViewModel.swift
//  SampleShopAppMVVM
//
//  Created by Nazmul on 02/06/2023.
//

import Foundation

protocol ProductListViewModelDelegate: NSObjectProtocol {
    func didReceiveProductResponseStatus(_ Response: ResoponseStatus)
    func didReceiveCartOperationStatus(responseStatus: ResoponseStatus)
}

class ProductListViewModel {
    
    weak var delegate: ProductListViewModelDelegate?
    
    private let networkService: NetworkServiceProtcol
    private var products: Products? = nil
    public var hasMorePage: Bool = true
    public var productArray: [Product] = []
    private var currentResponseStatus: ResoponseStatus = .success
    public var productCartListViewModel: ProductCartListViewModel? = nil
    
    init(_ networkService: NetworkServiceProtcol,
         cartService: CartProtocol? = nil) {
        self.networkService = networkService
        if let cartService = cartService {
            self.productCartListViewModel = ProductCartListViewModel(cartService, networkServiceProtocol: networkService)
            self.productCartListViewModel?.delegate = self
        }
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
    
    func addToCart(_ productId: Int) -> Void {
        if let _ = self.productArray.firstIndex(where: { $0.id == productId}){
            self.applyCartOperation(isRemove: false, product: ProductCart(id: productId, quantity: 1))
        }
    }
    
    func removeToCart(_ productId: Int) -> Void {
        if let _ = self.productArray.firstIndex(where: { $0.id == productId}){
            self.applyCartOperation(isRemove: true, product: ProductCart(id: productId, quantity: 1))
        }
    }
    
    private func applyCartOperation(isRemove: Bool,
                                    product: ProductCart) -> Void {
        guard let productCartListViewModel = self.productCartListViewModel else { return  }
        
        if isRemove {
            productCartListViewModel.removeFromCart(product)
        }
        else {
            productCartListViewModel.addToCart(product)
        }
    }
    
    func getTotalCartItem() -> Int {
        return self.productCartListViewModel?.productCarts?.totalQuantity ?? 0
    }
    
    func getProductListBasedOnCartItems() -> [Product] {
        guard let cartProducts = self.productCartListViewModel?.productCarts?.products else { return [] }
        let cartProductIDs = cartProducts.map { $0.id }
        return self.productArray.filter { cartProductIDs.contains($0.id) }
    }
}

//MARK: - ProductCartListViewModelProtocol
extension ProductListViewModel: ProductCartListViewModelDelegate {
    
    func didReceiveCartOperationStatus(_ responseStatus: ResoponseStatus) {
        delegate?.didReceiveCartOperationStatus(responseStatus: responseStatus)
    }
}
