//
//  MainRequestRouter.swift
//  Globe Us
//
//  Created by Karim Razhanov on 14.09.2020.
//

import Foundation
import Alamofire

enum MainRequestRouter: AbstractRequestRouter {
    case getCities
    
    var method: HTTPMethod {
        switch self {
        case .getCities:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .getCities:
            return "city/5"
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .getCities:
            return ["Content-Type": "application/json",
                    "Accept": "application/json"]
        }
    }
    
    struct CustomPatchEncding: ParameterEncoding {
        func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
            let mutableRequest = try? URLEncoding().encode(urlRequest, with: parameters) as? NSMutableURLRequest
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: parameters!, options: .prettyPrinted)
                mutableRequest?.httpBody = jsonData
                
            } catch {
                debugPrint(error.localizedDescription)
            }
            return mutableRequest! as URLRequest
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        var urlRequest = URLRequest(url: fullUrl)
        urlRequest.httpMethod = method.rawValue
        urlRequest.headers = headers
        switch self {
        case .getCities:
            urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
        }
        return urlRequest
    }
}
