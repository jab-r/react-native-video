#import "VideoComponentView.h"

#import <react/renderer/components/VideoModuleSpecs/ComponentDescriptors.h>
#import <react/renderer/components/VideoModuleSpecs/EventEmitters.h>
#import <react/renderer/components/VideoModuleSpecs/Props.h>
#import <react/renderer/components/VideoModuleSpecs/RCTComponentViewHelpers.h>

#import "RCTFabricComponentsPlugins.h"
#import "RCTVideo.h"

using namespace facebook::react;

@interface VideoComponentView () <RCTVideoComponentViewProtocol>
@end

@implementation VideoComponentView {
    RCTVideo *_videoView;
    VideoEventEmitter _eventEmitter;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        static const auto defaultProps = std::make_shared<const VideoProps>();
        _props = defaultProps;
        
        _videoView = [[RCTVideo alloc] initWithEventDispatcher:self.eventDispatcher];
        self.contentView = _videoView;
    }
    
    return self;
}

#pragma mark - RCTComponentViewProtocol

+ (ComponentDescriptorProvider)componentDescriptorProvider
{
    return concreteComponentDescriptorProvider<VideoComponentDescriptor>();
}

- (void)updateProps:(const Props::Shared &)props oldProps:(const Props::Shared &)oldProps
{
    const auto &oldVideoProps = *std::static_pointer_cast<const VideoProps>(_props);
    const auto &newVideoProps = *std::static_pointer_cast<const VideoProps>(props);

    // Handle prop updates
    if (oldVideoProps.src != newVideoProps.src) {
        [_videoView setSrc:RCTBridgingToJSON(newVideoProps.src)];
    }
    
    if (oldVideoProps.controls != newVideoProps.controls) {
        [_videoView setControls:newVideoProps.controls];
    }
    
    if (oldVideoProps.paused != newVideoProps.paused) {
        [_videoView setPaused:newVideoProps.paused];
    }
    
    if (oldVideoProps.muted != newVideoProps.muted) {
        [_videoView setMuted:newVideoProps.muted];
    }
    
    if (oldVideoProps.volume != newVideoProps.volume) {
        [_videoView setVolume:newVideoProps.volume];
    }
    
    if (oldVideoProps.resizeMode != newVideoProps.resizeMode) {
        [_videoView setResizeMode:RCTNSStringFromString(newVideoProps.resizeMode)];
    }
    
    if (oldVideoProps.repeat != newVideoProps.repeat) {
        [_videoView setRepeat:newVideoProps.repeat];
    }
    
    if (oldVideoProps.rate != newVideoProps.rate) {
        [_videoView setRate:newVideoProps.rate];
    }

    [super updateProps:props oldProps:oldProps];
}

#pragma mark - Event Handling

- (void)handleVideoLoad:(NSDictionary *)event
{
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
    if (_eventEmitter.onVideoProgress) {
        _eventEmitter.onVideoProgress(VideoProgressEvent{
            .currentTime = [event[@"currentTime"] doubleValue],
            .playableDuration = [event[@"playableDuration"] doubleValue],
            .seekableDuration = [event[@"seekableDuration"] doubleValue]
        });
    }
}

@end

Class<RCTComponentViewProtocol> VideoCls(void)
{
    return VideoComponentView.class;
}