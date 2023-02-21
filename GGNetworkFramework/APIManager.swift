//
//  APIManager.swift
//  GGNetworkFramework
//
//  Created by Tapash Mollick on 21/02/23.
//

import Foundation
import Security
import CommonCrypto

open class APIManager {
    var session: URLSessionProtocol
    public init(session: URLSession = URLSession.shared) {
        self.session = URLSession.shared
    }

    public init(sessionConfiguration: URLSessionConfiguration, pinnedCertificateHash: String? = nil, pinnedPublicKeyHash: String? = nil) {
        if let pinnedCertificateHash = pinnedCertificateHash, let pinnedPublicKeyHash = pinnedPublicKeyHash {
            let session = URLSession(configuration: sessionConfiguration, delegate: NSURLSessionPinningDelegate(with: pinnedCertificateHash, pinnedPublicKeyHash: pinnedPublicKeyHash), delegateQueue: nil)
            //self.init(session: session)
            self.session = session
        }
        else { //self.init(session: URLSession.shared)
            self.session = URLSession.shared
        }
    }

    /* public convenience init(sessionConfiguration: URLSessionConfiguration, pinnedCertificateHash: String? = nil, pinnedPublicKeyHash: String? = nil) {
     if let pinnedCertificateHash = pinnedCertificateHash, let pinnedPublicKeyHash = pinnedPublicKeyHash {
     let session = URLSession(configuration: sessionConfiguration, delegate: NSURLSessionPinningDelegate(with: pinnedCertificateHash, pinnedPublicKeyHash: pinnedPublicKeyHash), delegateQueue: nil)
     self.init(session: session)
     }
     else { self.init(session: URLSession.shared) }
     }*/

    /*open func request<T>(type: T.Type, service: Service, completion: @escaping (APIResponse<T>) -> ()) where T: Decodable {
     let request = URLRequest(service: service)
     debugPrint("request url: \(request.url) \t Paramas: \(service.parameters) \n")
     let task = session.dataTask(request: request, completionHandler: {[unowned self] data, response, error in
     debugPrint("\n Response$$$$$$$$$ \(String(decoding: data!, as: UTF8.self))")
     let httpResponse = response as? HTTPURLResponse
     self.handleDataResponse(data: data, response: httpResponse, error: error, completion: completion)
     })
     task.resume()
     }*/
    open func request(service: Service, completion: @escaping (Data?, HTTPURLResponse?, Error?) -> ()) {
        let request = URLRequest(service: service)
        debugPrint("request url: \(request.url)")
        debugPrint("\nrequest Paramas: \(service.parameters) \n")
        debugPrint("\n request header: \(request.allHTTPHeaderFields)")
        let task = session.dataTask(request: request, completionHandler: { [unowned self] data, response, error in
            if let data = data {
                debugPrint("\n Response$$$$$$$$$ \(String(decoding: data, as: UTF8.self))")
            }
            let httpResponse = response as? HTTPURLResponse
            completion(data, httpResponse, error)
        })
        task.resume()
    }

    /*public func handleDataResponse<T: Decodable>(data: Data?, response: HTTPURLResponse?, error: Error?, completion: (APIResponse<T>) -> ()) {
     guard error == nil else { return completion(.failure(.unknown)) }
     guard let response = response, let data = data else { return completion(.failure(.noJSONData)) }
     switch response.statusCode {
     case 200...299:
     do {
     guard let model = try? JSONDecoder().decode(T.self, from: data) else { return }
     completion(.success(model))
     } catch (_) {
     completion(.failure(.JSONDecoder))
     }
     case 401:
     completion(.failure(.unauthorized))
     default:
     completion(.failure(.unknown))
     }
     }*/


    open func requestData(service: Service, completion: @escaping (Any?, Data?, Error?) -> ()) {
        let request = URLRequest(service: service)
        debugPrint("\n request url: \(request.url) \n Paramas: \(service.parameters) \n request headers####### \(request.allHTTPHeaderFields)")
        let task = session.dataTask(request: request, completionHandler: {[weak self] data, response, error in
            if let data = data {
                let json = try? JSONSerialization.jsonObject(with: data, options: .init(rawValue: 0))
                if  json != nil {
                    if json is [AnyHashable: Any] {
                        let jsonResponse = json as! [AnyHashable: Any]
                        let responseCode = !(json is NSNumber) ? (jsonResponse["success"] as? Int):0
                        debugPrint("\n Response$$$$$$$$$ \(jsonResponse)")
                        completion(jsonResponse, data, error)
                    }
                }
            }
            else {
                completion(nil, data, error)
            }
        })
        task.resume()
    }

