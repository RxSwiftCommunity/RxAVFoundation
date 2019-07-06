//
//  RxAVCaptureDepthDataOutputDelegate.swift
//  RxAVFoundation
//
//  Created by Maxim Volgin on 13/10/2018.
//  Copyright (c) RxSwiftCommunity. All rights reserved.
//

import AVFoundation
#if !RX_NO_MODULE
import RxSwift
import RxCocoa
#endif

@available(iOS 11.0, *)
public typealias DepthCaptureOutput = (depthDataOutput: AVCaptureDepthDataOutput, depthData: AVDepthData, timestamp: CMTime, connection: AVCaptureConnection)

@available(iOS 11.0, *)
final class RxAVCaptureDepthDataOutputDelegate: NSObject, AVCaptureDepthDataOutputDelegate {
    
    typealias Observer = AnyObserver<DepthCaptureOutput>
    
    var observer: Observer?
    
    public func depthDataOutput(_ depthDataOutput: AVCaptureDepthDataOutput, didOutput depthData: AVDepthData, timestamp: CMTime, connection: AVCaptureConnection) {
        observer?.on(.next(DepthCaptureOutput(depthDataOutput, depthData, timestamp, connection)))
    }
    
}
