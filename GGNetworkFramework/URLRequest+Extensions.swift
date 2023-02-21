//
//  URLRequest+Extensions.swift
//  MPLPaymentModuleSDK
//
//  Created by Tapash Mollick on 10/06/22.
//

import Foundation

extension URLRequest {
    public init(service: Service) {
        let urlComponents = URLComponents(service: service)
        self.init(url: urlComponents.url!)
        httpMethod = service.method.rawValue
        
        service.headers??.forEach { key, value in
            addValue(value, forHTTPHeaderField: key)
        }
        if let data = service.mediaData {
            httpBody = data
        }
        else if let params = service.parameters {
            httpBody = try? JSONSerialization.data(withJSONObject: params)
        }
    }
}
