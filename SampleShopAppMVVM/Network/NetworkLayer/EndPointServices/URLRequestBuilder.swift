//
//  EndPoint.swift
//  SampleShopAppMVVM
//
//  Created by Nazmul on 01/06/2023.
//

import Foundation

struct URLRequestBuilder {
    
    var httpMethod: HTTPMethod
    var host: Host
    var scheme: Scheme
    var endPath: String? = nil
    var headers: [String : String]? = nil
    var queryParams: [String : String]? = nil
    var mockBaseUrl: URL? = nil //This Needs When You are using UnitTest
    
    var url: URL? {
        var components = URLComponents()
        components.scheme = scheme.rawValue
        components.host = host.rawValue
        components.path = endPath ?? ""
        components.queryItems = queryParams?.compactMap({ key,value in
            return URLQueryItem(name: key, value: value)
        })
        guard let url = components.url else {
          return nil
        }
        return url
    }
    
    var urlRequest: URLRequest? {
        guard let url = self.url else {
          return nil
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.timeoutInterval = 15
        urlRequest.httpMethod = httpMethod.rawValue
        guard let headers = headers else {
            return urlRequest
        }
        headers.forEach { key,Value in
            urlRequest.addValue(Value, forHTTPHeaderField: key)
        }
        return urlRequest
    }
}
