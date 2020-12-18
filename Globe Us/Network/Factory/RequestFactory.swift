//
//  RequestFactory.swift
//  Globe Us
//
//  Created by Karim Razhanov on 14.09.2020.
//

import Foundation
import Alamofire

class RequestFactory {

    private var mainFactory: MainRequestFactory?
    
    lazy private var sessionManager: Session = {
        return SessionManagerFactory.sessionManager
    }()
    
    func makeMainFactory() -> MainRequestFactory {
        if let factory = mainFactory {
            return factory
        } else {
            let factory = MainRequestFactory(sessionManager: sessionManager)
            mainFactory = factory
            return factory
        }
    }
    
}
