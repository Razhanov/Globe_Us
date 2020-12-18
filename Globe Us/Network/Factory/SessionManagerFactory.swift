//
//  SessionManagerFactory.swift
//  Globe Us
//
//  Created by Karim Razhanov on 14.09.2020.
//

import Foundation
import Alamofire

class SessionManagerFactory {
    
    static let sessionManager: Session = {
        let configuration = URLSessionConfiguration.default
        configuration.httpShouldSetCookies = false
        configuration.urlCache = nil
        configuration.timeoutIntervalForRequest = 10
        configuration.timeoutIntervalForResource = 10
        return Session(configuration: configuration)
    }()
}
