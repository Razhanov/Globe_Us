//
//  MainPresenter.swift
//  Globe Us
//
//  Created by Karim Razhanov on 12.07.2020.
//

import Foundation
import UIKit

enum StickersMenuState {
    case showing
    case hiding
    
    mutating func toggle() {
        if self == .hiding {
            self = .showing
        } else {
            self = .hiding
        }
    }
}

protocol MainViewProtocol: class {
    func setView()
    func showSettingsAlert()
    func showSimpleAlertIn()
    func setMenuShowing()
    func setMenuHiding()
    func reloadData()
}

protocol MainPresenter {
    func viewDidLoad()
    func viewWillAppear()
    func viewDidAppear()
    func viewWillDisappear()
    var numberOfPlaces: Int { get }
    func configure(cell: SelectStickerCollectionViewCell, at index: Int)
    func didSelect(at row: Int)
}

class MainPresenterImplementation : NSObject, MainPresenter {
    
    fileprivate weak var view: MainViewProtocol?
    
    fileprivate var isCameraInitialized = false
    
    private var inFocusProcess = false
    
    var cameraView: MainView?
    
    private var orientation: UIInterfaceOrientation = .portrait
    
    private var focusLayer: CALayer!
    
    private var shutterLayer: CALayer!
    
    private var baseScale: CGFloat = 1
    
    var isSourcePhotoLibrary = false
    
    private var stickersMenuState: StickersMenuState = .showing {
        didSet {
            switch self.stickersMenuState {
            case .showing:
                view?.setMenuShowing()
                updateView()
            case .hiding:
                view?.setMenuHiding()
                updateView()
            }
        }
    }
    
    private var data: [Datum] = [] {
        didSet {
            view?.reloadData()
        }
    }
    
    var numberOfPlaces: Int {
        return data.first?.places.count ?? 0
    }
    
    weak var navigationController: UINavigationController?
    
    weak var viewController: UIViewController?
            
    init(view: MainViewProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        view?.setView()
        
        cameraView?.cameraButton.addTarget(self, action: #selector(takePicture(_:)), for: .touchUpInside)
        
        cameraView?.switchCameraButton.addTarget(self, action: #selector(switchCamera(_:)), for: .touchUpInside)
        
        cameraView?.mergeButton.addTarget(self, action: #selector(changeMenuState(_:)), for: .touchUpInside)
        
        focusLayer = CALayer()
        let focusImage = UIImage(named: "focus")
        focusLayer.contents = focusImage?.cgImage
        cameraView?.overlayView.layer.addSublayer(focusLayer)
        
        shutterLayer = CALayer()
        shutterLayer.frame = cameraView?.overlayView.frame ?? .zero
        shutterLayer.backgroundColor = UIColor.white.cgColor
        shutterLayer.opacity = 0
        cameraView?.overlayView.layer.addSublayer(shutterLayer)
        
        loadData()

    }
    
    func viewWillAppear() {
        if isCameraInitialized {
            startCamera()
        }
    }
    
    func viewDidAppear() {
        if !isSourcePhotoLibrary {
            prepareCamera()
        }
    }
    
    func viewWillDisappear() {
        CameraController.shared.stopRunning()
    }
    
    private func loadData() {
        MainService.getCities { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let cities):
                self.data = cities
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func configure(cell: SelectStickerCollectionViewCell, at index: Int) {
        guard let place = data.first?.places[index] else { return }
        cell.setData(with: place)
    }
    
    func didSelect(at row: Int) {
        guard let place = data.first?.places[row] else { return }
        print(navigationController.debugDescription)
        let placeDetailViewController = PlaceDetailViewController()
        let configurator = PlaceDetailConfiguratorImplementation()
        configurator.configure(viewController: placeDetailViewController, placeData: place)
//        navigationController?.pushViewController(placeDetailViewController, animated: true)
        viewController?.present(placeDetailViewController, animated: true, completion: nil)
    }
    
}


extension MainPresenterImplementation {
    
    private func setup() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapPreview(_:)))
        cameraView?.overlayView.addGestureRecognizer(tapGesture)
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(overlayViewPinched(_:)))
        cameraView?.overlayView.addGestureRecognizer(pinchGesture)
        
        AccelerometerOrientation.current.beginGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(deviceOrientationDidChange), name: .AccelerometerOrientationDidChange, object: nil)
    }
    
    private func startCamera() {
        if isCameraInitialized {
            setupButtons()
            CameraController.shared.startRunning()
        } else {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                self.setupButtons()
                
                self.cameraView?.previewView.isHidden = true
                if let previewView = self.cameraView?.previewView {
                    for subview in previewView.subviews {
                        subview.removeFromSuperview()
                    }
                }
                
//                let rect = CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width))//UIScreen.main.bounds
                var rect = CGRect()
                switch self.stickersMenuState {
                case .hiding:
                    rect = self.cameraView?.layoutMarginsGuide.layoutFrame ?? .zero
                case .showing:
                    rect = CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width))
                }
