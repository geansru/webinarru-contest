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
    func stopCapture()
    func startCapture()
    func setUpCaptureSession(view: UIView, captureQuality: String)
}