import AVFoundation
import React

@objc(RCTVideoManager)
class RCTVideoManager: RCTViewManager {
    override static func moduleName() -> String! {
        return "RCTVideo"
    }

    override static func requiresMainQueueSetup() -> Bool {
        return true
    }

    // Define event configurations
    override func constantsToExport() -> [AnyHashable : Any]! {
        return [
            "directEventTypes": [
                "onVideoLoadStart": [
                    "registrationName": "onVideoLoadStart"
                ],
                "onVideoLoad": [
                    "registrationName": "onVideoLoad"
                ],
                "onVideoBuffer": [
                    "registrationName": "onVideoBuffer"
                ],
                "onVideoError": [
                    "registrationName": "onVideoError"
                ],
                "onVideoProgress": [
                    "registrationName": "onVideoProgress"
                ],
                "onVideoBandwidthUpdate": [
                    "registrationName": "onVideoBandwidthUpdate"
                ],
                "onVideoSeek": [
                    "registrationName": "onVideoSeek"
                ],
                "onVideoEnd": [
                    "registrationName": "onVideoEnd"
                ],
                "onTimedMetadata": [
                    "registrationName": "onTimedMetadata"
                ],
                "onVideoAudioBecomingNoisy": [
                    "registrationName": "onVideoAudioBecomingNoisy"
                ],
                "onVideoFullscreenPlayerWillPresent": [
                    "registrationName": "onVideoFullscreenPlayerWillPresent"
                ],
                "onVideoFullscreenPlayerDidPresent": [
                    "registrationName": "onVideoFullscreenPlayerDidPresent"
                ],
                "onVideoFullscreenPlayerWillDismiss": [
                    "registrationName": "onVideoFullscreenPlayerWillDismiss"
                ],
                "onVideoFullscreenPlayerDidDismiss": [
                    "registrationName": "onVideoFullscreenPlayerDidDismiss"
                ],
                "onReadyForDisplay": [
                    "registrationName": "onReadyForDisplay"
                ],
                "onPlaybackRateChange": [
                    "registrationName": "onPlaybackRateChange"
                ],
                "onVolumeChange": [
                    "registrationName": "onVolumeChange"
                ],
                "onVideoPlaybackStateChanged": [
                    "registrationName": "onVideoPlaybackStateChanged"
                ],
                "onVideoExternalPlaybackChange": [
                    "registrationName": "onVideoExternalPlaybackChange"
                ],
                "onGetLicense": [
                    "registrationName": "onGetLicense"
                ],
                "onPictureInPictureStatusChanged": [
                    "registrationName": "onPictureInPictureStatusChanged"
                ],
                "onRestoreUserInterfaceForPictureInPictureStop": [
                    "registrationName": "onRestoreUserInterfaceForPictureInPictureStop"
                ],
                "onReceiveAdEvent": [
                    "registrationName": "onReceiveAdEvent"
                ],
                "onVideoAspectRatio": [
                    "registrationName": "onVideoAspectRatio"
                ],
                "onControlsVisibilityChange": [
                    "registrationName": "onControlsVisibilityChange"
                ]
            ],
            "bubblingEventTypes": [:]
        ]
    }

    override func view() -> UIView {
        guard let eventDispatcher = bridge?.eventDispatcher() else {
            fatalError("RCTVideoManager requires a bridge with an event dispatcher")
        }
        return RCTVideo(eventDispatcher: eventDispatcher)
    }

    func methodQueue() -> DispatchQueue {
        return bridge.uiManager.methodQueue
    }

    func performOnVideoView(withReactTag reactTag: NSNumber, callback: @escaping (RCTVideo?) -> Void) {
        DispatchQueue.main.async { [weak self] in
            guard let self else {
                callback(nil)
                return
            }

            let view = self.bridge.uiManager.view(forReactTag: reactTag)

            guard let videoView = view as? RCTVideo else {
                DebugLog("Invalid view returned from registry, expecting RCTVideo, got: \(String(describing: self.view))")
                callback(nil)
                return
            }

            callback(videoView)
        }
    }

    @objc(seekCmd:time:tolerance:)
    func seekCmd(_ reactTag: NSNumber, time: NSNumber, tolerance: NSNumber) {
        performOnVideoView(withReactTag: reactTag, callback: { videoView in
            videoView?.setSeek(time, tolerance)
        })
    }

    @objc(setLicenseResultCmd:license:licenseUrl:)
    func setLicenseResultCmd(_ reactTag: NSNumber, license: NSString, licenseUrl: NSString) {
        performOnVideoView(withReactTag: reactTag, callback: { videoView in
            videoView?.setLicenseResult(license as String, licenseUrl as String)
        })
    }

    @objc(setLicenseResultErrorCmd:error:licenseUrl:)
    func setLicenseResultErrorCmd(_ reactTag: NSNumber, error: NSString, licenseUrl: NSString) {
        performOnVideoView(withReactTag: reactTag, callback: { videoView in
            videoView?.setLicenseResultError(error as String, licenseUrl as String)
        })
    }

    @objc(setPlayerPauseStateCmd:paused:)
    func setPlayerPauseStateCmd(_ reactTag: NSNumber, paused: Bool) {
        performOnVideoView(withReactTag: reactTag, callback: { videoView in
            videoView?.setPaused(paused)
        })
    }

    @objc(setVolumeCmd:volume:)
    func setVolumeCmd(_ reactTag: NSNumber, volume: Float) {
        performOnVideoView(withReactTag: reactTag, callback: { videoView in
            videoView?.setVolume(volume)
        })
    }

    @objc(setFullScreenCmd:fullscreen:)
    func setFullScreenCmd(_ reactTag: NSNumber, fullScreen: Bool) {
        performOnVideoView(withReactTag: reactTag, callback: { videoView in
            videoView?.setFullscreen(fullScreen)
        })
    }

    @objc(enterPictureInPictureCmd:)
    func enterPictureInPictureCmd(_ reactTag: NSNumber) {
        performOnVideoView(withReactTag: reactTag, callback: { videoView in
            videoView?.enterPictureInPicture()
        })
    }

    @objc(exitPictureInPictureCmd:)
    func exitPictureInPictureCmd(_ reactTag: NSNumber) {
        performOnVideoView(withReactTag: reactTag, callback: { videoView in
            videoView?.exitPictureInPicture()
        })
    }

    @objc(setSourceCmd:source:)
    func setSourceCmd(_ reactTag: NSNumber, source: NSDictionary) {
        performOnVideoView(withReactTag: reactTag, callback: { videoView in
            videoView?.setSrc(source)
        })
    }

    @objc(save:options:resolve:reject:)
    func save(_ reactTag: NSNumber, options: NSDictionary, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        performOnVideoView(withReactTag: reactTag, callback: { videoView in
            videoView?.save(options, resolve, reject)
        })
    }

    @objc(getCurrentPosition:resolve:reject:)
    func getCurrentPosition(_ reactTag: NSNumber, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        performOnVideoView(withReactTag: reactTag, callback: { videoView in
            videoView?.getCurrentPlaybackTime(resolve, reject)
        })
    }
}
