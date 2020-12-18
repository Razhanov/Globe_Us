//
//  MainConfigurator.swift
//  Globe Us
//
//  Created by Karim Razhanov on 12.07.2020.
//

import Foundation

protocol MainConfigurator {
    func configure(viewController: MainViewController)
}

class MainConfiguratorImplementation : MainConfigurator {
    func configure(viewController: MainViewController) {
        let presenter = MainPresenterImplementation(view: viewController)
        viewController.presenter = presenter
        presenter.cameraView = viewController.mainView
        CameraController.shared.delegate = viewController
        presenter.navigationController = viewController.navigationController
        presenter.viewController = viewController
    }
}
