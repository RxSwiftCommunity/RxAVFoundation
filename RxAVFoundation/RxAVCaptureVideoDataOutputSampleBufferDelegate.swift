//
//  RxAVCaptureVideoDataOutputSampleBufferDelegate.swift
//  RxAVFoundation
//
//  Created by Maxim Volgin on 13/10/2018.
//  Copyright © 2018 Maxim Volgin. All rights reserved.
//

import AVFoundation
#if !RX_NO_MODULE
import RxSwift
import RxCocoa
#endif

public typealias VideoCaptureOutput = (output: AVCaptureOutput, sampleBuffer: CMSampleBuffer, connection: AVCaptureConnection)

final class RxAVCaptureVideoDataOutputSampleBufferDelegate: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    typealias Observer = AnyObserver<VideoCaptureOutput>
    
    var observer: Observer?
    
    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        observer?.on(.next(VideoCaptureOutput(output, sampleBuffer, connection)))
    }
    
}
