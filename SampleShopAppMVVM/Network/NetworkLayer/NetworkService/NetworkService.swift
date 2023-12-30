//
//  NetworkService.swift
//  SampleShopAppMVVM
//
//  Created by Nazmul on 02/06/2023.
//

import Foundation


class NetworkService: NSObject,NetworkServiceProtcol {
    
    
    func sendGetRequest<T: Decodable>(URLReuquestBuilder: URLRequestBuilder,
                                      decodingType: T.Type,
                                      completion: @escaping ResultBlock<T>) -> Void {
        
        guard let urlRequest = URLReuquestBuilder.urlRequest else {  completion(.failure(.customErrorMessage(message: "URLRequest Not Found")))
            return
        }
        
        sendRequestToServer(urlRequest: urlRequest, decodingType: decodingType, completion: completion)
    }
    
    func sendPostRequest<T: Decodable,
                         E: Encodable>(URLReuquestBuilder: URLRequestBuilder,
                                       encodingData: E,
                                       decodingType: T.Type,
                                       completion: @escaping ResultBlock<T>) -> Void {
        
        guard let data = JSONEncodingDecoding.EncodingData(of: encodingData) else{
            completion(.failure(.customErrorMessage(message: "JSONEncoding Fail")))
            return
        }
        
        guard let urlRequest = URLReuquestBuilder.urlRequest else {  completion(.failure(.customErrorMessage(message: "URLRequest Not Found")))
            return
        }
        var URLRequest = urlRequest
        URLRequest.httpBody = data
        sendRequestToServer(urlRequest: URLRequest, decodingType: decodingType, completion: completion)
    }
    
    private func sendRequestToServer<T: Decodable>(urlRequest: URLRequest,
                                                  decodingType: T.Type,
                                                  completion: @escaping ResultBlock<T>) -> Void {
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.requestFailed))
                return
            }
            
            guard 200..<300 ~= httpResponse.statusCode else {
                completion(.failure(.requestFailed))
                return
            }
            
            guard let actualData = data else {
                completion(.failure(.invalidData))
                return
            }
            
            JSONEncodingDecoding.DecodingData(of: decodingType, from: actualData, completion: completion)
        }
        task.resume()
    }
    
    func sendGetRequest(URLReuquestBuilder: URLRequest?)-> Void {
        
        guard let urlRequest = URLReuquestBuilder else {
            print("Error Found")
            return
        }
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            
            guard let httpResponse = response as? HTTPURLResponse else {
                //completion(.failure(.requestFailed))
                print("Failed request")
                return
            }
            
            guard 200..<300 ~= httpResponse.statusCode else {
                //completion(.failure(.requestFailed))
                print("Failed request 1")
                return
            }
            
            guard let actualData = data else {
                print("Failed request 2")
                return
            }
            
            let dataX = String(data: actualData, encoding: .utf8)
            print("Data-------",dataX)
            print("Data------- q",actualData.prettyPrintedJSONString)
        }
        task.resume()
    }
    
}

extension Data {
    var prettyPrintedJSONString: NSString? { /// NSString gives us a nice sanitized debugDescription
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }

        return prettyPrintedString
    }
}
