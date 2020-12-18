//
//  LaunchScreenViewController.swift
//  Globe Us
//
//  Created by Karim Razhanov on 12.07.2020.
//

import UIKit

class LaunchScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        AppController.shared.startApp()
    }

}
