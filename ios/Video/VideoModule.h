#import <React/RCTViewManager.h>
#import <React/RCTBridgeModule.h>
#import <React/RCTEventDispatcher.h>
#import <React/RCTBridge.h>
#import <React/RCTUIManager.h>
#import <React/RCTComponent.h>
#import <React/RCTEventEmitter.h>

NS_ASSUME_NONNULL_BEGIN

// Export the logger
@interface VideoLogger : RCTEventEmitter
+ (void)debug:(NSString *)message data:(NSDictionary *)data;
+ (void)info:(NSString *)message data:(NSDictionary *)data;
+ (void)error:(NSString *)message data:(NSDictionary *)data;
@end

// Forward declarations
@class RCTVideo;

// Export the video manager
@interface RCTVideoManager : RCTViewManager

// Required methods
+ (NSString *)moduleName;
+ (BOOL)requiresMainQueueSetup;

// Video control methods
- (void)seekTo:(nonnull NSNumber *)reactTag time:(nonnull NSNumber *)time;
- (void)setSrc:(nonnull NSNumber *)reactTag src:(nonnull NSDictionary *)src;
- (void)setFullscreen:(nonnull NSNumber *)reactTag fullscreen:(BOOL)fullscreen;
- (void)setPaused:(nonnull NSNumber *)reactTag paused:(BOOL)paused;
- (void)setVolume:(nonnull NSNumber *)reactTag volume:(float)volume;

@end

// Export the video view
@interface RCTVideo : UIView

@property (nonatomic, copy) RCTDirectEventBlock onVideoLoadStart;
@property (nonatomic, copy) RCTDirectEventBlock onVideoLoad;
@property (nonatomic, copy) RCTDirectEventBlock onVideoBuffer;
@property (nonatomic, copy) RCTDirectEventBlock onVideoError;
@property (nonatomic, copy) RCTDirectEventBlock onVideoProgress;
@property (nonatomic, copy) RCTDirectEventBlock onVideoSeek;
@property (nonatomic, copy) RCTDirectEventBlock onVideoEnd;
@property (nonatomic, copy) RCTDirectEventBlock onReadyForDisplay;
@property (nonatomic, copy) RCTDirectEventBlock onPlaybackRateChange;
@property (nonatomic, copy) RCTDirectEventBlock onFullscreenPlayerWillPresent;
@property (nonatomic, copy) RCTDirectEventBlock onFullscreenPlayerDidPresent;
@property (nonatomic, copy) RCTDirectEventBlock onFullscreenPlayerWillDismiss;
@property (nonatomic, copy) RCTDirectEventBlock onFullscreenPlayerDidDismiss;

- (instancetype)initWithEventDispatcher:(RCTEventDispatcher *)eventDispatcher NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END