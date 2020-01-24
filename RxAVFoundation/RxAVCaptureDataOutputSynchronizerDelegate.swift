//
//  RxAVCaptureDataOutputSynchronizerDelegate.swift
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
public typealias SynchronizerOutput = (synchronizer: AVCaptureDataOutputSynchronizer, synchronizedDataCollection: AVCaptureSynchronizedDataCollection)

@available(iOS 11.0, *)
final class RxAVCaptureDataOutputSynchronizerDelegate: NSObject {
    typealias Observer = AnyObserver<SynchronizerOutput>

    var observer: Observer?
}

extension RxAVCaptureDataOutputSynchronizerDelegate: AVCaptureDataOutputSynchronizerDelegate {
    public func dataOutputSynchronizer(_ synchronizer: AVCaptureDataOutputSynchronizer, didOutput synchronizedDataCollection: AVCaptureSynchronizedDataCollection) {
        observer?.on(.next(SynchronizerOutput(synchronizer, synchronizedDataCollection)))
    }
}
