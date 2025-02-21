import Foundation

@objcMembers
class VideoLogger: NSObject {
    @objc static func debug(_ message: String, data: [String: Any]? = nil) {
        RCTVideoLogger.emitLogEvent("debug", message: message, data: data as NSDictionary?)
    }
    
    @objc static func info(_ message: String, data: [String: Any]? = nil) {
        RCTVideoLogger.emitLogEvent("info", message: message, data: data as NSDictionary?)
    }
    
    @objc static func error(_ message: String, data: [String: Any]? = nil) {
        RCTVideoLogger.emitLogEvent("error", message: message, data: data as NSDictionary?)
    }
}
