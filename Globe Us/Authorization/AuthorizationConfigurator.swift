//
//  AuthorizationConfigurator.swift
//  Globe Us
//
//  Created by Karim Razhanov on 19.07.2020.
//

import Foundation

protocol AuthorizationConfigurator {
    func configure(viewController: AuthorizationViewController)
}

class AuthorizationConfiguratorImplementation : AuthorizationConfigurator {
    func configure(viewController: AuthorizationViewController) {
        let presenter = AuthorizationPresenterImplementation(view: viewController)
        viewController.presenter = presenter
    }
}
