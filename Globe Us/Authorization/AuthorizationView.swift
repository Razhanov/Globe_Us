//
//  AuthorizationView.swift
//  Globe Us
//
//  Created by Karim Razhanov on 19.07.2020.
//

import Foundation
import UIKit

class AuthorizationView : UIView {

    private(set) lazy var view: UIView = {
        let view = UIView()
        return view
    }()
    
    private(set) lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private(set) lazy var appNameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private(set) lazy var emailTextField: UITextField = {
        let textField = UITextField()
        return textField
    }()
    
    private(set) lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        return textField
    }()
    
    private(set) lazy var registerButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        addSubview(view)
        view.addSubview(iconImageView)
        view.addSubview(appNameLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(registerButton)
    }
    
    private func makeConstraints() {
        view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        iconImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(54)
            make.centerX.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.15)
        }
        appNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(iconImageView.snp.bottom).offset(18)
            make.centerX.equalToSuperview()
        }
        emailTextField.snp.makeConstraints { (make) in
            make.top.equalTo(appNameLabel.snp.bottom).offset(50)
            make.width.equalToSuperview().inset(24)
            make.centerX.equalToSuperview()
        }
        passwordTextField.snp.makeConstraints { (make) in
            make.top.equalTo(emailTextField.snp.bottom).offset(18)
            make.width.equalTo(emailTextField)
            make.centerX.equalToSuperview()
        }
        registerButton.snp.makeConstraints { (make) in
            make.top.equalTo(passwordTextField.snp.bottom).offset(16)
            make.width.equalTo(emailTextField)
            make.centerX.equalToSuperview()
        }
    }
}
