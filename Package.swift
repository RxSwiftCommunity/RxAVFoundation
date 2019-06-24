// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "RxAVFoundation",
    products: [
        .library(
            name: "RxAVFoundation",
            targets: ["RxAVFoundation"])
    ],
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift", from: "5.0.1")
    ],
    targets: [
        .target(
            name: "RxAVFoundation",
            dependencies: ["RxSwift", "RxCocoa"],
            path: "RxAVFoundation")
    ]
)