//                rect.size.height -= self.cameraView.
                
                let preview = CameraController.shared.previewView(rect)
                CameraController.shared.startRunning()
                self.cameraView?.previewView.addSubview(preview)
                self.cameraView?.previewView.isHidden = false
                self.setup()
                self.isCameraInitialized = true
                
            }
        }
    }
    
    private func updateView() {
        var rect = CGRect()
        switch self.stickersMenuState {
        case .hiding:
            rect = CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        case .showing:
            rect = CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width))
        }
        CameraController.shared.updateView(with: rect)
    }
    
    private func resetButtons() {
        cameraView?.switchCameraButton.isHidden = true
//        cameraView.torchButton.isHidden = true
        cameraView?.cameraButton.isEnabled = false
    }
    
    private func setupButtons() {
        cameraView?.switchCameraButton.isHidden = !CameraController.frontCameraAvailable// !CameraHelper.frontCameraAvailable
//        cameraView.torchButton.isHidden = !CameraHelper.torchAvailable || !CameraHelper.shared.torchAvailable
        cameraView?.cameraButton.isEnabled = true
    }
    
    private func prepareCamera() {
        resetButtons()
        
        if CameraController.cameraAvailable {
            switch CameraController.authorizationStatus {
            case .authorized:
                startCamera()
            case .notDetermined:
                CameraController.requestAccess { [weak self] granted in
                    if granted {
                        self?.prepareCamera()
                    }
                }
            case .denied, .restricted:
                print("Allow access to Camera")
                view?.showSettingsAlert()
            }
        } else {
//            cameraView.messageLabel.text = "Camera is unavailable."
//            cameraView.messageLabel.isHidden = false
        }
    }
    
}

// MARK: - Action
extension MainPresenterImplementation {
    @objc private func takePicture(_ sender: UIButton) {
        CATransaction.begin()

        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.duration = 0.5
        opacityAnimation.repeatCount = 0
        opacityAnimation.fromValue = 1.0
        opacityAnimation.toValue = 0.0
        shutterLayer.add(opacityAnimation, forKey: "opacity")
        
        CATransaction.commit()
        
        CameraController.shared.capture { [weak self] (error) in
            guard let self = self else { return }
            if let _ = error {
                self.view?.showSimpleAlertIn()
            }

            self.isSourcePhotoLibrary = false
        }
        
    }
    
    
    @objc private func switchCamera(_ sender: UIButton) {
        CameraController.shared.switchCamera()
//        cameraView.torchButton = !CameraController.shared.torchAvailable
    }
    
    @objc func changeMenuState(_ sender: UIButton) {
        self.stickersMenuState.toggle()
    }
    
}

