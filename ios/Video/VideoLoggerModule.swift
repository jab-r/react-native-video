import Foundation

@objc(VideoLogger)
class VideoLogger: RCTEventEmitter {
    override static func requiresMainQueueSetup() -> Bool {
        return false
    }
    
    override func supportedEvents() -> [String] {
        return ["VideoModuleLog"]
    }
    
    @objc
    static func emitLogEvent(_ level: String, message: String, data: NSDictionary?) {
        let shared = RCTBridge.current()?.module(for: VideoLogger.self) as? VideoLogger
        shared?.sendEvent(withName: "VideoModuleLog", body: [
            "level": level,
            "message": message,
            "data": data ?? NSNull()
        ])
    }
}
