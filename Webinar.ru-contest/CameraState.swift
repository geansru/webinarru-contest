//
//  CameraState.swift
//  Webinar.ru-contest
//
//  Created by Dmitriy Roytman on 01.11.15.
//  Copyright © 2015 Dmitriy Roytman. All rights reserved.
//

import UIKit

enum CameraState {
    case NotUsed, Capturing, Recording, Paused
    
    func setUpButtons(view: Recordable) {
        switch self {
        case .NotUsed:
            view.captureButton.enabled = true
            view.selectButton?.enabled = true
            view.recordButton?.enabled = false
            view.stopButton.enabled = false
        case .Capturing, .Paused:
            view.captureButton.enabled = false
            view.selectButton?.enabled = false
            view.recordButton?.enabled = true
            view.stopButton.enabled = true
        case .Recording:
            view.captureButton.enabled = false
            view.selectButton?.enabled = true
            view.recordButton?.enabled = false
            view.stopButton.enabled = true
        }
    }
}