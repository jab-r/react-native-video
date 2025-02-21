#import "VideoComponentView.h"
#import "../Video/RCTVideoSwiftLog/RCTVideoSwiftLog.h"
#import "RCTVideo.h"

#ifdef RCT_NEW_ARCH_ENABLED
#import <react/renderer/components/VideoModuleSpecs/ComponentDescriptors.h>
#import <react/renderer/components/VideoModuleSpecs/EventEmitters.h>
#import <react/renderer/components/VideoModuleSpecs/Props.h>
#import <react/renderer/components/VideoModuleSpecs/RCTComponentViewHelpers.h>
#import "RCTFabricComponentsPlugins.h"

using namespace facebook::react;
#endif

#ifdef RCT_NEW_ARCH_ENABLED
@interface VideoComponentView () <RCTVideoComponentViewProtocol>
@end

@implementation VideoComponentView {
    RCTVideo *_videoView;
    VideoEventEmitter _eventEmitter;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    RCTLogInfo(@"[VideoModule] Initializing VideoComponentView");
    if (self = [super initWithFrame:frame]) {
        static const auto defaultProps = std::make_shared<const VideoProps>();
        _props = defaultProps;
        
        _videoView = [[RCTVideo alloc] initWithEventDispatcher:self.eventDispatcher];
        self.contentView = _videoView;
        RCTLogInfo(@"[VideoModule] VideoComponentView initialized");
    }
    
    return self;
}

#pragma mark - RCTComponentViewProtocol

+ (ComponentDescriptorProvider)componentDescriptorProvider
{
    RCTLogInfo(@"[VideoModule] Getting component descriptor provider");
    return concreteComponentDescriptorProvider<VideoComponentDescriptor>();
}
#else
@implementation VideoComponentView
#endif

#ifdef RCT_NEW_ARCH_ENABLED
- (void)updateProps:(const Props::Shared &)props oldProps:(const Props::Shared &)oldProps
{
    RCTLogInfo(@"[VideoModule] Starting props update");
    const auto &oldVideoProps = *std::static_pointer_cast<const VideoProps>(_props);
    const auto &newVideoProps = *std::static_pointer_cast<const VideoProps>(props);

    if (oldVideoProps.src != newVideoProps.src) {
        NSDictionary *src = @{
            @"uri": newVideoProps.src.uri ?: [NSNull null],
            @"type": newVideoProps.src.type ?: [NSNull null],
            @"isNetwork": @(newVideoProps.src.isNetwork),
            @"isAsset": @(newVideoProps.src.isAsset)
        };
        RCTLogInfo(@"[VideoModule] Setting source: %@", src);
        [_videoView setSrc:src];
    }
    
    if (oldVideoProps.controls != newVideoProps.controls) {
        RCTLogInfo(@"[VideoModule] Setting controls: %@", newVideoProps.controls ? @"YES" : @"NO");
        [_videoView setControls:newVideoProps.controls];
    }
    
    if (oldVideoProps.paused != newVideoProps.paused) {
        RCTLogInfo(@"[VideoModule] Setting paused: %@", newVideoProps.paused ? @"YES" : @"NO");
        [_videoView setPaused:newVideoProps.paused];
    }
    
    if (oldVideoProps.muted != newVideoProps.muted) {
        RCTLogInfo(@"[VideoModule] Setting muted: %@", newVideoProps.muted ? @"YES" : @"NO");
        [_videoView setMuted:newVideoProps.muted];
    }
    
    if (oldVideoProps.volume != newVideoProps.volume) {
        RCTLogInfo(@"[VideoModule] Setting volume: %f", newVideoProps.volume);
        [_videoView setVolume:newVideoProps.volume];
    }
    
    if (oldVideoProps.resizeMode != newVideoProps.resizeMode) {
        RCTLogInfo(@"[VideoModule] Setting resizeMode: %@", RCTNSStringFromString(newVideoProps.resizeMode));
        [_videoView setResizeMode:RCTNSStringFromString(newVideoProps.resizeMode)];
    }
    
    if (oldVideoProps.repeat != newVideoProps.repeat) {
        RCTLogInfo(@"[VideoModule] Setting repeat: %@", newVideoProps.repeat ? @"YES" : @"NO");
        [_videoView setRepeat:newVideoProps.repeat];
    }
    
    if (oldVideoProps.rate != newVideoProps.rate) {
        RCTLogInfo(@"[VideoModule] Setting rate: %f", newVideoProps.rate);
        [_videoView setRate:newVideoProps.rate];
    }

    [super updateProps:props oldProps:oldProps];
    RCTLogInfo(@"[VideoModule] Finished props update");
}
#endif

#ifdef RCT_NEW_ARCH_ENABLED
#pragma mark - Event Handling

- (void)handleVideoLoad:(NSDictionary *)event
{
    RCTLogInfo(@"[VideoModule] Handling video load event: %@", event);
    if (_eventEmitter.onVideoLoad) {
        _eventEmitter.onVideoLoad(VideoLoadEvent{
            .duration = [event[@"duration"] doubleValue],
            .currentTime = [event[@"currentTime"] doubleValue],
            .naturalSize = {
                .width = [event[@"naturalSize"][@"width"] floatValue],
                .height = [event[@"naturalSize"][@"height"] floatValue],
                .orientation = toString(event[@"naturalSize"][@"orientation"])
            }
        });
    }
}

- (void)handleVideoError:(NSDictionary *)event
{
    RCTLogInfo(@"[VideoModule] Handling video error event: %@", event);
    if (_eventEmitter.onVideoError) {
        _eventEmitter.onVideoError(VideoErrorEvent{
            .error = {
                .code = [event[@"error"][@"code"] intValue],
                .domain = toString(event[@"error"][@"domain"]),
                .localizedDescription = toString(event[@"error"][@"localizedDescription"])
            }
        });
    }
}

- (void)handleVideoProgress:(NSDictionary *)event
{
    RCTLogInfo(@"[VideoModule] Handling video progress event: %@", event);
    if (_eventEmitter.onVideoProgress) {
        _eventEmitter.onVideoProgress(VideoProgressEvent{
            .currentTime = [event[@"currentTime"] doubleValue],
            .playableDuration = [event[@"playableDuration"] doubleValue],
            .seekableDuration = [event[@"seekableDuration"] doubleValue]
        });
    }
}
#endif

@end