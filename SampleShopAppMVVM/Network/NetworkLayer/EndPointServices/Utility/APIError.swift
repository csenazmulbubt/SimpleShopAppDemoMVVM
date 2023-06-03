//
//  APIError.swift
//  SampleShopAppMVVM
//
//  Created by Nazmul on 02/06/2023.
//

import Foundation

enum APIError: Error {
    case invalidData
    case requestFailed
    case jsonConversionFailure
    case jsonParsingFailure
    case responseUnsuccessful
    case customErrorMessage(message: String)
    
    var localizedDescription: String {
        switch self {
        case .invalidData:
            return "Invalid Data"
        case .requestFailed:
            return "Request Failed"
        case .jsonConversionFailure:
            return "JSON Conversion Failure"
        case .jsonParsingFailure:
            return "JSON Parsing Failure"
        case .responseUnsuccessful:
            return "Response Unsuccessful"
        case .customErrorMessage(message: let message):
            return message
        }
    }
}

