import Foundation
import React

@objc(VideoLogger)
class VideoLogger: RCTEventEmitter {
    static var shared: VideoLogger!
    
    private var hasListeners = false
    private var queuedLogs: [[String: Any]] = []
    
    override init() {
        super.init()
        VideoLogger._shared = self
    }
    
    override class func moduleName() -> String! {
        return "VideoLogger"
    }
    
    override static func requiresMainQueueSetup() -> Bool {
        return true
    }
    
    override func supportedEvents() -> [String]! {
        return ["VideoModuleLog"]
    }
    
    override func startObserving() {
        hasListeners = true
        // Send any queued logs
        for log in queuedLogs {
            sendEvent(withName: "VideoModuleLog", body: log)
        }
        queuedLogs.removeAll()
    }
    
    override func stopObserving() {
        hasListeners = false
    }
    
    private func queueOrSendLog(level: String, message: String, data: [String: Any]?) {
        let log: [String: Any] = [
            "level": level,
            "message": message,
            "data": data as Any
        ]
        
        if hasListeners {
            sendEvent(withName: "VideoModuleLog", body: log)
        } else {
            queuedLogs.append(log)
        }
    }
    
    @objc func debug(_ message: String, data: [String: Any]? = nil) {
        queueOrSendLog(level: "debug", message: message, data: data)
    }
    
    @objc func info(_ message: String, data: [String: Any]? = nil) {
        queueOrSendLog(level: "info", message: message, data: data)
    }
    
    @objc func error(_ message: String, data: [String: Any]? = nil) {
        queueOrSendLog(level: "error", message: message, data: data)
    }
}
