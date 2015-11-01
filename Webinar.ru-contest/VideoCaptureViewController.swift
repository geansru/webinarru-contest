//
//  VideoCaptureViewController.swift
//  Webinar.ru-contest
//
//  Created by Dmitriy Roytman on 01.11.15.
//  Copyright © 2015 Dmitriy Roytman. All rights reserved.
//

import UIKit
import AVFoundation

class VideoCaptureViewController: UIViewController {
    
    @IBOutlet weak var pauseButton: UIBarButtonItem!
    @IBOutlet weak var recordButton: UIBarButtonItem!
    @IBOutlet weak var captureButton: UIBarButtonItem!
    // MARK: @IBActions
    @IBAction func startCapture() {
        VideoManager.sharedManager.setUpCaptureSession(self.view)
        VideoManager.sharedManager.startCapture()
    }
    @IBAction func startRecordingVideo(sender: AnyObject) {
    }
    
    @IBAction func stopRecordingVideo(sender: AnyObject) {
    }
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

