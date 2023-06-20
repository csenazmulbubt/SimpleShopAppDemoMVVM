//
//  ProductCartListViewModel.swift
//  SampleShopAppMVVM
//
//  Created by Nazmul on 04/06/2023.
//

import Foundation

protocol ProductCartListViewModelDelegate: AnyObject {
    func didReceiveCartOperationStatus(_ responseStatus: ResoponseStatus)
}

class ProductCartListViewModel  {
    
    weak var delegate: ProductCartListViewModelDelegate?
    
    private let debounce = Debounce(timeInterval: 0.5, queue: .global(qos: .userInitiated))
    private let cart: CartProtocol
    public var productCarts: ProductCartsResponse? = nil
    private let headers: [String: String] = ["Content-Type": "application/json"]
    private let networkService: NetworkServiceProtcol
    
    init(_ cart: CartProtocol,
         networkServiceProtocol: NetworkServiceProtcol) {
        self.cart = cart
        self.networkService = networkServiceProtocol
    }
    
    public var productCartList: [ProductCartResponse]? {
        return self.productCarts?.products
    }
    
    func addToCart(_ product: ProductCart) -> Void {
        self.cart.addToCart(product)
        debounce.dispatch { [weak self] in
            guard let self = self else { return }
            self.startCartPostRequest()
        }
    }
    
    func removeFromCart(_ product: ProductCart) -> Void {
        self.cart.removeFromCart(product)
        debounce.dispatch { [weak self] in
            guard let self = self else { return }
            self.startCartPostRequest()
        }
    }
    
    private func startCartPostRequest() -> Void {
        let productCarts = ProductCarts(userId: 5, products: cart.cartItems)
        
        let requestURLBuilder = URLRequestBuilder.makeURLRequestBuilder(nil,
                                                                        httpMethod: .post,
                                                                        host: .dummyHost,
                                                                        scheme: .https,
                                                                        endPath: ProductCartPathRequestType.addCart.path,
                                                                        headers: headers)
        self.networkService.sendPostRequest(
            URLReuquestBuilder: requestURLBuilder,
            encodingData: productCarts,
            decodingType: ProductCartsResponse.self) {
                [weak self]  result in
                guard let self = self else { return }
                
                switch result {
                case .success(let productCarts):
                    self.productCarts = productCarts
                    self.delegate?.didReceiveCartOperationStatus(.success)
                    break
                case .failure(let error):
                    self.delegate?.didReceiveCartOperationStatus(.failure(error.localizedDescription))
                    break
                }
            }
    }
    
    deinit {
        print("Cart deinit")
    }
}