// MARK: - Rotation
extension MainPresenterImplementation {
    @objc private func rotateView() {
        UIView.animate(withDuration: 0.5) { [weak self] in
            if let orientation = self?.orientation {
//                switch orientation {
//                case .portrait:
//                    self?.cameraView.switchButton.transform = CGAffineTransform(rotationAngle: 0)
//                    self?.cameraView.torchButton.transform = CGAffineTransform(rotationAngle: 0)
//                case .portraitUpsideDown:
//                    self?.cameraView.switchButton.transform = CGAffineTransform(rotationAngle: .pi)
//                    self?.cameraView.torchButton.transform = CGAffineTransform(rotationAngle: .pi)
//                case .landscapeLeft:
//                    self?.cameraView.switchButton.transform = CGAffineTransform(rotationAngle: .pi / 2)
//                    self?.cameraView.torchButton.transform = CGAffineTransform(rotationAngle: .pi / 2)
//                case .landscapeRight:
//                    self?.cameraView.switchButton.transform = CGAffineTransform(rotationAngle: -.pi / 2)
//                    self?.cameraView.torchButton.transform = CGAffineTransform(rotationAngle: -.pi / 2)
//                default:
//                    break
//                }
            }
        }
    }
}

// MARK: - Focus
extension MainPresenterImplementation {
    
    @objc func finishFocusProcess() {
        inFocusProcess = false
    }
   
    @objc func tapPreview(_ sender: UITapGestureRecognizer) {
        if sender.state != .ended || inFocusProcess {
            return
        }
        
        inFocusProcess = true
        
        let position = sender.location(in: cameraView?.previewView)
        let viewSize = cameraView?.previewView.frame.size ?? .zero
        let focusPoint = CGPoint(x: 1 - position.x / viewSize.width, y: position.y / viewSize.height)
        
        CameraController.shared.focus = focusPoint
        
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        
        focusLayer.frame = CGRect(x: position.x - 50, y: position.y - 50, width: 100, height: 100)
        focusLayer.opacity = 0
        
        CATransaction.commit()
        
        let opacityValues = [0, 0.2, 0.4, 0.6, 0.8, 1, 0.6, 1, 0.6]
        
        CATransaction.begin()
        
        let opacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
        opacityAnimation.duration = 0.8
        opacityAnimation.values = opacityValues
        opacityAnimation.calculationMode = CAAnimationCalculationMode.cubic
        opacityAnimation.repeatCount = 0
        focusLayer.add(opacityAnimation, forKey: "opacity")
        
        let scaleXAnimation = CABasicAnimation(keyPath: "transform.scale.x")
        scaleXAnimation.duration = 0.4
        scaleXAnimation.repeatCount = 0
        scaleXAnimation.fromValue = 3
        scaleXAnimation.toValue = 1
        focusLayer.add(scaleXAnimation, forKey: "transform.scale.x")
        
        let scaleYAnimation = CABasicAnimation(keyPath: "transform.scale.y")
        scaleYAnimation.duration = 0.4
        scaleYAnimation.repeatCount = 0
        scaleYAnimation.fromValue = 3
        scaleYAnimation.toValue = 1
        focusLayer.add(scaleYAnimation, forKey: "transform.scale.y")
        
        CATransaction.commit()
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(finishFocusProcess), userInfo: nil, repeats: false)
        
    }
    
}

// MARK: - Zoom
extension MainPresenterImplementation {
    @objc func overlayViewPinched(_ gesture: UIPinchGestureRecognizer) {
        if gesture.state == .began {
            baseScale = CameraController.shared.zoomFactor
        }
        CameraController.shared.zoomFactor = baseScale * gesture.scale
    }
}

// MARK: - Orientation
extension MainPresenterImplementation {
    @objc func deviceOrientationDidChange() {
        switch AccelerometerOrientation.current.orientation {
        case .portrait:
            orientation = .portrait
        case .portraitUpsideDown:
            orientation = .portraitUpsideDown
        case .landscapeLeft:
            orientation = .landscapeLeft
        case .landscapeRight:
            orientation = .landscapeRight
        default:
            break
        }
        
        performSelector(onMainThread: #selector(rotateView), with: nil, waitUntilDone: true)
    }
}


extension UIAlertController {
    class func showSettingsAlertIn(_ viewController: UIViewController?, title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }))
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        alertController.preferredAction = okAction
        viewController?.present(alertController, animated: true, completion: nil)
    }
    
    class func showSimpleAlertIn(_ viewController: UIViewController?, title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        viewController?.present(alertController, animated: true, completion: nil)
    }

    class func showSimpleErrorAlertIn(_ viewController: UIViewController?, error: Error) {
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        viewController?.present(alertController, animated: true, completion: nil)
    }
}
