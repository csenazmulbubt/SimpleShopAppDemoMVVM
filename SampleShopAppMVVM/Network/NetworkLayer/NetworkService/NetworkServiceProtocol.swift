//
//  NetworkServiceProtocol.swift
//  SampleShopAppMVVM
//
//  Created by Nazmul on 02/06/2023.
//

import Foundation

typealias ResultBlock<T> = (Result <T, APIError>) -> Void

protocol NetworkServiceProtcol: AnyObject {
    
    func sendGetRequest<T: Decodable>(URLReuquestBuilder: URLRequestBuilder,
                                      decodingType: T.Type,
                                      completion: @escaping ResultBlock<T>) -> Void
}
