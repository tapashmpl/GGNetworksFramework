//
//  URLComponents+Extensions.swift
//  MPLPaymentModuleSDK
//
//  Created by Tapash Mollick on 10/06/22.
//

import Foundation

extension URLComponents {
   public init(service: Service) {
        let url = service.baseURL.appendingPathComponent(service.path)
        self.init(url: url, resolvingAgainstBaseURL: false)!
//        let completePath = service.path.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
//        let url = service.baseURL.appendingPathComponent(service.path).description.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
//        debugPrint("url########\(url)")
        self.queryItems = service.urlQueryItems
//        let url = "https://qapi.mpl.live/payments/partnerCustomerDetails?partners=JUSPAY"
//        let completePath = url.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
//        self.init(url: URL(string: completePath!)!, resolvingAgainstBaseURL: false)!

//        self.init(url: url, resolvingAgainstBaseURL: false)!
    }
}

//
//init(service: Service) {
//    let completeURL = (service.baseURL.absoluteString + service.path).addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
////        let url = service.baseURL.appendingPathComponent(completePath!)
//    if let url = URL.init(string: completeURL!) {
//        self.init(url: url, resolvingAgainstBaseURL: false)!
//    }
