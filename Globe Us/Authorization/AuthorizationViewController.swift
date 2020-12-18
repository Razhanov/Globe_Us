//
//  AuthorizationViewController.swift
//  Globe Us
//
//  Created by Karim Razhanov on 19.07.2020.
//

import Foundation
import UIKit

class AuthorizationViewController : UIViewController {
    
    var configurator = AuthorizationConfiguratorImplementation()
    var presenter: AuthorizationPresenter?
    
    private(set) lazy var mainView: AuthorizationView = {
        let view = AuthorizationView()
        return view
    }()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        configurator.configure(viewController: self)
        presenter?.viewDidLoad()
    }
    
}

extension AuthorizationViewController : AuthorizationViewProtocol {
    func setView() {
        
    }
}
