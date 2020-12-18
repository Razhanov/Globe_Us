//
//  AuthorizationPresenter.swift
//  Globe Us
//
//  Created by Karim Razhanov on 19.07.2020.
//

import Foundation
import UIKit

protocol AuthorizationViewProtocol: class {
    func setView()
}

protocol AuthorizationPresenter {
    func viewDidLoad()
}

class AuthorizationPresenterImplementation : AuthorizationPresenter {
    
    fileprivate weak var view: AuthorizationViewProtocol?
    
    init(view: AuthorizationViewProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        view?.setView()
    }
    
}
