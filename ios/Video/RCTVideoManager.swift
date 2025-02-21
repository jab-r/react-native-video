import AVFoundation
import React
import React_Fabric

@objc(RCTVideoManager)
class RCTVideoManager: RCTViewManager {
    override class func moduleName() -> String! {
        return "RCTVideo"
    }

    override class func requiresMainQueueSetup() -> Bool {
        return true
    }
    
    override func view() -> UIView! {
        #if RCT_NEW_ARCH_ENABLED
        let componentView = RCTVideo(frame: .zero)
        componentView.bridge = bridge
        return componentView
        #else
        guard let eventDispatcher = bridge?.eventDispatcher else {
            RCTLogError("Failed to get event dispatcher")
            return nil
        }
        return RCTVideo(eventDispatcher: eventDispatcher)
        #endif
    }

    override static func propConfig() -> [String: Any]! {
        return [
            "src": [
                "type": "Map",
            ],
            "resizeMode": [
                "type": "String",
                "default": "contain"
            ],
            "repeat": [
                "type": "Boolean",
                "default": false
            ],
            "paused": [
                "type": "Boolean",
                "default": false
            ],
            "muted": [
                "type": "Boolean",
                "default": false
            ],
            "controls": [
                "type": "Boolean",
                "default": false
            ],
            "volume": [
                "type": "Float",
                "default": 1.0
            ],
            "rate": [
                "type": "Float",
                "default": 1.0
            ],
            
            // Events
            "onVideoLoad": [
                "type": "DirectEventHandler",
                "registrationName": "onVideoLoad"
            ],
            "onVideoError": [
                "type": "DirectEventHandler",
                "registrationName": "onVideoError"
            ],
            "onVideoProgress": [
                "type": "DirectEventHandler",
                "registrationName": "onVideoProgress"
            ],
            "onVideoSeek": [
                "type": "DirectEventHandler",
                "registrationName": "onVideoSeek"
            ],
            "onVideoEnd": [
                "type": "DirectEventHandler",
                "registrationName": "onVideoEnd"
            ],
            "onVideoBuffer": [
                "type": "DirectEventHandler",
                "registrationName": "onVideoBuffer"
            ],
            "onPlaybackRateChange": [
                "type": "DirectEventHandler",
                "registrationName": "onPlaybackRateChange"
            ]
        ]
    }

    @objc(seekTo:time:)
    func seek(to reactTag: NSNumber, time: NSNumber) {
        performOnVideoView(withReactTag: reactTag) { videoView in
            videoView?.setSeek(time, NSNumber(value: 100))
        }
    }

    @objc(setPaused:paused:)
    func setPaused(_ reactTag: NSNumber, paused: Bool) {
        performOnVideoView(withReactTag: reactTag) { videoView in
            videoView?.setPaused(paused)
        }
    }

    private func performOnVideoView(withReactTag reactTag: NSNumber, callback: @escaping (RCTVideo?) -> Void) {
        #if RCT_NEW_ARCH_ENABLED
        bridge?.uiManager.synchronouslyUpdateViewOnUIThread(reactTag, viewName: "RCTVideo", props: nil)
        if let view = bridge?.uiManager.view(forReactTag: reactTag) as? RCTVideo {
            callback(view)
        }
        #else
        bridge?.uiManager.addUIBlock { (_, viewRegistry) in
            guard let view = viewRegistry?[reactTag] as? RCTVideo else { return }
            callback(view)
        }
        #endif
    }
}
