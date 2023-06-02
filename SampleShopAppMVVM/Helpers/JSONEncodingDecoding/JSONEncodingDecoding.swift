//
//  JSONEncodingDecoding.swift
//  SampleShopAppMVVM
//
//  Created by Nazmul on 02/06/2023.
//
//HelpLink https://stackoverflow.com/questions/60046750/swift-generic-json-parser

import Foundation

class JSONEncodingDecoding {

    class func DecodingData<T: Decodable>(of type: T.Type,
                                      from data: Data,
                                      completion: @escaping ResultBlock<T>) {
        do {
            let JSONDecoder = JSONDecoder()
            JSONDecoder.keyDecodingStrategy = .convertFromSnakeCase
            let decodedData: T = try JSONDecoder.decode(T.self, from: data)
            completion(.success(decodedData))
        }
        catch {
            completion(.failure(APIError.jsonConversionFailure))
        }
    }
}
