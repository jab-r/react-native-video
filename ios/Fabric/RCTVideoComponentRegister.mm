#import <React/RCTLog.h>
#import <React/RCTUIManager.h>
#import <React/RCTViewManager.h>
#import <react/renderer/componentregistry/ComponentDescriptorProviderRegistry.h>
#import <react/renderer/componentregistry/ComponentDescriptorRegistry.h>

#import "VideoComponentView.h"

using namespace facebook::react;

@interface RCTVideoComponentRegister : NSObject
@end

@implementation RCTVideoComponentRegister

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        auto providerRegistry = std::make_shared<ComponentDescriptorProviderRegistry>();
        providerRegistry->add(concreteComponentDescriptorProvider<VideoComponentDescriptor>());
        
        RCTSetFabricComponentsRegistry(providerRegistry);
    });
}

@end

#ifdef RCT_NEW_ARCH_ENABLED
Class<RCTComponentViewProtocol> RCTVideoCls(void)
{
    return VideoComponentView.class;
}
#endif