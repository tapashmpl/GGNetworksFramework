//
//  Service.swift
//  MPLPaymentModuleSDK
//
//  Created by Tapash Mollick on 10/06/22.
//

import Foundation

public protocol Service {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: RequestHeaders? { get }
    var parameters: Params { get }
    var urlQueryItems: [URLQueryItem]? { get }
    var mediaData: Data?  { get set } /// used only for  media uploads
}

