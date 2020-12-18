//
//  SelectStickerCollectionViewCell.swift
//  Globe Us
//
//  Created by Karim Razhanov on 14.09.2020.
//

import UIKit

class SelectStickerCollectionViewCell: UICollectionViewCell {
    private(set) lazy var view: UIView = {
        let view = UIView()
        return view
    }()
    
    private(set) lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 32
        imageView.clipsToBounds = true
        return imageView
    }()
    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.numberOfLines = 2
        return label
    }()
    
    func setData(with place: Place) {
        guard let imageString = place.images.first else { return }
        imageView.loadWithAlamofire(urlString: imageString)
        titleLabel.text = place.code
        addSubviews()
        makeConstraints()
    }
    
    private func addSubviews() {
        addSubview(view)
        view.addSubview(imageView)
        view.addSubview(titleLabel)
    }
    
    private func makeConstraints() {
        view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        imageView.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalTo(64)
            make.top.leading.trailing.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(2)
            make.bottom.leading.trailing.equalToSuperview()
        }
    }
}
