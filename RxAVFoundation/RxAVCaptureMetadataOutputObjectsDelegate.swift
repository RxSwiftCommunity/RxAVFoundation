//
//  RxAVCaptureMetadataOutputObjectsDelegate.swift
//  RxAVFoundation
//
//  Created by Maxim Volgin on 21/05/2019.
//  Copyright (c) RxSwiftCommunity. All rights reserved.
//

import AVFoundation
#if !RX_NO_MODULE
import RxCocoa
import RxSwift
#endif

@available(iOS 10.0, *)
public typealias CaptureMetadataOutput = (output: AVCaptureMetadataOutput, metadataObjects: [AVMetadataObject], connection: AVCaptureConnection)

@available(iOS 10.0, *)
final class RxAVCaptureMetadataOutputObjectsDelegate: NSObject {
    typealias Observer = AnyObserver<CaptureMetadataOutput>

    var observer: Observer?
}

extension RxAVCaptureMetadataOutputObjectsDelegate: AVCaptureMetadataOutputObjectsDelegate {
    public func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        observer?.on(.next(CaptureMetadataOutput(output, metadataObjects, connection)))
    }
}
