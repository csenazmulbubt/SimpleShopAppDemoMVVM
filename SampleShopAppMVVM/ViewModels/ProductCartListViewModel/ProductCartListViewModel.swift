//
//  ProductCartListViewModel.swift
//  SampleShopAppMVVM
//
//  Created by Nazmul on 04/06/2023.
//

import Foundation

protocol ProductCartListViewModelProtocol: AnyObject {
    func cartOperationStatus(_ responseStatus: ResoponseStatus)
}

class ProductCartListViewModel  {
    
   
    weak var delegate: ProductCartListViewModelProtocol?
    
    let debounce = Debounce(timeInterval: 0.5, queue: .global(qos: .userInitiated))
    private let cart: CartProtocol
    private var productCarts: ProductCartsResponse? = nil
    private let headers: [String: String] = ["Content-Type": "application/json"]
    private let networkService: NetworkServiceProtcol
    
    init(_ cart: CartProtocol,
         networkServiceProtocol: NetworkServiceProtcol) {
        self.cart = cart
        self.networkService = networkServiceProtocol
    }
    
    func addToCart(_ product: ProductCart) -> Void {
        print("StartpOst rqu")
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
        let productCarts = ProductCarts(userId: 1, products: cart.cartItems)
       
        let requestURLBuilder = makeCartPostURLRequestBuilder(nil,
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
                    print("Product",productCarts)
                    self.productCarts = productCarts
                    break
                case .failure(let error):
                    break
                }
            }
    }
    
    private func makeCartPostURLRequestBuilder(_ parameters: [String: String]? = nil,
                                       httpMethod: HTTPMethod,
                                       host: Host,
                                       scheme: Scheme,
                                       endPath: String,
                                       headers: [String: String]? = nil) -> URLRequestBuilder {
        
        return URLRequestBuilder(httpMethod: httpMethod,
                                 host: host,
                                 scheme: scheme,
                                 endPath: endPath,
                                 headers: headers,
                                 queryParams: parameters)
    }
}
