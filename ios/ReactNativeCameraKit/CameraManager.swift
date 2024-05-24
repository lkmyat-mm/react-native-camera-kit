//
//  CameraManager.swift
//  ReactNativeCameraKit
//

import AVFoundation
import Foundation

/*
 * Class managing the communication between React Native and the native implementation
 */
@objc(CKCameraManager) public class CameraManager: RCTViewManager {
    var camera: CameraView?

    override public static func requiresMainQueueSetup() -> Bool {
        return true
    }

    override public func view() -> UIView! {
        camera = CameraView()
        return camera
    }

    @objc func capture(_ options: NSDictionary,
                       resolve: @escaping RCTPromiseResolveBlock,
                       reject: @escaping RCTPromiseRejectBlock) {
        guard let cam = self.camera else {
            reject("capture_error", "CKCamera capture() was called but camera view is nil", nil)
            return
        }
        cam.capture(onSuccess: { resolve($0) },
                    onError: { reject("capture_error", $0, nil) })
    }

    @objc func checkDeviceCameraAuthorizationStatus(_ resolve: @escaping RCTPromiseResolveBlock,
                                                    reject: @escaping RCTPromiseRejectBlock) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized: resolve(true)
        case .notDetermined: resolve(-1)
        default: resolve(false)
        }
    }

    @objc func requestDeviceCameraAuthorization(_ resolve: @escaping RCTPromiseResolveBlock,
                                                reject: @escaping RCTPromiseRejectBlock) {
        AVCaptureDevice.requestAccess(for: .video, completionHandler: { resolve($0) })
    }
}
