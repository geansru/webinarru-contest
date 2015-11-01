//
//  VideoCaptureViewController.swift
//  Webinar.ru-contest
//
//  Created by Dmitriy Roytman on 01.11.15.
//  Copyright © 2015 Dmitriy Roytman. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer
import MobileCoreServices

class VideoCaptureViewController: UIViewController, Recordable {
    // MARK: Properties
    private var cameraState: CameraState = CameraState.NotUsed
    // MARK: @IBOutlets
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var selectButton: UIBarButtonItem!
    @IBOutlet weak var recordButton: UIBarButtonItem!
    @IBOutlet weak var captureButton: UIBarButtonItem!
    @IBOutlet weak var stopButton: UIBarButtonItem!
    // MARK: @IBActions
    @IBAction func startCapture() {
        VideoManager.sharedManager.setUpCaptureSession(self.view)
        cameraState = VideoManager.sharedManager.startCapture()
        self.view.bringSubviewToFront(toolbar)
        cameraState.setUpButtons(self)
    }
    
    @IBAction func exit(sender: AnyObject) {
        stopCaptureVideo()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func stopCaptureVideo() {
        cameraState = VideoManager.sharedManager.stopCapture()
        cameraState.setUpButtons(self)
    }
    
    @IBAction func record() {
        cameraState = CameraState.Recording
        VideoManager.sharedManager.startCameraFromViewController(self, withDelegate: self)
        cameraState.setUpButtons(self)
    }
    
    @IBAction func selectAndPlay() {
        cameraState = CameraState.NotUsed
        VideoManager.sharedManager.startMediaBrowserFromViewController(self, usingDelegate: self)
        cameraState.setUpButtons(self)
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraState.setUpButtons(self)
    }
}

// MARK: - UIImagePickerControllerDelegate
extension VideoCaptureViewController: UIImagePickerControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        guard let mediaType = info[UIImagePickerControllerMediaType] as? NSString else {
            dismissViewControllerAnimated(true, completion: nil)
            return
        }
        var block: (()->())? = nil
        switch cameraState {
        case .NotUsed:
            block = { () -> Void in
                if mediaType == kUTTypeMovie {
                    let moviePlayer = MPMoviePlayerViewController(contentURL: info[UIImagePickerControllerMediaURL] as! NSURL)
                    self.presentMoviePlayerViewControllerAnimated(moviePlayer)
                }
            }
        case .Recording:
            block = {
                // Handle a movie capture
                if mediaType == kUTTypeMovie {
                    let path = (info[UIImagePickerControllerMediaURL] as! NSURL).path
                    if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(path!) {
                        UISaveVideoAtPathToSavedPhotosAlbum(path!, self, nil, nil)
                        print(path)
                    }
                }
                            }
        default: break
        }
        dismissViewControllerAnimated(true, completion: block)
        self.cameraState = CameraState.NotUsed
        self.cameraState.setUpButtons(self)
    }
}

// MARK: - UINavigationControllerDelegate
extension VideoCaptureViewController: UINavigationControllerDelegate {
    
}


