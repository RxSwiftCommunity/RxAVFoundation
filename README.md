# RxAVFoundation
RxAVFoundation (based on RxSwift)

Basic usage.

```swift
let session = AVCaptureSession.rx.session()
session
    .flatMapLatest { (session) -> Observable<CaptureOutput> in
        return session.captureOutput
    }
    .subscribe { (event) in
        switch event {
        case .next(let captureOutput):
            // handle 'captureOutput'
            break
        case .error(let error):
            // handle error
            break
        case .completed:
            // never happens
            break
        }
    }
    .disposed(by: disposeBag)
```

Carthage setup.

```
github "maxvol/RxAVFoundation" ~> 0.0.1

```


