//
//  AbstractRequestFactory.swift
//  Globe Us
//
//  Created by Karim Razhanov on 14.09.2020.
//

import Foundation
import Alamofire

protocol AbstractRequestFactory {
    var sessionManager: Session { get }
    var queue: DispatchQueue { get }
    
    @discardableResult
    func request(_ request: URLRequestConvertible) -> DataRequest
}

extension AbstractRequestFactory {
    @discardableResult
    func request(_ request: URLRequestConvertible) -> DataRequest {
        return sessionManager.request(request)
    }
}
