//
//  PlaceDetailPresenter.swift
//  Globe Us
//
//  Created by Karim Razhanov on 15.09.2020.
//

import UIKit

protocol PlaceDetailViewProtocol: class {
    func display(placeData: Place)
}

protocol PlaceDetailPresenter {
    func viewDidLoad()
}

class PlaceDetailPresenterImplementation: PlaceDetailPresenter {

    private weak var view: PlaceDetailViewProtocol?
    
    private var placeData: Place
    
    init(view: PlaceDetailViewProtocol, placeData: Place) {
        self.view = view
        self.placeData = placeData
    }
    
    func viewDidLoad() {
        view?.display(placeData: placeData)
    }
}
