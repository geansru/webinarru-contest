//
//  Protocols.swift
//  Webinar.ru-contest
//
//  Created by Dmitriy Roytman on 01.11.15.
//  Copyright © 2015 Dmitriy Roytman. All rights reserved.
//

import UIKit

protocol Singletonable {
    static var sharedManager: Self { get }
}

protocol Captureable {
    func stopCapture() -> CameraState
    func startCapture() -> CameraState
    func setUpCaptureSession(view: UIView, captureQuality: String)
}

protocol Recordable {
    var pauseButton: UIBarButtonItem! { get }
    var recordButton: UIBarButtonItem! { get }
    var captureButton: UIBarButtonItem! { get }
    var stopButton: UIBarButtonItem! { get }
}