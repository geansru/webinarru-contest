//
//  PlayVideoViewController.swift
//  Webinar.ru-contest
//
//  Created by Dmitriy Roytman on 01.11.15.
//  Copyright © 2015 Dmitriy Roytman. All rights reserved.
//

import UIKit
import MediaPlayer
import MobileCoreServices

class PlayVideoViewController: UIViewController {
    
    // MARK: Properties
    private var cameraState: CameraState = CameraState.NotUsed
    
    // MARK: @IBAction
    @IBAction func selectAndPlayVideo() {
        startMediaBrowserFromViewController(self, usingDelegate: self)
    }
    
    @IBAction func recordAndSaveVideo(sender: AnyObject) {
        cameraState = CameraState.Recording
        startCameraFromViewController(self, withDelegate: self)
    }

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: Helper
    
    private func startCameraFromViewController(viewController: UIViewController, withDelegate delegate: protocol<UIImagePickerControllerDelegate, UINavigationControllerDelegate>) -> Bool {
        if UIImagePickerController.isSourceTypeAvailable(.Camera) == false {
            return false
        }
        
        let cameraController = UIImagePickerController()
        cameraController.sourceType = .Camera
        cameraController.mediaTypes = [kUTTypeMovie as String]
        cameraController.allowsEditing = false
        cameraController.delegate = delegate
        
        presentViewController(cameraController, animated: true, completion: nil)
        return true
    }
    
    private func startMediaBrowserFromViewController(viewController: UIViewController, usingDelegate delegate: protocol<UINavigationControllerDelegate, UIImagePickerControllerDelegate>) -> Bool {
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum) {
            return false
        }
        
        let mediaUI = UIImagePickerController()
        mediaUI.sourceType = .SavedPhotosAlbum
        mediaUI.mediaTypes = [kUTTypeMovie as String]
        mediaUI.allowsEditing = true
        mediaUI.delegate = delegate
        
        presentViewController(mediaUI, animated: true, completion: nil)
        return true
    }
}

// MARK: - UIImagePickerControllerDelegate
extension PlayVideoViewController: UIImagePickerControllerDelegate {
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
            block = { self.startMediaBrowserFromViewController(self, usingDelegate: self) }
        default: break
        }
        dismissViewControllerAnimated(true, completion: block)
    }
}

// MARK: - UINavigationControllerDelegate
extension PlayVideoViewController: UINavigationControllerDelegate {
    
}
