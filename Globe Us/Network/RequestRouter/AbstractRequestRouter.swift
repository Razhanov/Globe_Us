//
//  AbstractRequestRouter.swift
//  Globe Us
//
//  Created by Karim Razhanov on 14.09.2020.
//

import Foundation

import Alamofire

protocol AbstractRequestRouter: URLRequestConvertible {
    var baseUrl: URL { get }
    var fullUrl: URL { get }
    var path: String { get }
    var headers: HTTPHeaders { get }
    var method: HTTPMethod { get }
}

extension AbstractRequestRouter {
    
    var baseUrl: URL {
         let string = "https://selfident.ompr.io/api/"
        return URL.init(string: string)!
    }
    
    var fullUrl: URL {
        return baseUrl.appendingPathComponent(path)
    }
    
    var headers: HTTPHeaders {
        return ["Content-Type": "application/json"]
    }
}
