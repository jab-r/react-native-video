import AVFoundation
import React

@objc(RCTVideoManager)
class RCTVideoManager: RCTViewManager {
    override class func moduleName() -> String! {
        return "RCTVideo"
    }

    override class func requiresMainQueueSetup() -> Bool {
        return true
    }

    override class func propConfig() -> [String: Any] {
        return [
            "src": [NSNumber(value: RCTViewManager.RCT_EXPORT_VIEW_PROPERTY), "NSDictionary"],
            "paused": [NSNumber(value: RCTViewManager.RCT_EXPORT_VIEW_PROPERTY), "BOOL"],
            "muted": [NSNumber(value: RCTViewManager.RCT_EXPORT_VIEW_PROPERTY), "BOOL"],
            "controls": [NSNumber(value: RCTViewManager.RCT_EXPORT_VIEW_PROPERTY), "BOOL"],
            "volume": [NSNumber(value: RCTViewManager.RCT_EXPORT_VIEW_PROPERTY), "float"],
            "playInBackground": [NSNumber(value: RCTViewManager.RCT_EXPORT_VIEW_PROPERTY), "BOOL"],
            "resizeMode": [NSNumber(value: RCTViewManager.RCT_EXPORT_VIEW_PROPERTY), "NSString"],
            "repeat": [NSNumber(value: RCTViewManager.RCT_EXPORT_VIEW_PROPERTY), "BOOL"],
            "rate": [NSNumber(value: RCTViewManager.RCT_EXPORT_VIEW_PROPERTY), "float"],
            
            // Events
            "onLoad": [NSNumber(value: RCTViewManager.RCT_EXPORT_VIEW_PROPERTY), "RCTDirectEventBlock"],
            "onLoadStart": [NSNumber(value: RCTViewManager.RCT_EXPORT_VIEW_PROPERTY), "RCTDirectEventBlock"],
            "onBuffer": [NSNumber(value: RCTViewManager.RCT_EXPORT_VIEW_PROPERTY), "RCTDirectEventBlock"],
            "onError": [NSNumber(value: RCTViewManager.RCT_EXPORT_VIEW_PROPERTY), "RCTDirectEventBlock"],
            "onProgress": [NSNumber(value: RCTViewManager.RCT_EXPORT_VIEW_PROPERTY), "RCTDirectEventBlock"],
            "onSeek": [NSNumber(value: RCTViewManager.RCT_EXPORT_VIEW_PROPERTY), "RCTDirectEventBlock"],
            "onEnd": [NSNumber(value: RCTViewManager.RCT_EXPORT_VIEW_PROPERTY), "RCTDirectEventBlock"],
            "onReadyForDisplay": [NSNumber(value: RCTViewManager.RCT_EXPORT_VIEW_PROPERTY), "RCTDirectEventBlock"],
            "onPlaybackRateChange": [NSNumber(value: RCTViewManager.RCT_EXPORT_VIEW_PROPERTY), "RCTDirectEventBlock"],
            "onFullscreenPlayerWillPresent": [NSNumber(value: RCTViewManager.RCT_EXPORT_VIEW_PROPERTY), "RCTDirectEventBlock"],
            "onFullscreenPlayerDidPresent": [NSNumber(value: RCTViewManager.RCT_EXPORT_VIEW_PROPERTY), "RCTDirectEventBlock"],
            "onFullscreenPlayerWillDismiss": [NSNumber(value: RCTViewManager.RCT_EXPORT_VIEW_PROPERTY), "RCTDirectEventBlock"],
            "onFullscreenPlayerDidDismiss": [NSNumber(value: RCTViewManager.RCT_EXPORT_VIEW_PROPERTY), "RCTDirectEventBlock"]
        ]
    }

    override func view() -> UIView! {
        guard let eventDispatcher = bridge?.eventDispatcher else {
            RCTLogError("Failed to get event dispatcher")
            return nil
        }
        return RCTVideo(eventDispatcher: eventDispatcher)
    }

    override func constantsToExport() -> [AnyHashable : Any]! {
        return [
            "ScaleNone": AVLayerVideoGravity.resizeAspect.rawValue,
            "ScaleToFill": AVLayerVideoGravity.resize.rawValue,
            "ScaleAspectFit": AVLayerVideoGravity.resizeAspect.rawValue,
            "ScaleAspectFill": AVLayerVideoGravity.resizeAspectFill.rawValue
        ]
    }

    func methodQueue() -> DispatchQueue {
        return DispatchQueue.main
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

    @objc(setMuted:muted:)
    func setMuted(_ reactTag: NSNumber, muted: Bool) {
        performOnVideoView(withReactTag: reactTag) { videoView in
            videoView?.setMuted(muted)
        }
    }

    @objc(setVolume:volume:)
    func setVolume(_ reactTag: NSNumber, volume: Float) {
        performOnVideoView(withReactTag: reactTag) { videoView in
            videoView?.setVolume(volume)
        }
    }

    private func performOnVideoView(withReactTag reactTag: NSNumber, callback: @escaping (RCTVideo?) -> Void) {
        #if RCT_NEW_ARCH_ENABLED
        // For Fabric
        self.bridge?.uiManager.addUIBlock { (_, viewRegistry) in
            let view = viewRegistry?[reactTag]
            guard let videoView = view as? RCTVideo else {
                RCTLogError("Invalid view returned from registry, expecting RCTVideo, got: \(String(describing: view))")
                callback(nil)
                return
            }
            callback(videoView)
        }
        #else
        // For old bridge mode
        self.bridge?.uiManager.addUIBlock { (_, viewRegistry) in
            let view = viewRegistry?[reactTag]
            guard let videoView = view as? RCTVideo else {
                RCTLogError("Invalid view returned from registry, expecting RCTVideo, got: \(String(describing: view))")
                callback(nil)
                return
            }
            callback(videoView)
        }
        #endif
    }
}
