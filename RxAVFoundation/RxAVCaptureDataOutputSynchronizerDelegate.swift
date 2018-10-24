//
//  RxAVCaptureDataOutputSynchronizerDelegate.swift
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

public typealias SynchronizerOutput = (synchronizer: AVCaptureDataOutputSynchronizer, synchronizedDataCollection: AVCaptureSynchronizedDataCollection)

final class RxAVCaptureDataOutputSynchronizerDelegate: NSObject, AVCaptureDataOutputSynchronizerDelegate {
    
    typealias Observer = AnyObserver<SynchronizerOutput>
    
    var observer: Observer?
    
    public func dataOutputSynchronizer(_ synchronizer: AVCaptureDataOutputSynchronizer, didOutput synchronizedDataCollection: AVCaptureSynchronizedDataCollection) {
        observer?.on(.next(SynchronizerOutput(synchronizer, synchronizedDataCollection)))
    }
    
}
