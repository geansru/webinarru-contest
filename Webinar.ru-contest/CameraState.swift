//
//  CameraState.swift
//  Webinar.ru-contest
//
//  Created by Dmitriy Roytman on 01.11.15.
//  Copyright © 2015 Dmitriy Roytman. All rights reserved.
//

import UIKit

enum CameraState {
    case NotUsed, Capturing, Recording, Listing
    
    func setUpButtons(viewController: Recordable) {
        switch self {
        case .NotUsed, .Recording, .Listing:
            viewController.captureButton.enabled = true
            viewController.selectButton?.enabled = true
            viewController.recordButton?.enabled = true
            viewController.stopButton.enabled = false
        case .Capturing:
            viewController.captureButton.enabled = false
            viewController.selectButton?.enabled = false
            viewController.recordButton?.enabled = false
            viewController.stopButton.enabled = true
        }
    }
}