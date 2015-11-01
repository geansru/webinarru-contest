//
//  VideoManager.swift
//  Webinar.ru-contest
//
//  Created by Dmitriy Roytman on 01.11.15.
//  Copyright © 2015 Dmitriy Roytman. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer
import MobileCoreServices

final class VideoManager: NSObject, Singletonable, Captureable {
    //MARK: Singleton
    class var sharedManager: VideoManager {
        
        struct StaticInstance {
            static var instance: VideoManager? = nil
            static var onceToken: dispatch_once_t = 0
        }
        
        dispatch_once(&StaticInstance.onceToken) {
            StaticInstance.instance = self.init()
        }
        
        return StaticInstance.instance!
    }
    
    required override init() {}
    
    // MARK: Private properties
    private var _focusMode: AVCaptureFocusMode = AVCaptureFocusMode.AutoFocus
    private var _captureQuality: String = AVCaptureSessionPresetHigh
    private weak var _view: UIView? = nil
    private lazy var _captureSession: AVCaptureSession = { return AVCaptureSession() }()
    private lazy var _captureDevice: AVCaptureDevice! = {
        guard let allDevices = AVCaptureDevice.devices() as? [AVCaptureDevice] else {
            return nil
        }
        print(allDevices)
        
        //Filter device supporting video on this phone
        let videoDevices = allDevices.filter{ $0.hasMediaType(AVMediaTypeVideo) }
        //Filter back camera
        guard let backCamera = videoDevices.filter({
            $0.position == AVCaptureDevicePosition.Back
        }).first else {
            return nil
        }
        
        return backCamera
    }()
    private lazy var _previewLayer: AVCaptureVideoPreviewLayer = {
        return AVCaptureVideoPreviewLayer(session: self._captureSession)
    }()
    private lazy var _inputDevice: AVCaptureDeviceInput? = {
        let input: AVCaptureDeviceInput? = Exception.performThrowableWithReturnValue{try AVCaptureDeviceInput(device: self._captureDevice)} as? AVCaptureDeviceInput
        return input
    }()
    
    // MARK: Public methods for record and play recorder video
    func startCameraFromViewController(viewController: UIViewController, withDelegate delegate: protocol<UIImagePickerControllerDelegate, UINavigationControllerDelegate>) -> Bool {
        if UIImagePickerController.isSourceTypeAvailable(.Camera) == false {
            return false
        }
        
        let cameraController = UIImagePickerController()
        cameraController.sourceType = .Camera
        cameraController.mediaTypes = [kUTTypeMovie as String]
        cameraController.allowsEditing = false
        cameraController.delegate = delegate
        
        viewController.presentViewController(cameraController, animated: true, completion: nil)
        return true
    }
    
    func startMediaBrowserFromViewController(viewController: UIViewController, usingDelegate delegate: protocol<UINavigationControllerDelegate, UIImagePickerControllerDelegate>) -> Bool {
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum) {
            return false
        }
        
        let mediaUI = UIImagePickerController()
        mediaUI.sourceType = .SavedPhotosAlbum
        mediaUI.mediaTypes = [kUTTypeMovie as String]
        mediaUI.allowsEditing = true
        mediaUI.delegate = delegate
        
        viewController.presentViewController(mediaUI, animated: true, completion: nil)
        return true
    }

    // MARK: Adopt Protocol Captureable
    func stopCapture() -> CameraState {
        _captureSession.stopRunning()
        removeSubLayer()
        return CameraState.NotUsed
    }
    
    func startCapture() -> CameraState {
        addSubLayer()
        addInputDevice()
        _captureSession.startRunning()
        return CameraState.Capturing
    }
    
    // Must be called before start capture
    func setUpCaptureSession(view: UIView, captureQuality: String, focusMode: AVCaptureFocusMode) {
        self._captureQuality = captureQuality
        self._focusMode = focusMode
        setUpCaptureSession(view)
    }
    
    func setUpCaptureSession(view: UIView) {
        _captureSession.sessionPreset = self._captureQuality
        self._view = view
        configureDevice { () -> () in
            self._captureDevice.focusMode = self._focusMode
        }
    }
    
    // MARK: private functions
    func focusTo(value: Float) {
        configureDevice { () -> () in
            self._captureDevice.setFocusModeLockedWithLensPosition(value, completionHandler: nil)
        }
    }
    
    private func configureDevice(configurationBlock: ()->()) {
        guard let device = _captureDevice else { return }
        Exception.performThrowable {
            try device.lockForConfiguration()
            configurationBlock()
            device.unlockForConfiguration()
        }
            
    }
    
    private func addInputDevice() {
        if let _ = _inputDevice {
            _captureSession.addInput(_inputDevice)
        }
    }
    private func removeInputDevice() {
        if let _ = _inputDevice {
        _captureSession.removeInput(_inputDevice!)
        }
    }
    
    private func removeSubLayer() {
        removeSubLayer(_previewLayer)
    }
    
    private func removeSubLayer(layer: AVCaptureVideoPreviewLayer) {
        layer.removeFromSuperlayer()
        _view = nil
        removeInputDevice()
    }
    
    private func addSubLayer() {
        addSubLayer(self._view!, layer: _previewLayer)
    }
    
    private func addSubLayer(view: UIView, layer: AVCaptureVideoPreviewLayer) {
        view.layer.addSublayer(layer)
        _previewLayer.frame = view.layer.frame
    }
}
