//
//  MainView.swift
//  Globe Us
//
//  Created by Karim Razhanov on 12.07.2020.
//

import Foundation
import UIKit
import SnapKit

class MainView : UIView {

    private(set) lazy var view: UIView = {
        let view = UIView()
        return view
    }()
    
    private(set) lazy var previewView: UIView = {
        let view = UIView()
        return view
    }()
    
    private(set) lazy var overlayView: UIView = {
        let view = UIView()
        return view
    }()
    
    private(set) lazy var toolBarView: UIView = {
        let view = UIView()
        return view
    }()
    
    private(set) lazy var cameraButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "capture_photo"), for: .normal)
        return button
    }()
    
    private(set) lazy var switchCameraButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "switch_camera"), for: .normal)
        return button
    }()
    
    private(set) lazy var clipsButton: UIButton = {
        let button = UIButton()
        button.clipsToBounds = true
        button.layer.cornerRadius = 22
        button.setImage(UIImage(named: "demo_image"), for: .normal)
        return button
    }()
    
    private(set) lazy var toolBarBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexString: "#14133D")
        return view
    }()
    
    private(set) lazy var mergeButtonView: UIView = {
        let view = UIView()
        return view
    }()
    
    private(set) lazy var mergeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "merge"), for: .normal)
        return button
    }()
    
    private(set) lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 64, height: 83)
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        let collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: layout)
        collectionView.register(SelectStickerCollectionViewCell.self, forCellWithReuseIdentifier: "SelectStickerCollectionViewCell")
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private(set) lazy var topImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "1_verh")?.resizeTopAlignedToFill(newWidth: UIScreen.main.bounds.width)
        imageView.contentMode = .top
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private(set) lazy var bottomImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "1_niz")?.resizeTopAlignedToFill(newWidth: UIScreen.main.bounds.width)
        imageView.contentMode = .bottom
        imageView.clipsToBounds = true
        return imageView
    }()
    
    func setMenuShowing() {
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let self = self else { return }
            self.toolBarBackgroundView.alpha = 1
            self.toolBarBackgroundView.snp.updateConstraints { (update) in
                update.height.equalTo(170 + self.safeAreaInsets.bottom)
            }
            self.previewView.snp.remakeConstraints { (remake) in
                remake.top.equalTo(self.layoutMarginsGuide)
                remake.leading.trailing.equalToSuperview()
                remake.height.equalTo(UIScreen.main.bounds.width)
            }
        }
    }
    
    func setMenuHiding() {
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let self = self else { return }
            self.toolBarBackgroundView.alpha = 0
            self.toolBarBackgroundView.snp.updateConstraints { (update) in
                update.height.equalTo(0)
            }
            self.previewView.snp.remakeConstraints { (remake) in
                remake.top.equalTo(self.layoutMarginsGuide)
                remake.leading.trailing.equalToSuperview()
                remake.height.equalTo(UIScreen.main.bounds.height)
            }
        }
    }
    
    override func layoutSubviews() {
        addSubviews()
        makeConstraints()
    }
    
    private func addSubviews() {
        addSubview(view)
        view.addSubview(previewView)
        view.addSubview(overlayView)
        view.addSubview(toolBarBackgroundView)
        view.addSubview(toolBarView)
        toolBarView.addSubview(cameraButton)
        toolBarView.addSubview(switchCameraButton)
        toolBarView.addSubview(clipsButton)
        toolBarView.addSubview(mergeButtonView)
        mergeButtonView.addSubview(mergeButton)
        toolBarView.addSubview(collectionView)
        
        previewView.addSubview(topImageView)
        previewView.addSubview(bottomImageView)
    }
    
    private func makeConstraints() {
        view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        previewView.snp.makeConstraints { (make) in
            make.top.equalTo(self.layoutMarginsGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.width)
        }
        overlayView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        toolBarBackgroundView.snp.makeConstraints { (make) in
            make.height.equalTo(170 + self.safeAreaInsets.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        toolBarView.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.layoutMarginsGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(170)
        }
        cameraButton.snp.makeConstraints { (make) in
            make.height.width.equalTo(60)
            make.bottom.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
        }
        switchCameraButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(cameraButton)
            make.trailing.equalToSuperview().inset(28)
            make.height.width.equalTo(27)
        }
        clipsButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(cameraButton)
            make.height.width.equalTo(44)
            make.leading.equalToSuperview().offset(28)
        }
        mergeButtonView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(cameraButton.snp.right)
            make.right.equalTo(switchCameraButton.snp.left)
        }
        mergeButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(cameraButton)
            make.width.height.equalTo(22)
            make.centerX.equalToSuperview()
        }
        collectionView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(83)
        }
        
        topImageView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
            make.width.height.equalTo(UIScreen.main.bounds.width)
//            make.bottom.lessThanOrEqualToSuperview()
        }
        bottomImageView.snp.makeConstraints { (make) in
            make.bottom.leading.trailing.equalToSuperview()
            make.width.height.equalTo(UIScreen.main.bounds.width)
        }
    }
}


extension UIColor {
    
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

extension UIImage {
    func resizeTopAlignedToFill(newWidth: CGFloat) -> UIImage? {
        let newHeight = size.height * newWidth / size.width

        let newSize = CGSize(width: newWidth, height: newHeight)

        UIGraphicsBeginImageContextWithOptions(newSize, false, UIScreen.main.scale)
        draw(in: CGRect(origin: .zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }
}

