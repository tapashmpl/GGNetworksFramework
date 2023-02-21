//
//  URLSessionProtocol.swift
//  MPLPaymentModuleSDK
//
//  Created by Tapash Mollick on 10/06/22.
//

import Foundation

public protocol URLSessionProtocol {
    func dataTask(request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTask
}
