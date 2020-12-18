//
//  MainService.swift
//  Globe Us
//
//  Created by Karim Razhanov on 14.09.2020.
//

import Foundation

class MainService {
    private static let factory = RequestFactory()
    private static var mainFactory: MainRequestFactory?
    
    static func getCities(completion: @escaping (Result<[Datum], Error>) -> Void) {
        mainFactory = factory.makeMainFactory()
        mainFactory?.getCities(completion: { (result) in
            completion(result)
        })
    }
}
