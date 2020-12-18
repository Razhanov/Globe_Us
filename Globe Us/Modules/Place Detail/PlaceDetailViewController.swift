//
//  PlaceDetailViewController.swift
//  Globe Us
//
//  Created by Karim Razhanov on 15.09.2020.
//

import UIKit

class PlaceDetailViewController: UIViewController {
    
    var presenter: PlaceDetailPresenter?
    
    private(set) lazy var mainView: PlaceDetailView = {
        let view = PlaceDetailView()
        return view
    }()
    
    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }

}

extension PlaceDetailViewController: PlaceDetailViewProtocol {
    func display(placeData: Place) {
        mainView.display(placeData: placeData)
    }
}
