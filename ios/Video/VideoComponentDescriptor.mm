#import <React/RCTComponentDescriptor.h>
#import <react/renderer/components/VideoModuleSpecs/ComponentDescriptors.h>
#import <react/renderer/components/VideoModuleSpecs/EventEmitters.h>
#import <react/renderer/components/VideoModuleSpecs/Props.h>
#import <react/renderer/components/VideoModuleSpecs/RCTComponentViewHelpers.h>

using namespace facebook::react;

@interface VideoComponentDescriptor : ConcreteComponentDescriptor<VideoComponentProps>
@end

@implementation VideoComponentDescriptor

+ (ComponentDescriptorProvider)componentDescriptorProvider
{
    return concreteComponentDescriptorProvider<VideoComponentDescriptor>();
}

- (instancetype)initWithEventDispatcher:(const EventDispatcher::Shared &)eventDispatcher
                     contextContainer:(const ContextContainer::Shared &)contextContainer
{
    if (self = [super initWithEventDispatcher:eventDispatcher contextContainer:contextContainer]) {
        // Initialize any required state
    }
    return self;
}

@end

Class<RCTComponentViewProtocol> VideoComponentCls(void)
{
    return VideoComponentDescriptor.class;
}