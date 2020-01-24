//
//  RxAVCaptureVideoDataOutputSampleBufferDelegate.swift
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

@available(iOS 10.0, *)
public typealias VideoCaptureOutput = (output: AVCaptureOutput, sampleBuffer: CMSampleBuffer, connection: AVCaptureConnection)

@available(iOS 10.0, *)
final class RxAVCaptureVideoDataOutputSampleBufferDelegate: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    typealias Observer = AnyObserver<VideoCaptureOutput>

    var observer: Observer?
}

extension RxAVCaptureVideoDataOutputSampleBufferDelegate: AVCaptureVideoDataOutputSampleBufferDelegate {
    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        observer?.on(.next(VideoCaptureOutput(output, sampleBuffer, connection)))
    }
}
