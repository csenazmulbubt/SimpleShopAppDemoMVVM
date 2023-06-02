//
//  RequestProtocol.swift
//  SampleShopAppMVVM
//
//  Created by Nazmul on 01/06/2023.
//

import Foundation

protocol NetworkRequestProtocol: Any {
    var httpMethod: HTTPMethod {get set}
    var host: Host {get set}
    var scheme: Scheme {get set}
    var endPath: String? {get set}
    var headers: [String: String]? { get set}
    var queryParams: [String: String]? { get set}
    var url: URL {get}
    var urlRequest: URLRequest {get}
}

