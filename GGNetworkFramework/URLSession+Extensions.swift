//
//  URLSession+Extensions.swift
//  MPLPaymentModuleSDK
//
//  Created by Tapash Mollick on 10/06/22.
//

import Foundation

extension URLSession: URLSessionProtocol {
   public func dataTask(request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTask {
        return dataTask(with: request, completionHandler: completionHandler)
    }
}
