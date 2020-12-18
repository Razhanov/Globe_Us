//
//  PlaceDetailView.swift
//  Globe Us
//
//  Created by Karim Razhanov on 15.09.2020.
//

import UIKit

class PlaceDetailView: UIView {

    private(set) lazy var view: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private(set) lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private(set) lazy var distanceLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private(set) lazy var detailLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func display(placeData: Place) {
        imageView.loadWithAlamofire(urlString: placeData.images.first ?? "")
        titleLabel.text = placeData.title
        detailLabel.text = placeData.placeDescription
    }
    
    private func addSubviews() {
        addSubview(view)
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(distanceLabel)
        view.addSubview(detailLabel)
    }
    
    private func makeConstraints() {
        view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        imageView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.3)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(24)
        }
        distanceLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.equalToSuperview().offset(24)
        }
        detailLabel.snp.makeConstraints { (make) in
            make.top.equalTo(distanceLabel.snp.bottom).offset(19)
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().inset(22)
        }
    }

}
