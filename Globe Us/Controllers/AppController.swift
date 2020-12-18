//
//  AppController.swift
//  Globe Us
//
//  Created by Karim Razhanov on 12.07.2020.
//

import UIKit

final class AppController {

    static let shared = AppController()
    
    var window: UIWindow!
    var rootViewController: UIViewController? {
        didSet {
            if let vc = rootViewController {
                window.rootViewController = vc
            }
        }
    }
    
    func show(in window: UIWindow?) {
        guard let window = window else {
            fatalError("Cannot layout app with a nil window")
        }
        
        window.backgroundColor = .black
        self.window = window
        
        rootViewController = LaunchScreenViewController()
        window.makeKeyAndVisible()
    }
    
    func startApp() {
//        let picker = MainViewController()
//
//        let screenSize = UIScreen.main.bounds.size
//        let ratio: CGFloat = 4.0 / 3.0
//        let cameraHeight: CGFloat = screenSize.width * ratio
//        let scale: CGFloat = screenSize.height / cameraHeight
        
//        picker.
//        picker.cameraViewTransform = CGAffineTransform(translationX: 0, y: (screenSize.height - cameraHeight) / 2.0)
//        picker.cameraViewTransform = CGAffineTransform(scaleX: scale, y: scale)
        
        rootViewController = MainViewController()//UINavigationController(rootViewController: MainViewController())//MainViewController()
    }
    
}
