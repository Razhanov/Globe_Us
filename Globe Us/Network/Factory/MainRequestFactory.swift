//
//  MainRequestFactory.swift
//  Globe Us
//
//  Created by Karim Razhanov on 14.09.2020.
//

import Foundation
import Alamofire

final class MainRequestFactory: AbstractRequestFactory {
    var sessionManager: Session
    var queue: DispatchQueue
    
    init(sessionManager: Session, queue: DispatchQueue = DispatchQueue.global(qos: .userInitiated)) {
        self.sessionManager = sessionManager
        self.queue = queue
    }
    
    public func getCities(completion: @escaping ((Result<[Datum], Error>) ->Void)) {
        let request = MainRequestRouter.getCities
        self.request(request).responseJSON { (response) in
            guard let statusCode = response.response?.statusCode  else {
//                let err: ExampleError = .invalidRequest(msg: "no response")
//                completion(.failure())
//                completion(.failure(response.error?.underlyingError))
                return
            }
            switch statusCode {
            case 200 ... 399:
                if let data = response.data {
                    do {
                        let data = try JSONDecoder().decode(Cities.self, from: data)
                        completion(.success(data.data))
                    } catch let error{
                        completion(.failure(error))
                    }
                    return
                }
            default:
                break
//                if let error = response.value as? [String: Any] {
//                    guard let msg = error["message"] as? String else {
////                        let unkErr: ExampleError = .unknownError
//                        return completion(.failure(unkErr))
//                    }
//                    let err: ExampleError = .invalidRequest(msg: msg)
//                    completion(.failure(err))
//                }
            }
        }
    }
}
