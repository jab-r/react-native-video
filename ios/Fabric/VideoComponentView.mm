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

    // Handle prop updates here
    if (oldVideoProps.source != newVideoProps.source) {
        // Update source
        [_videoView setSrc:newVideoProps.source];
    }

    // Update other props as needed
    [super updateProps:props oldProps:oldProps];
}

@end

Class<RCTComponentViewProtocol> VideoCls(void)
{
    return VideoComponentView.class;
}