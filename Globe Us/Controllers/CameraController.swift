//
//  CameraController.swift
//  Globe Us
//
//  Created by Karim Razhanov on 13.07.2020.
//

import Foundation
import AVFoundation
import UIKit
import Photos
import ImageIO

enum CameraPosition {
    case front
    case back
}

final class CameraController {
 
    static let shared = CameraController()
    
    var delegate: AVCapturePhotoCaptureDelegate?
    
    static var cameraAvailable: Bool {
        return UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    static var frontCameraAvailable: Bool {
        guard let _ = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else { return false }
        return true
    }
    
    static var torchAvailable: Bool {
        let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
        return device?.isTorchAvailable ?? false
    }
    
    static var authorizationStatus: AVAuthorizationStatus {
        return AVCaptureDevice.authorizationStatus(for: .video)
    }
    
    static func requestAccess(_ completion: ((Bool) -> Void)!) {
        AVCaptureDevice.requestAccess(for: .video, completionHandler: completion)
    }
    
    var cameraPosition: CameraPosition {
        guard let videoInput = videoInput else { return .back }
        return sideWithCaptureDevice(videoInput)
    }
    
    var torch: Bool {
        get {
            guard let device = videoInput?.device else { return false }
            return torchWithCaptureDevice(device)
        }
        set(enable) {
            guard let device = videoInput?.device else { return }
            if torchAvailable {
                setTorch(enable, withCaptureDevice: device)
            }
        }
    }
    
    var torchAvailable: Bool {
        if let videoInput = videoInput {
            return videoInput.device.hasTorch
        }
        return false
    }
    
    var focus: CGPoint {
        get {
            guard let device = videoInput?.device else { return .zero }
            if CameraController.cameraAvailable {
                return focusWithCaptureDevice(device)
            }
            return .zero
        }
        set(newFocus) {
            guard let device = videoInput?.device else { return }
            if CameraController.cameraAvailable {
                setFocus(newFocus, withCaptureDevie: device)
            }
        }
    }
    
    private let defaultMaxZoomFactor: CGFloat = 4.15
    
    var zoomFactor: CGFloat {
        get {
            guard let device = videoInput?.device else { return 1 }
            guard cameraPosition == .back else { return 1 }
            return device.videoZoomFactor
        }
        set(newZoomFactor) {
            guard let device = videoInput?.device else { return }
            guard cameraPosition == .back else { return }
            do {
                try device.lockForConfiguration()
                let maxZoomFactor = min(defaultMaxZoomFactor, device.activeFormat.videoMaxZoomFactor)
                device.videoZoomFactor = min(max(newZoomFactor, 1), maxZoomFactor)
                device.unlockForConfiguration()
            } catch _ {
                print("Cannot zoom")
            }
        }
    }
    
    private var session: AVCaptureSession?
    private var videoInput: AVCaptureDeviceInput?
    private var capturePhotoOutput: AVCapturePhotoOutput!
//    private var captureStillImageOutput: AVCaptureStillImageOutput!
    private var capturePhotoSettings: AVCapturePhotoSettings?
    
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    
    private init() {
        if CameraController.cameraAvailable {
            self.initialize()
        }
    }
    
    private func initialize() {
        session = AVCaptureSession()
        
        guard let session = session else { return }
        
        if session.canSetSessionPreset(AVCaptureSession.Preset.photo) {
            session.sessionPreset = AVCaptureSession.Preset.photo
        }
        
        let videoDevice = AVCaptureDevice.default(for: .video)
        if videoDevice == nil {
            self.session = nil
            print("Could not create video capture device")
        }
        
        do {
            let videoInput = try AVCaptureDeviceInput(device: videoDevice!)
            if session.canAddInput(videoInput) {
                session.addInput(videoInput)
            }
            self.videoInput = videoInput
        } catch _ {
            print("Could not create video input")
        }
        
        capturePhotoOutput = AVCapturePhotoOutput()
        capturePhotoSettings = AVCapturePhotoSettings()
        
//        if self.capturePhotoOutput.availablePhotoCodecTypes.contains(.hevc) {
//            capturePhotoSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.hevc])
//        }
//
//        if ((self.videoInput?.device.isFlashAvailable) != nil) {
//            capturePhotoSettings?.flashMode = .auto
//        }
        
//        capturePhotoSettings?.isHighResolutionPhotoEnabled = true
        
//        if let delegate = delegate {
//            capturePhotoOutput.capturePhoto(with: settings, delegate: delegate)
//        }
        
        session.addOutput(capturePhotoOutput)
        
//        captureStillImageOutput = AVCaptureStillImageOutput()
//        captureStillImageOutput.outputSettings = [AVVideoCodecKey: AVVideoCodecType.jpeg]
        
//        session.addOutput(captureStillImageOutput)
    }
    
    func previewView(_ bounds: CGRect) -> UIView {
        return previewLayer(bounds, session: session)
    }
    
    private func previewLayer(_ bounds: CGRect, session: AVCaptureSession?) -> UIView {
//        let previewLayer = AVCaptureVideoPreviewLayer(session: session!)
        //
        previewLayer = AVCaptureVideoPreviewLayer(session: session!)
        //
        previewLayer.frame = bounds
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        session?.sessionPreset = .high
        
        
        let view = UIView(frame: bounds)
        view.layer.addSublayer(previewLayer)
        
        return view
    }
    
    func updateView(with rect: CGRect) {
        guard let previewLayer = previewLayer else { return }
        previewLayer.frame = rect
    }
    
    
    func getMetaRect(from rect: CGRect) -> CGRect {
        let metaRect = self.previewLayer.metadataOutputRectConverted(fromLayerRect: rect)
        return metaRect
    }
    
    
    // MARK: - Control
    
    func startRunning() {
        guard let session = session else { return }
        
        AccelerometerOrientation.current.beginGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(deviceOrientationDidChange), name: .AccelerometerOrientationDidChange, object: nil)
        
        session.startRunning()
    }
    
