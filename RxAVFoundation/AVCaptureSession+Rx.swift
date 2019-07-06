//
//  AVCaptureSession+Rx.swift
//  RxAVFoundation
//
//  Created by Maxim Volgin on 27/09/2018.
//  Copyright (c) RxSwiftCommunity. All rights reserved.
//

import os.log
import AVFoundation
#if !RX_NO_MODULE
import RxSwift
import RxCocoa
#endif

@available(iOS 10.0, *)
extension Reactive where Base: AVCaptureSession {
    
    public func configure(preset: AVCaptureSession.Preset = .photo, captureDevice: AVCaptureDevice) {
        self.configure { session in
            session.sessionPreset = preset
            let deviceInput = try! AVCaptureDeviceInput(device: captureDevice)
            session.addInput(deviceInput)
        }
    }
    
    public func startRunning() {
        Queue.session.async {
            self.base.startRunning()
        }
    }
    
    public func stopRunning() {
        Queue.session.async {
            self.base.stopRunning()
        }
    }
    
    public func medatataCaptureOutput(metadataObjectTypes: [AVMetadataObject.ObjectType]) -> Observable<CaptureMetadataOutput> {
        let metadataOutput = AVCaptureMetadataOutput()
        let metadataCaptureDelegate = RxAVCaptureMetadataOutputObjectsDelegate()
        let metadataCaptureOutput: Observable<CaptureMetadataOutput> = Observable
            .create { observer in
                metadataCaptureDelegate.observer = observer
                
                self.configure { session in
                    if session.canAddOutput(metadataOutput) {
                        session.addOutput(metadataOutput)
                        
                        metadataOutput.metadataObjectTypes = metadataObjectTypes
                        
                    } else {
                        os_log("Could not add metadata output to the session", log: Log.meta, type: .error)
                        observer.onError(RxAVFoundationError.cannotAddOutput(.meta))
                    }
                }
                
                return Disposables.create {
                    self.configure { session in
                        session.removeOutput(metadataOutput)
                    }
                }
            }
            .subscribeOn(Scheduler.session)
        //            .observeOn(Scheduler.dataOutput)
        return metadataCaptureOutput
    }
    
    @available(iOS 11.0, *)
    public func photoCaptureOutput(highResolution: Bool = true, depth: Bool = true) -> Observable<PhotoCaptureOutput> {
        let photoOutput = AVCapturePhotoOutput()
        let photoCaptureDelegate = RxAVCapturePhotoCaptureDelegate()
        let photoCaptureOutput: Observable<PhotoCaptureOutput> = Observable
            .create { observer in
                photoCaptureDelegate.observer = observer
                
                self.configure { session in
                    if session.canAddOutput(photoOutput) {
                        session.addOutput(photoOutput)
                        
                        photoOutput.isHighResolutionCaptureEnabled = highResolution
                        
                        if photoOutput.isDepthDataDeliverySupported {
                            photoOutput.isDepthDataDeliveryEnabled = depth
                        }
                    } else {
                        os_log("Could not add photo data output to the session", log: Log.photo, type: .error)
                        observer.onError(RxAVFoundationError.cannotAddOutput(.photo))
                    }
                }
                
                return Disposables.create {
                    self.configure { session in
                        session.removeOutput(photoOutput)
                    }
                }
            }
            .subscribeOn(Scheduler.session)
        //            .observeOn(Scheduler.dataOutput)
        return photoCaptureOutput
    }
    
    public func videoCaptureOutput(orientation: AVCaptureVideoOrientation = .portrait, settings: [String : Any] = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)]) -> Observable<VideoCaptureOutput> {
        let videoOutput = AVCaptureVideoDataOutput()
        let videoCaptureDelegate = RxAVCaptureVideoDataOutputSampleBufferDelegate()
        let videoCaptureOutput: Observable<VideoCaptureOutput> = Observable
            .create { observer in
                videoCaptureDelegate.observer = observer
                
                self.configure { session in
                    videoOutput.videoSettings = settings
                    videoOutput.setSampleBufferDelegate(videoCaptureDelegate, queue: Queue.dataOutput)
                    session.addOutput(videoOutput)
                    videoOutput.connections.first?.videoOrientation = orientation
                }
                
                return Disposables.create {
                    self.configure { session in
                        session.removeOutput(videoOutput)
                    }
                }
            }
            .subscribeOn(Scheduler.session)
        //            .observeOn(Scheduler.dataOutput)
        return videoCaptureOutput
    }
    
    @available(iOS 11.0, *)
    public func depthCaptureOutput(filteringEnabled: Bool = true) -> Observable<DepthCaptureOutput> {
        let depthOutput = AVCaptureDepthDataOutput()
        let depthCaptureDelegate = RxAVCaptureDepthDataOutputDelegate()
        let depthCaptureOutput: Observable<DepthCaptureOutput> = Observable
            .create { observer in
                depthCaptureDelegate.observer = observer
                
                self.configure { session in
                    if session.canAddOutput(depthOutput) {
                        session.addOutput(depthOutput)
                        depthOutput.setDelegate(depthCaptureDelegate, callbackQueue: Queue.dataOutput)
                        depthOutput.isFilteringEnabled = filteringEnabled
                        if let connection = depthOutput.connection(with: .depthData) {
                            connection.isEnabled = true
                        } else {
                            os_log("No AVCaptureConnection", log: Log.depth, type: .error)
                            observer.onError(RxAVFoundationError.noConnection(.depth))
                        }
                    } else {
                        os_log("Could not add depth data output to the session", log: Log.depth, type: .error)
                        observer.onError(RxAVFoundationError.cannotAddOutput(.depth))
                    }
                }
                
                return Disposables.create {
                    self.configure { session in
                        session.removeOutput(depthOutput)
                    }
                }
            }
            .subscribeOn(Scheduler.session)
        //            .observeOn(Scheduler.dataOutput)
        return depthCaptureOutput
    }
    
    @available(iOS 11.0, *)
    public func synchronizerOutput(dataOutputs: [AVCaptureOutput]) -> Observable<SynchronizerOutput> {
        let outputSynchronizer = AVCaptureDataOutputSynchronizer(dataOutputs: dataOutputs) // TODO [videoDataOutput, depthDataOutput])
        let synchronizerDelegate = RxAVCaptureDataOutputSynchronizerDelegate()
        let synchronizerOutput: Observable<SynchronizerOutput> = Observable
            .create { observer in
                synchronizerDelegate.observer = observer
                
                self.configure { session in
                    outputSynchronizer.setDelegate(synchronizerDelegate, queue: Queue.dataOutput)
                }
                
                return Disposables.create {
                    // NOOP
                }
            }
            .subscribeOn(Scheduler.session)
        //            .observeOn(Scheduler.dataOutput)
        return synchronizerOutput
    }
    
    public var outputs: Single<[AVCaptureOutput]> {
        get {
            return Single<[AVCaptureOutput]>
                .create { observer -> Disposable in
                    observer(.success(self.base.outputs))
                    return Disposables.create()
                }
                .subscribeOn(Scheduler.session)
        }
    }
    
    // MARK: - private
    
    private func configure(lambda: (AVCaptureSession) -> Void) {
        self.base.beginConfiguration()
        lambda(self.base)
        self.base.commitConfiguration()
    }
    
}
