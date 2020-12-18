//
//  PlaceDetailConfigurator.swift
//  Globe Us
//
//  Created by Karim Razhanov on 15.09.2020.
//

import UIKit

protocol PlaceDetailConfigurator {
    func configure(viewController: PlaceDetailViewController, placeData: Place)
}

class PlaceDetailConfiguratorImplementation: PlaceDetailConfigurator {
    func configure(viewController: PlaceDetailViewController, placeData: Place) {
        let presenter = PlaceDetailPresenterImplementation(view: viewController, placeData: placeData)
        viewController.presenter = presenter
    }
}
