//
//  Global.swift
//  RxAVFoundation
//
//  Created by Maxim Volgin on 14/10/2018.
//  Copyright © 2018 Maxim Volgin. All rights reserved.
//

import Foundation
import RxSwift
import os.log

fileprivate let subsystem: String = Bundle.main.bundleIdentifier ?? ""

struct Log {
    static let photo = OSLog(subsystem: subsystem, category: "photo")
    static let video = OSLog(subsystem: subsystem, category: "video")
    static let depth = OSLog(subsystem: subsystem, category: "depth")
    static let synch = OSLog(subsystem: subsystem, category: "synch")
}

fileprivate struct Label {
    fileprivate static let session = "\(subsystem) session queue"
    fileprivate static let dataOutput = "\(subsystem) video data queue"
    fileprivate static let processing = "\(subsystem) photo processing queue"
}

struct Queue {
    static let session = DispatchQueue(label: Label.session, attributes: [], autoreleaseFrequency: .workItem)
    static let dataOutput = DispatchQueue(label: Label.dataOutput, qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)
    static let processing = DispatchQueue(label: Label.processing, attributes: [], autoreleaseFrequency: .workItem)
}

struct Scheduler {
    static let session = SerialDispatchQueueScheduler(queue: Queue.session, internalSerialQueueName: Label.session)
    static let dataOutput = SerialDispatchQueueScheduler(queue: Queue.dataOutput, internalSerialQueueName: Label.dataOutput)
    static let processing = SerialDispatchQueueScheduler(queue: Queue.processing, internalSerialQueueName: Label.processing)
}

public enum RxAVCaptureOutputType: String {
    case photo = "photo"
    case video = "video"
    case depth = "depth"
}

public enum RxAVFoundationError: Error {
    case noConnection(RxAVCaptureOutputType)
    case cannotAddOutput(RxAVCaptureOutputType)
}
