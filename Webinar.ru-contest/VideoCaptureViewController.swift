//
//  VideoCaptureViewController.swift
//  Webinar.ru-contest
//
//  Created by Dmitriy Roytman on 01.11.15.
//  Copyright © 2015 Dmitriy Roytman. All rights reserved.
//

import UIKit
import AVFoundation

class VideoCaptureViewController: UIViewController, Recordable {
    // MARK: Properties
    private var cameraState: CameraState = CameraState.NotUsed
    // MARK: @IBOutlets
    @IBOutlet weak var pauseButton: UIBarButtonItem!
    @IBOutlet weak var recordButton: UIBarButtonItem!
    @IBOutlet weak var captureButton: UIBarButtonItem!
    @IBOutlet weak var stopButton: UIBarButtonItem!
    // MARK: @IBActions
    @IBAction func startCapture() {
        VideoManager.sharedManager.setUpCaptureSession(self.view)
        cameraState = VideoManager.sharedManager.startCapture()
        cameraState.setUpButtons(self)
    }
    @IBAction func startRecordingVideo(sender: AnyObject) {
    }
    
    @IBAction func stopRecordingVideo(sender: AnyObject) {
        cameraState = VideoManager.sharedManager.stopCapture()
        cameraState.setUpButtons(self)
    }
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraState.setUpButtons(self)
    }
}