    /*open func request(service: Service, completion: @escaping (Data?, HTTPURLResponse?, Error?) -> ()) {
     let request = URLRequest(service: service)
     debugPrint("\n request url: \(request.url) \n Paramas: \(service.parameters) \n request headers####### \(request.allHTTPHeaderFields)")
     let task = session.dataTask(request: request, completionHandler: { [weak self] data, response, error in
     let httpResponse = response as? HTTPURLResponse
     completion(data, httpResponse, error)
     })
     task.resume()
     }*/
}

//*************************************************
class NSURLSessionPinningDelegate: NSObject, URLSessionDelegate {

    //   static let shared = NSURLSessionPinningDelegate()
    /*
     "pinned cert hash == r/mIkG3eEpVdm+u/ko/cwxzOMo1bk4TyHIlByibiA5E="
     "pinned cert hash == qG8bcr0nB3jax8y5ITeXg63KROslai65SNB8K8O4oj8="
     "pinned cert hash1 == r/mIkG3eEpVdm+u/ko/cwxzOMo1bk4TyHIlByibiA5E="
     "pinned cert hash1 == qG8bcr0nB3jax8y5ITeXg63KROslai65SNB8K8O4oj8="
     */
    //    var session: URLSessionProtocol
    var pinnedCertificateHash: String
    var pinnedPublicKeyHash: String
    // let pinnedCertificateHash = "r/mIkG3eEpVdm+u/ko/cwxzOMo1bk4TyHIlByibiA5E=" // "r/mIkG3eEpVdm+u/ko/cwxzOMo1bk4TyHIlByibiA5E="
    //let pinnedPublicKeyHash = "qG8bcr0nB3jax8y5ITeXg63KROslai65SNB8K8O4oj8=" // "qG8bcr0nB3jax8y5ITeXg63KROslai65SNB8K8O4oj8="  // "qG8bcr0nB3jax8y5ITeXg63KROslai65SNB8K8O4oj8="

    public init(with pinnedCertificateHash: String, pinnedPublicKeyHash: String) {
        self.pinnedCertificateHash = pinnedCertificateHash
        self.pinnedPublicKeyHash = pinnedPublicKeyHash
    }

    let rsa2048Asn1Header: [UInt8] = [
        0x30, 0x82, 0x01, 0x22, 0x30, 0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86,
        0xf7, 0x0d, 0x01, 0x01, 0x01, 0x05, 0x00, 0x03, 0x82, 0x01, 0x0f, 0x00
    ]
    private func sha256(data: Data) -> String {
        var keyWithHeader = Data(bytes: rsa2048Asn1Header)
        keyWithHeader.append(data)
        var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        keyWithHeader.withUnsafeBytes {
            _ = CC_SHA256($0, CC_LONG(keyWithHeader.count), &hash)
        }
        return Data(hash).base64EncodedString()
    }

    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void) {
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            if let serverTrust = challenge.protectionSpace.serverTrust {
                var secresult = SecTrustResultType.invalid
                let status = SecTrustEvaluate(serverTrust, &secresult)
                if errSecSuccess == status {
                    debugPrint(SecTrustGetCertificateCount(serverTrust))
                    if let serverCertificate = SecTrustGetCertificateAtIndex(serverTrust, 0) {
                        //             Certificate pinning, uncomment to use this instead of public key pinning
                        let serverCertificateData: NSData = SecCertificateCopyData(serverCertificate)
                        let certHash = sha256(data: serverCertificateData as Data)

                        if certHash == pinnedCertificateHash {
                            // Success! This is our server
                            completionHandler(.useCredential, URLCredential(trust: serverTrust))
                            return
                        }
                        // Public key pinning
                        if #available(iOS 10.3, *) {
                            let serverPublicKey = SecCertificateCopyPublicKey(serverCertificate)
                            let serverPublicKeyData: NSData = SecKeyCopyExternalRepresentation(serverPublicKey!, nil )!
                            let keyHash = sha256(data: serverPublicKeyData as Data)
                            if keyHash == pinnedPublicKeyHash {
                                // Success! This is our server
                                completionHandler(.useCredential, URLCredential(trust: serverTrust))
                                return
                            }
                        } else {
                            // Fallback on earlier versions
                        }
                    }
                }
            }
        }
        completionHandler(.cancelAuthenticationChallenge, nil)
    }

    func configureKey() {

    }
}

