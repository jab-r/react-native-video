import AVFoundation
import React
import React_Fabric
import VideoModule

@objc(RCTVideoManager)
class RCTVideoManager: RCTViewManager {
    private var logger: VideoLogger!
    
    override class func moduleName() -> String! {
        return "RCTVideo"
    }

    override class func requiresMainQueueSetup() -> Bool {
        return true
    }
    
    override init() {
        super.init()
        logger = VideoLogger.shared
        logger.info("Module initialized")
        logger.debug("Main queue setup required: true")
    }
    
    override func view() -> UIView! {
        logger.debug("Creating video view")
        #if RCT_NEW_ARCH_ENABLED
        let componentView = RCTVideo(frame: .zero)
        componentView.bridge = bridge
        logger.debug("Created Fabric video view")
        return componentView
        #else
        guard let eventDispatcher = bridge?.eventDispatcher else {
            logger.error("Failed to get event dispatcher")
            return nil
        }
        let view = RCTVideo(eventDispatcher: eventDispatcher)
        logger.debug("Created legacy video view")
        return view
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
        logger.debug("Performing operation on video view", data: ["tag": reactTag])
        #if RCT_NEW_ARCH_ENABLED
        bridge?.uiManager.synchronouslyUpdateViewOnUIThread(reactTag, viewName: "RCTVideo", props: nil)
        if let view = bridge?.uiManager.view(forReactTag: reactTag) as? RCTVideo {
            logger.debug("Found Fabric video view, executing callback", data: ["tag": reactTag])
            callback(view)
        } else {
            logger.error("Failed to find Fabric video view", data: ["tag": reactTag])
        }
        #else
        bridge?.uiManager.addUIBlock { (_, viewRegistry) in
            guard let view = viewRegistry?[reactTag] as? RCTVideo else {
                logger.error("Failed to find legacy video view", data: ["tag": reactTag])
                return
            }
            logger.debug("Found legacy video view, executing callback", data: ["tag": reactTag])
            callback(view)
        }
        #endif
    }
}
