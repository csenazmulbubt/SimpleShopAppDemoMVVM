//
//  ResponseState.swift
//  SampleShopAppMVVM
//
//  Created by Nazmul on 02/06/2023.
//

import Foundation

public enum ResoponseStatus: Equatable {
    case loading
    case success
    case failure(_ errorMessage: String)
}
