//
//  RxAVCapturePhotoCaptureDelegate.swift
//  RxAVFoundation
//
//  Created by Maxim Volgin on 13/10/2018.
//  Copyright (c) RxSwiftCommunity. All rights reserved.
//

import AVFoundation
#if !RX_NO_MODULE
import RxCocoa
import RxSwift
#endif

@available(iOS 11.0, *)
public typealias PhotoCaptureOutput = (output: AVCapturePhotoOutput, photo: AVCapturePhoto, error: Error?)

@available(iOS 11.0, *)
final class RxAVCapturePhotoCaptureDelegate: NSObject {
    typealias Observer = AnyObserver<PhotoCaptureOutput>

    var observer: Observer?
}

extension RxAVCapturePhotoCaptureDelegate: AVCapturePhotoCaptureDelegate {
    public func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        observer?.on(.next(PhotoCaptureOutput(output, photo, error)))
    }
}
