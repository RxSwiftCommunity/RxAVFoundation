//
//  AVCaptureSession+Rx.swift
//  RxAVFoundation
//
//  Created by Maxim Volgin on 27/09/2018.
//  Copyright © 2018 Maxim Volgin. All rights reserved.
//

import AVFoundation
#if !RX_NO_MODULE
import RxSwift
import RxCocoa
#endif

public typealias CaptureOutput = (output: AVCaptureOutput, sampleBuffer: CMSampleBuffer, connection: AVCaptureConnection)

final class RxAVCaptureVideoDataOutputSampleBufferDelegate: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    typealias Observer = AnyObserver<CaptureOutput>
    
    var observer: Observer?
    
    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        observer?.on(.next(CaptureOutput(output, sampleBuffer, connection)))
    }
    
}

public struct RxAVCaptureSession {
    
    public let session: AVCaptureSession
    public let previewLayer: AVCaptureVideoPreviewLayer
    public let captureOutput: Observable<CaptureOutput>

    private let delegate: RxAVCaptureVideoDataOutputSampleBufferDelegate

    public init() {
        let session = AVCaptureSession()
        let delegate = RxAVCaptureVideoDataOutputSampleBufferDelegate()
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        let captureOutput: Observable<CaptureOutput> = Observable
            .create { observer in
                delegate.observer = observer
                return Disposables.create {
                    session.stopRunning()
                }
            }
            .do(onSubscribed: {
                session.sessionPreset = AVCaptureSession.Preset.photo
                let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
                let deviceInput = try! AVCaptureDeviceInput(device: captureDevice!)
                let deviceOutput = AVCaptureVideoDataOutput()
                deviceOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)]
                deviceOutput.setSampleBufferDelegate(delegate, queue: DispatchQueue.global(qos: DispatchQoS.QoSClass.default))
                session.addInput(deviceInput)
                session.addOutput(deviceOutput)
                deviceOutput.connections.first?.videoOrientation = .portrait
                session.startRunning()
            })
        self.captureOutput = captureOutput
        self.previewLayer = previewLayer
        self.delegate = delegate
        self.session = session
    }
    
}

extension Reactive where Base: AVCaptureSession {
    
    static public func session() -> Observable<RxAVCaptureSession> {
        return Observable
            .create { observer in
                let session = RxAVCaptureSession()
                observer.on(.next(session))
                return Disposables.create()
            }
            .share(replay: 1, scope: .whileConnected)
    }
    
}
