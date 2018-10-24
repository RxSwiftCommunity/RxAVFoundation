# RxAVFoundation
RxAVFoundation (based on RxSwift)

Basic usage.

```swift
var session = AVCaptureSession()

session
    .rx
    .configure(captureDevice: captureDevice) // define 'captureDevice' first
    
session
    .rx
    .videoCaptureOutput()
    .observeOn(MainScheduler.instance)
    .subscribe { [unowned self] (event) in
        switch event {
            case .next(let captureOutput):
                self.processVideo(sampleBuffer: captureOutput.sampleBuffer) // define the method first
            case .error(let error):
                os_log("error: %@", "\(error)")
            case .completed:                
                break // never happens
        }
    }
    .disposed(by: disposeBag)
    
session
    .rx
    .depthCaptureOutput()
    .observeOn(MainScheduler.instance)
    .subscribe { [unowned self] (event) in
        switch event {
            case .next(let captureOutput):
                self.processDepth(depthData: captureOutput.depthData) // define the method first
            case .error(let error):
                os_log("error: %@", "\(error)")
            case .completed:                
                break // never happens
            }
    }
    .disposed(by: disposeBag)
    
session
    .rx
    .outputs
    .asObservable()
    .flatMap { [unowned self] outputs in
        self.session.rx.synchronizerOutput(dataOutputs: outputs)
    }
    .observeOn(MainScheduler.instance)
    .subscribe { [unowned self] (event) in
        switch event {
        case .next(let synchronizerOutput):
            let videoDataOutput = self.session.outputs.filter { $0 is AVCaptureVideoDataOutput }.first!
            let depthDataOutput = self.session.outputs.filter { $0 is AVCaptureDepthDataOutput }.first!
            // ...
        case .error(let error):
            os_log("error: %@", "\(error)")
        case .completed:                
            break // never happens
        }
    }
    .disposed(by: disposeBag)
    
session
    .rx
    .startRunning()
```

Carthage setup.

```
github "maxvol/RxAVFoundation" ~> 0.0.3

```


