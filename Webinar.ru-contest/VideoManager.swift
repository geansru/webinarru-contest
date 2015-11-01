//
//  VideoManager.swift
//  Webinar.ru-contest
//
//  Created by Dmitriy Roytman on 01.11.15.
//  Copyright © 2015 Dmitriy Roytman. All rights reserved.
//

import UIKit
import AVFoundation

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
    
    //MARK: Public properties
    
    // MARK: Private properties
    private weak var _view: UIView? = nil
    private lazy var _captureSession: AVCaptureSession = { return AVCaptureSession() }()
    private lazy var _device: AVCaptureDevice! = {
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
    
    // MARK: Adopt Protocol Captureable
    func stopCapture() {
        _captureSession.stopRunning()
        removeSubLayer()
    }
    
    func startCapture() {
        addSubLayer()
        beginSession()
        _captureSession.startRunning()
    }
    func setUpCaptureSession(view: UIView, captureQuality: String = AVCaptureSessionPresetLow) {
        _captureSession.sessionPreset = captureQuality
        self._view = view
    }
    
    // MARK: private functions
    
    private func beginSession() {
        do {
            let input = try AVCaptureDeviceInput(device: _device)
            _captureSession.addInput(input)
        } catch let error as NSError {
            // Process received error
            print(error.localizedDescription)
        }
    }
    
    private func removeSubLayer() {
        removeSubLayer(_previewLayer)
    }
    
    private func removeSubLayer(layer: AVCaptureVideoPreviewLayer) {
        layer.removeFromSuperlayer()
        _view = nil
    }
    
    private func addSubLayer() {
        addSubLayer(self._view!, layer: _previewLayer)
    }
    
    private func addSubLayer(view: UIView, layer: AVCaptureVideoPreviewLayer) {
        view.layer.addSublayer(layer)
        _previewLayer.frame = view.layer.frame
    }
}