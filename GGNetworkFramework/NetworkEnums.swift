//
//  NetworkEnums.swift
//  MPLPaymentModuleSDK
//
//  Created by Tapash Mollick on 10/06/22.
//

import Foundation

public enum HTTPMethod: String {
    case post = "POST"
    case get = "GET"
}

public enum APIResponse<T> {
    case success(T)
    case failure(NetworkError)
}

public enum NetworkError {
    case unauthorized
    case unknown
    case noJSONData
    case JSONDecoder
}