    func stopRunning() {
        guard let session = session else { return }
        
        session.stopRunning()
        
        NotificationCenter.default.removeObserver(self, name: .AccelerometerOrientationDidChange, object: nil)
        AccelerometerOrientation.current.endGeneratingDeviceOrientationNotifications()
    }
    
    func capture(_ completion: ((_ error: Error?) -> Void)? = nil) {
        if let delegate = delegate {
            
            if self.capturePhotoOutput.availablePhotoCodecTypes.contains(.hevc) {
                capturePhotoSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.hevc])
            } else {
                capturePhotoSettings = AVCapturePhotoSettings()
            }
            
            if ((self.videoInput?.device.isFlashAvailable) != nil) {
                capturePhotoSettings?.flashMode = .auto
            }
            guard let settings = capturePhotoSettings else { return }
            capturePhotoOutput.capturePhoto(with: settings, delegate: delegate)
        }
    }
    
    private func sideWithCaptureDevice(_ videoInput: AVCaptureDeviceInput) -> CameraPosition {
        let isBackCamera = videoInput.device.position == .back
        return isBackCamera ? CameraPosition.back : CameraPosition.front
    }
    
    private func sideSwitchedInput(_ currentVideoInput: AVCaptureDeviceInput, captureSession session: AVCaptureSession) -> AVCaptureDeviceInput? {
        guard CameraController.frontCameraAvailable else {
            return nil
        }
        
        var newVideoInput: AVCaptureDeviceInput?
        
        session.stopRunning()
        session.removeInput(currentVideoInput)
        
        for device in AVCaptureDevice.devices(for: .video) {
            if device.hasMediaType(.video) {
                if currentVideoInput.device.position == .back {
                    if device.position == .front {
                        do {
                            try newVideoInput = AVCaptureDeviceInput(device: device)
                            break
                        } catch {
                            print("Failed to create input")
                        }
                    }
                } else {
                    if device.position == .back {
                        do {
                            try newVideoInput = AVCaptureDeviceInput(device: device)
                            break
                        } catch {
                            print("Failed to create input")
                        }
                    }
                }
            }
        }
        
        if newVideoInput != nil {
            session.addInput(newVideoInput!)
            session.startRunning()
        } else {
            print("Failed to switch camera")
        }
        
        return newVideoInput
        
    }
    
    private func torchWithCaptureDevice(_ device: AVCaptureDevice) -> Bool {
        if device.hasTorch {
            return device.torchMode == .on
        }
        return false
    }
    
    private func setTorch(_ enable: Bool, withCaptureDevice device: AVCaptureDevice) {
        do {
            try device.lockForConfiguration()
            if enable {
                device.torchMode = .on
            } else {
                device.torchMode = .off
            }
            device.unlockForConfiguration()
        } catch {}
    }
    
    
    private func focusWithCaptureDevice(_ device: AVCaptureDevice) -> CGPoint {
        if device.isFocusPointOfInterestSupported {
            return device.focusPointOfInterest
        }
        return .zero
    }
    
    private func setFocus(_ pointOfInterest: CGPoint, withCaptureDevie device: AVCaptureDevice) {
        if device.isFocusPointOfInterestSupported && device.isFocusModeSupported(.autoFocus) {
            do {
                try device.lockForConfiguration()
                device.focusPointOfInterest = pointOfInterest
                device.focusMode = .autoFocus
                device.unlockForConfiguration()
            } catch {}
        }
    }
    
    func switchCamera() {
        guard let videoInput = videoInput, let session = session else { return }
        
        self.videoInput = sideSwitchedInput(videoInput, captureSession: session)
    }
    
    
    // MARK: - Orientation
    
    @objc private func deviceOrientationDidChange() {
        guard let session = session else { return }
        
        let orientation: AVCaptureVideoOrientation
        switch AccelerometerOrientation.current.orientation {
        case .portrait:
            orientation = .portrait
        case .portraitUpsideDown:
            orientation = .portraitUpsideDown
        case .landscapeLeft:
            orientation = .landscapeRight
        case .landscapeRight:
            orientation = .landscapeLeft
        default:
            orientation = .portrait
        }
        
        session.beginConfiguration()
        
        if let connection = capturePhotoOutput.connection(with: .video) {
            if connection.isVideoOrientationSupported {
                connection.videoOrientation = orientation
            }
        }
        
        session.commitConfiguration()
        
    }
    
}

//extension CameraController: AVCapturePhotoCaptureDelegate {
//    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
//        if let error = error {
//            print(error.localizedDescription)
//        }
//
//        if let dataImage = photo.fileDataRepresentation() {
//            print(UIImage(data: dataImage)?.size as Any)
//
//            let dataProvider = CGDataProvider(data: dataImage as CFData)
//            let cgImageRef: CGImage! = CGImage(jpegDataProviderSource: dataProvider!, decode: nil, shouldInterpolate: true, intent: .defaultIntent)
//            let image = UIImage(cgImage: cgImageRef, scale: 1.0, orientation: UIImage.Orientation.right)
//
//            /**
//             save image in array / do whatever you want to do with the image here
//             */
////            self.images.append(image)
//
//        } else {
//            print("some error here")
//        }
//    }
//}
